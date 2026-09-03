#!/usr/bin/env python3
"""PostToolUse hook: flag low-value comments in freshly written JS/TS/Vue code.

Reads the Claude Code hook payload on stdin and scans only the text that the
Write/Edit/MultiEdit call introduced. Proper JSDoc (/** ... */) and tooling
directives (eslint-disable, @ts-expect-error, ...) are allowed; bare // line
comments, /* ... */ block comments, and <!-- ... --> template comments are
reported. Strings and template literals are skipped so URLs and code are never
mistaken for comments. Exits 2 with a stderr nudge when violations are found so
the write is not reverted, only flagged.

Go is intentionally out of scope: idiomatic GoDoc uses //.
"""

import json
import re
import sys

SCANNED_EXT = {"ts", "tsx", "js", "jsx", "mjs", "cjs", "vue"}

ALLOW = re.compile(
    r"eslint-(disable|enable)|@ts-(ignore|expect-error|nocheck|check)|"
    r"prettier-ignore|biome-ignore|istanbul ignore|[cv]8 ignore|"
    r"noinspection|@vite-ignore|webpackChunkName|@__PURE__|"
    r"type-coverage:ignore|<reference\b",
    re.IGNORECASE,
)


def find_comments(text):
    """Return (line, kind, snippet) for each comment, skipping string bodies."""
    out = []
    i, n, line = 0, len(text), 1
    quote = None
    while i < n:
        c = text[i]
        nxt = text[i + 1] if i + 1 < n else ""
        if c == "\n":
            line += 1
            i += 1
        elif quote:
            if c == "\\":
                i += 2
            else:
                if c == quote:
                    quote = None
                elif c == "\n":
                    line += 1
                i += 1
        elif c in "\"'`":
            quote = c
            i += 1
        elif c == "/" and nxt == "/":
            end = text.find("\n", i)
            end = n if end == -1 else end
            out.append((line, "line", text[i:end].strip()))
            i = end
        elif c == "/" and nxt == "*":
            close = text.find("*/", i + 2)
            close = n if close == -1 else close + 2
            block = text[i:close]
            kind = "jsdoc" if block.startswith("/**") else "block"
            out.append((line, kind, block.replace("\n", " ").strip()[:60]))
            line += block.count("\n")
            i = close
        elif c == "<" and text[i : i + 4] == "<!--":
            close = text.find("-->", i + 4)
            close = n if close == -1 else close + 3
            block = text[i:close]
            out.append((line, "html", block.replace("\n", " ").strip()[:60]))
            line += block.count("\n")
            i = close
        else:
            i += 1
    return out


def added_text(tool_name, tool_input):
    if tool_name == "Write":
        return tool_input.get("content", "")
    if tool_name == "Edit":
        return tool_input.get("new_string", "")
    if tool_name == "MultiEdit":
        return "\n".join(
            e.get("new_string", "") for e in tool_input.get("edits", [])
        )
    return ""


def main():
    try:
        payload = json.load(sys.stdin)
    except (json.JSONDecodeError, ValueError):
        return 0

    tool_name = payload.get("tool_name") or payload.get("toolName") or ""
    tool_input = payload.get("tool_input") or payload.get("toolArgs") or {}
    if tool_name not in {"Write", "Edit", "MultiEdit"}:
        return 0

    file_path = tool_input.get("file_path", "")
    ext = file_path.rsplit(".", 1)[-1].lower() if "." in file_path else ""
    if ext not in SCANNED_EXT:
        return 0

    violations = [
        (ln, snippet)
        for ln, kind, snippet in find_comments(added_text(tool_name, tool_input))
        if kind != "jsdoc" and not ALLOW.search(snippet)
    ]
    if not violations:
        return 0

    lines = "\n".join(f"  L{ln}: {snippet}" for ln, snippet in violations)
    sys.stderr.write(
        f"[no-trash-comments] {file_path}: "
        f"{len(violations)} comment(s) violate the no-inline-comments rule.\n"
        f"{lines}\n"
        "Self-documenting code is preferred. Allowed: JSDoc (/** ... */) on a "
        "class or public method, and a terse WHY-comment for genuinely "
        "non-obvious logic. Remove the rest.\n"
    )
    return 2


if __name__ == "__main__":
    sys.exit(main())
