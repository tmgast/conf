#!/usr/bin/env python3
"""PreToolUse hook: deny Bash commands that change files through the shell.

Files are changed with the Edit and Write tools so every change lands as a
reviewable diff. This hook reads the Claude Code hook payload on stdin and
denies a Bash command that would mutate a file another way: sed -i, perl -i,
tee, a > or >> redirect into a path, or a python/ruby/node/perl one-liner or
heredoc body that writes. Redirect and tee targets under /tmp, $TMPDIR, /dev,
or a scratchpad directory stay allowed so throwaway scripts and logs still
work; sed -i and perl -i are denied regardless of target. Heredoc bodies are
cut out and the rest is tokenised with shell quoting rules, so a > inside a
commit message or grep pattern is not read as a redirect. Writes hidden inside
a quoted program, such as an awk action, are out of reach here and left to the
auto-mode classifier.
"""

import json
import re
import shlex
import sys

REDIRECTS = {">", ">>", ">|", "&>", "&>>"}
PUNCTUATION = set("();<>|&")
INTERPRETERS = {"python", "python3", "ruby", "node", "perl"}
INLINE_FLAGS = {"-c", "-e"}
ALLOWED_PREFIXES = (
    "/tmp",
    "/private/tmp",
    "/var/folders",
    "/dev/",
    "$TMPDIR",
    "${TMPDIR}",
)
HEREDOC_MARKER = re.compile(r"(?<!<)<<-?\s*(['\"]?)(\w+)\1(?!<)")
SED_IN_PLACE = re.compile(r"^(-[a-zA-Z]*i|--in-place)")
PERL_IN_PLACE = re.compile(r"^-[pnlaw]*i")
WRITE_CALL = re.compile(
    r"open\([^)]*['\"][wa]|open\([^)]*['\"]>|\.write\(|write_(text|bytes)\(|"
    r"writeFile|File\.(write|open)"
)


def extract_heredocs(command):
    """Remove heredoc markers and bodies, returning the remainder and the bodies."""
    bodies = []
    while True:
        marker = HEREDOC_MARKER.search(command)
        if not marker:
            return command, bodies
        header_end = command.find("\n", marker.end())
        if header_end == -1:
            return command[: marker.start()] + command[marker.end() :], bodies
        body_start = header_end + 1
        terminator = re.compile(
            rf"^[ \t]*{re.escape(marker.group(2))}[ \t]*$", re.MULTILINE
        ).search(command, body_start)
        body_end = terminator.end() if terminator else len(command)
        bodies.append(command[body_start:body_end])
        command = (
            command[: marker.start()]
            + command[marker.end() : body_start]
            + command[body_end:]
        )


def tokenize(text):
    """Split shell text into tokens with quotes resolved and operators separated."""
    lexer = shlex.shlex(text.replace("\n", " ; "), posix=True, punctuation_chars=True)
    lexer.whitespace_split = True
    return list(lexer)


def is_operator(token):
    return bool(token) and all(c in PUNCTUATION for c in token)


def allowed_target(target):
    return target.startswith(ALLOWED_PREFIXES) or "/scratchpad" in target


def args_until_boundary(tokens, start):
    """Return the tokens after position start up to the next shell operator."""
    args = []
    for token in tokens[start + 1 :]:
        if is_operator(token):
            break
        args.append(token)
    return args


def first_match(args, pattern):
    return next((a for a in args if pattern.match(a)), None)


def decide(command):
    """Return a denial reason when command mutates a file through the shell."""
    rest, bodies = extract_heredocs(command)
    try:
        tokens = tokenize(rest)
    except ValueError:
        return None
    for i, token in enumerate(tokens):
        following = tokens[i + 1] if i + 1 < len(tokens) else ""
        if token in REDIRECTS and following and not is_operator(following):
            if not allowed_target(following):
                return f"redirect into {following}"
        args = args_until_boundary(tokens, i)
        if token == "sed":
            flag = first_match(args, SED_IN_PLACE)
            if flag:
                return f"sed {flag} edits in place"
        elif token == "perl":
            flag = first_match(args, PERL_IN_PLACE)
            if flag:
                return f"perl {flag} edits in place"
        elif token == "tee":
            target = next(
                (a for a in args if not a.startswith("-") and not allowed_target(a)),
                None,
            )
            if target:
                return f"tee into {target}"
        if token in INTERPRETERS:
            inline = [a for j, a in enumerate(args) if j and args[j - 1] in INLINE_FLAGS]
            if any(WRITE_CALL.search(text) for text in inline + bodies):
                return f"{token} script writes a file"
    return None


def main():
    try:
        payload = json.load(sys.stdin)
    except (json.JSONDecodeError, ValueError):
        return 0
    if payload.get("tool_name") != "Bash":
        return 0
    command = (payload.get("tool_input") or {}).get("command", "")
    reason = decide(command)
    if not reason:
        return 0
    print(
        json.dumps(
            {
                "hookSpecificOutput": {
                    "hookEventName": "PreToolUse",
                    "permissionDecision": "deny",
                    "permissionDecisionReason": (
                        f"no-shell-edits: {reason}. Files are read with the Read "
                        "tool and changed with Edit or Write; redo this with those. "
                        "Only targets under /tmp or the scratchpad may be written "
                        "from the shell."
                    ),
                }
            }
        )
    )
    return 0


if __name__ == "__main__":
    sys.exit(main())
