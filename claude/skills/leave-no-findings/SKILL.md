---
name: leave-no-findings
description: >-
  Write the change so a reviewer has nothing to report. Checks that catch the
  defects automated and human reviewers actually raise, before you commit.
  Use while implementing or refactoring, and as a last pass before pushing.
---

# Leave no findings

Every one of these is a finding a reviewer wrote after the fact. Each takes
under a minute to prevent and a full review cycle to fix.

## One accessor per piece of state

Adding a richer accessor without deleting the old one forks the truth. Both
return the same state today; the next edit changes one of them.

You add `getStatusFor(x)` returning a phase, and leave `isBusyFor(x)` in place
because callers use it. Now the disabled-state and the label read different
accessors, and nothing stops them disagreeing.

Delete the old one in the same change and migrate the callers. If that is too
big, say so in the PR — don't leave both and hope.

The harder half is the fork that was already there. Before you extend a
derivation — "is this empty", "did this change", "what label does this show",
"apply this mutation" — count how many implementations of it exist. Two
reducers for one mutation type, three label builders, two emptiness checks:
each looks like one site while you are inside it. Extending one of them and
leaving the others is indistinguishable, in the diff, from there only being
one. Say the concept out loud and grep for it before you edit, not after.

Ask again when you consolidate, not just when you add. Unifying two of three
copies is worse than leaving three: the extracted helper now carries a docstring
promising one home for the logic, and the copy you missed silently disproves it.
Count the implementations at the moment you decide to extract.

## Match the lifetime unit to the display unit

Anything with a lifetime (timer, cache entry, debounce, subscription) must be
keyed by the same unit as the thing it governs.

A completion notice was armed per job while the count summed every job for the
day. First job's timer fires, its row is dropped, the second job finishes, and
the notice reports 5 where it should say 8.

Better still: derive the lifetime from the projected value rather than arming
it at an event. An effect keyed on the derived state cannot drift from it,
because the state is what starts and stops it.

Before writing the timer, say the two units out loud: "the timer is per ___,
the display aggregates per ___." Same word twice or fix it.

## Replacing a container means auditing what it carried

Swapping out a header, toolbar, layout wrapper, or modal chrome silently
removes everything it held: back affordance, title, overflow actions, dismiss.

Replacing a navigation header with a status banner also deleted the only back
button on a screen whose tab bar was hidden. The mockup showed no back button,
so the mockup was followed and the affordance went with it.

Enumerate what the container provides, then decide per item whether the
replacement carries it. A mockup omitting something is not the same as a
decision to remove it.

## A new human-readable string can collide with an existing selector

Anywhere tests or automation match on visible text, adding a string is adding a
selector. If it equals text that already exists elsewhere, matches that used to
be unique now hit two places, and the older assertion silently weakens.

An icon button was given the label 設定. The Settings screen's own navigation
title was already 設定, and the button lives on the *home* screen. A test that
waited for 設定 to confirm it had navigated started passing before navigating.
Green, and blind. Renaming the label to 設定を開く restored it.

That direction is the dangerous one: the new string doesn't break a test, it
makes a passing test stop proving anything. Nothing goes red to warn you.

After adding user-visible strings, grep the automation and test suites for each
one. Anything with a hit needs a look at what that selector was pinning. Check
the matcher's semantics too, since it decides whether a collision exists at all
— full-string matching makes 設定を開く distinct from 設定, substring matching
would not.

## Never write a claim your own diff contradicts

Applies to justifications, and just as much to any rule or convention you
author. Check it against the change in your working tree right now.

"Only lasts a few seconds, and swipe-back still works" was written in the same
commit that raised the polling ceiling to ~18 minutes, on a platform with no
swipe-back. Wrong in both halves, checkable in two greps.

Worse, because it looks like diligence: a docs rule saying "never use
accessibilityLabel as a selector" landed in the same PR that added two
selectors resolvable only by accessibilityLabel. Absolute words — never,
always, all — are the trap. Before writing one, grep your own diff for the
exception. If there is one, either remove it or write the rule with its bounds.

Load-bearing claims get read as verified. Verify them or don't write them.

## A migration can delete coverage without deleting tests

Moving assertions from one attribute to another leaves the old attribute
pinned by nothing. The test count doesn't drop, so nothing signals it.

136 assertions moved from `accessibilityLabel` to `testID`. Every test still
passed, and label *values* now had zero coverage — so a label could be changed
to a string that broke two E2E flows with the whole suite green.

After a mechanical move, name the dimension you just stopped asserting on, and
decide deliberately whether it needs one test back. Usually one is enough.

## Changing a convention leaves its teachers behind

Docs, skills, templates, generators, and lint rules that describe the old way
keep teaching it after you've removed it. The next person follows them and
reintroduces exactly what you deleted.

