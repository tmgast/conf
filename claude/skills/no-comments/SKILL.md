---
name: no-comments
description: >-
  Spawn Comment Sicko over a diff, fix accepted findings, and offer encodings for
  claimed constraints. Use for an audit pass over existing or changed code.
  Triggers "no comments", "strip the comments", "comment audit", "sicko this".
---

# No comments

Spawn Comment Sicko. Act on accepted findings.

Authoring agents defend comments. Defer to Comment Sicko's fresh perspective.

## Scope

Use the caller's files or diff. Otherwise use the current diff against the base
branch, default `main`, including the working tree.

## Steps

1. Spawn the `Agent` tool with `subagent_type: "comment-sicko"`. Pass the scope.
   Do not restate its rules.

2. Inspect its report and diff. Reject application-code edits, scope escapes,
   exception-protected deletions, misstated `MUST KILL` reasons, and flags that
   treat kept intentional code as guilty. Reshape flags on our-code surprises
   stay actionable. Do not restore those comments. A keep survives only with
   proof it is about something we cannot change. Audit missed scoped lint and
   type-checker suppressions. Correctness or safety suppressions stay actionable
   `MUST KILL`s. Restore deletions only with exact exceptions and scoped proof.
   Before accepting thin `IMPORTANT` or `do not remove` kills or keeps, run the
   history hunt yourself on their symbol: `git log -S`, `git blame`, and the
   merged PR body. If a kill is ambiguous, do not restore. If a keep is refuted
   or still ambiguous, delete it. Revert and rerun one rejected report with the
   failure named. Reject a second, report it open, and fail this skill.

3. Fix trivial accepted flags directly by deleting a dead path, dropping a
   parameter, or using the real API. If any fix needs a shape, sketch the new
   signatures and types for the accepted set and the surrounding code first, and
   stop at the sketch. Step 4 implements.

4. Implement the smallest root-cause fix in scope. Remove every named
   workaround. If the root cause is out of scope, land the smallest in-scope fix
   and report the rest open. Fix real causes and redesign as if the requirements
   had always existed. Never bolt on a symptom guard. Neither of those widens
   the fence: do not fix instances outside the stated scope.

5. Constraint comments say `do not remove`, `do not change wording`, or `talk to
   X before changing`. Leave keeps about things we cannot change. Offer the
   cheapest in-scope type, runtime check, test, or CI lint that makes the
   constraint enforceable. Wait for approval. If approved, encode then delete.
   Otherwise delete, report the constraint open, and sketch the out-of-scope
   work.

6. Report the deletion count, restored comments, reruns, the shape sketch,
   fixes, encoding offers, encodings, unenforced constraints, and other open
   work.

## Relationship to comment-discipline

This skill is the audit pass. `comment-discipline` is the write-time rule that
stops the comment being written at all. They share one keep-list. A cleanup pass
alone has been measured to fail, so run both.
