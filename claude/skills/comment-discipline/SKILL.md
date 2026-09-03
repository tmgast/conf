---
name: comment-discipline
description: >-
  Write code that needs no comments, with docblocks where they earn their place.
  Use when writing or editing any code. Triggers "no comments", "too many
  comments", "clean up the comments", "why is this commented". For an audit pass
  over an existing diff, use the no-comments skill instead.
---

# Comment discipline

Default to no comments. The code says what it does. A docblock says what a
public thing is for. Nothing else earns a line.

Write it clean as you go. A cleanup pass afterward has been measured to fail, so
never write the bad comment in the first place. This applies to every file you
produce, including throwaway verify scripts and any subagent's diff you own.

## The keep-list

These five survive. Nothing else does. This list is shared with the
`no-comments` skill and its Comment Sicko subagent, so the two never disagree.

1. Legal or license headers.
2. Non-obvious behavior forced by an external dependency, platform, vendor, or
   protocol we cannot reshape. Cite it.
3. `// prettier-ignore` and similar formatter directives. Lint suppressions
   survive only when the rule is faulty, pedantic, or style-only.
4. Doc comments that define a public API contract. JSDoc, TSDoc, KDoc, GoDoc.
5. Issue or RFC links that explain a constraint the code cannot express.

When you are not sure a keep clause applies, the comment does not survive.

## Complexity is not an exception

A comment that exists to make hard code legible is a signal to simplify, not a
licence to annotate. We write code a person maintains at a glance. If a reader
needs prose to follow the logic, split the function, name the intermediate
value, or lift the branch into a type. Then the comment has nothing left to say.

"It cannot be simplified" is almost always false. Treat it as a refactor task,
not a keep.

## Always delete

- **Narrating comments.** `// Phase 1: add cards`, `// loop over users`,
  `// set the flag`. The line below already says this.
- **Restating the signature.** `// returns the user id` above `getUserId()`.
- **Section banners.** `// ---- helpers ----`, `// === setup ===`.
- **Commented-out code.** Git has it.
- **TODO with no owner and no issue.** File it or fix it.
- **Changelog comments.** `// added 2026-08-20 by X`, `// was 5, now 10`.
- **Comments the surrounding file does not use.** If no neighbouring function
  carries one, yours does not either.

The case that keeps recurring is a verify or test script narrating its own
phases. Delete the narration and put the meaning in the assertion or the log
string. Write `assert(ok, 'persisted across restart')`, not a `// move the card`
line plus the code.

## Writing the docblock

A docblock states what the thing is for and what a caller must know: contract,
invariants, units, ownership, failure modes. It does not respell the parameter
list in prose. If every `@param` line just repeats the parameter name, drop them
and keep the summary.

## Writing the external-constraint comment

Write the *why*, and cite the source.

```ts
// Chrome fires pointercancel before pointerup on touch. Upstream: crbug.com/1234567
```

Never the *what*. A comment that explains what the line does means the line is
wrong, not that it is under-commented. A long justification with no citation is
a confession. Delete it and fix the code.

## Prefer structure over a comment

If a comment warns the reader not to do something, make the wrong thing
impossible instead. A type constraint, a lint rule, or a runtime check beats
prose someone has to remember to read.

## Reviewing your own diff

For every comment, ask in order.

- Does deleting it lose information? If not, delete it.
- Does it hit one of the five keep-list clauses? If not, delete it.
- Is it a docblock? Check it states a contract rather than restating the name.
- Is it an external constraint? Check it cites the source.
- Is it there because the code is hard to read? Simplify the code and delete it.