A migration moved test identifiers off `accessibilityLabel`; the QA doc still
said to prefer `accessibilityLabel` for element selection, in prose and in an
architecture diagram.

Grep for the old mechanism by name across docs and tooling, not just source.
Diagrams and tables count.

## Test doubles are part of the contract

Two failures a typechecker cannot see, because mock factories and hand-written
stubs are never typechecked against the real thing.

**Stale double.** You rename or remove something a module exports; a double
still returns the old shape. Tests pass because the consumer is mocked too.
After changing any exported shape, grep the doubles for the old name — call
sites alone will not find it.

**Impossible fixture.** Two values that derive from one source, set
inconsistently in a double: `isBusy: true` beside `status: 'idle'`. Production
cannot produce that pair, so the test guards nothing and stays green through a
real regression. If two values share a source, the double must set them the way
the source would.

## A test you did not watch fail is not evidence

A test written after the fix is shaped by the fix. Prove it can fail:

```bash
git stash push -- path/to/source.ts   # ONLY the source; keep the new test
<run that one test>                    # must go red
git stash pop
```

Whole-tree `git stash` takes the test with it and proves nothing.

And build the case from the reported repro, not your model of it. A timing bug
that fires past a 4-second window was tested with a 3-second gap, so it passed
before and after the fix. The repro said 4+.

## A field threaded through layers needs a falsification per layer

Adding one field to an event, a command, a projection, an entity, a query and
a response is six changes, not one. Testing the ends and assuming the middle
is how the middle ships broken.

Every finding across three review rounds of one such change was the same: the
code was correct, and nothing proved it stayed correct. Untested were the
aggregate adapter's preserve-on-absent fallback, one entire write path's
validation, the projection line for one of four events, and — the sharpest one
— the response object added *specifically to fix a data-loss finding*.

**Enumerate by the sibling field, not the new one.** Grepping `newField` finds
only the sites you already edited, so it can never show you the one you missed.
Grep what the new field travels beside — the existing field with the same
lifecycle — and that list is the denominator:

```bash
grep -rl '\<siblingField\>' <source dirs>              # sites that must handle it
git diff main -- '<source dirs>' | grep -c newField    # sites you actually did
```

Any file in the first list and not the second is either a deliberate skip you
can name or a bug. Do this before the first edit: it costs one command, and it
is the only step that finds a second copy of a reducer, a third implementation
of a label, or the one screen whose mapper hardcodes an empty value.

Sweep the untyped files too. A required prop or parameter is enforced by the
typechecker only where the typechecker looks — `.js` test helpers and fixtures
are outside it, so they keep passing the old shape and stay green while
asserting a contract that no longer exists. When you add or rename a required
name, grep the whole tree for the old one, not just the typed sources.

Then for each site, delete the line and run the suite. A site where nothing
goes red is a site with no coverage, regardless of how green the run looks.

Two shapes hide from this. A field with a default compiles everywhere it is
missing, so absence never surfaces as an error. And a fixture that constructs
the object directly bypasses the mapping you meant to test — assert on what
the layer *produces*, not on what you handed it.

## A rule that compares two things needs every arrangement

The ticket narrates one arrangement. You will test that one, several times, in
several shapes, and never write its mirror image.

A rule preferring the recording staff member's own class was added because a
neighbouring class's child kept ranking first. Every test put the preferred
child *behind*. Nobody wrote it ahead. It was skipped there by the guard that
kept the rule off ordinary confirmations, so a child leading 0.90 to 0.88 was
held while the same pair reversed was confirmed.

For any comparison the rule keys on, test A above B, B above A, and equal. The
motivating example is one point in that space, and it anchors you hard.

Then check the property, not just the examples: **is the outcome monotonic?**
If raising a candidate's score flips it from confirmed to rejected, the logic
is wrong no matter what the tests say. That question takes a second, needs no
new fixtures, and catches the whole class at once.

A related smell in the code itself. If a new rule sits *before* existing logic
and needs a guard to stop it firing on cases the old path already handled, it
is in the wrong place. Move it after, as a fallback on the specific outcome it
means to override. The guard disappears, and with it the arrangement it got
wrong. Placement fixed both findings here; adding conditions had not.

## Fetch the binding artifact before scoping

Issue prose summarises; the attached mockup or linked spec decides. Scoping
down from the summary, when the artifact was one command away, reads as caution
and lands as rework.

On GitHub, `gh api` retrieves `user-attachments` images that plain `curl` 404s:

```bash
gh api -H "Accept: application/vnd.github.raw" "<attachment-url>" > spec.png
```

Then read it. Requirements marked optional in prose are often specified
concretely in the picture.
