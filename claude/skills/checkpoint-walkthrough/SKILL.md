---
name: checkpoint-walkthrough
description: Interactive step-by-step walkthrough where Claude stops at each checkpoint for discussion and clarification before proceeding. Use when learning a new codebase, reviewing complex changes, or wanting to understand each piece before moving forward.
---

# Checkpoint Walkthrough

**Quick Reference:** Stop at each step, explain in detail, wait for questions.

---

## When to Use

Invoke when user says:
- "checkpoint walkthrough"
- "step through this with me"
- "guided tour"
- "one thing at a time"
- "walk me through this"
- "explain as we go"

---

## Behavior

### DO:
1. **Break into checkpoints** - Identify discrete logical steps before starting
2. **One at a time** - Present ONLY the current checkpoint
3. **Full detail** - Explain what it is, why it's needed, how it works
4. **Show the code** - Include actual code/content, not just descriptions
5. **Explain connections** - How this piece relates to others
6. **Wait for signal** - End with "Questions about this piece?" and STOP
7. **Only proceed when told** - Wait for explicit "continue", "next", "looks good", etc.

### DO NOT:
- Give an overview of all steps upfront
- Batch multiple checkpoints together
- Rush through explanations
- Assume understanding without confirmation
- Proceed without user acknowledgment

---

## Checkpoint Format

```
**Checkpoint N: [Descriptive Name]**

[2-4 sentence explanation of what this piece does and why it's needed]

[Code block with actual implementation]

**How it works:**
- [Bullet point explaining mechanism 1]
- [Bullet point explaining mechanism 2]
- [etc.]

**Connects to:**
- [How this relates to previous/next checkpoints]
- [Dependencies or dependents]

Questions about this piece?
```

---

## Example Flow

**User:** "Let's do a checkpoint walkthrough of adding authentication"

**Claude:**
```
I'll walk through this step by step. We have 4 checkpoints:
1. Auth middleware
2. Token validation
3. User context
4. Protected routes

---

**Checkpoint 1: Auth Middleware**

This is the entry point that intercepts every request and checks for authentication...

[detailed explanation + code]

Questions about this piece?
```

**User:** "What happens if the token is expired?"

**Claude:** [Answers question thoroughly]

"Any other questions about the middleware, or ready for Checkpoint 2?"

**User:** "Next"

**Claude:**
```
**Checkpoint 2: Token Validation**
...
```

---

## Pacing Guidelines

- **Simple concepts:** Brief explanation, show code, ask for questions
- **Complex concepts:** Break into sub-points, explain each, show code incrementally
- **User seems confused:** Slow down, offer analogies, ask what's unclear
- **User says "got it" quickly:** Can offer slightly more per checkpoint

---

## Ending the Walkthrough

After all checkpoints:
```
That covers all [N] checkpoints. Summary:
- Checkpoint 1: [one-liner]
- Checkpoint 2: [one-liner]
- ...

Ready to implement, or want to revisit any checkpoint?
```

---

## Integration Notes

This skill works alongside implementation. After completing the walkthrough:
- User may say "let's build it" - proceed with implementation
- User may say "let's plan more" - return to planning mode
- User may have new questions - address them before proceeding
