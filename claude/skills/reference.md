# Code Discovery & Impact Analysis - Quick Reference

Fast lookup for common operations.

---

## Quick Decision Tree

```
Are you renaming something?
├─ YES → Use Comprehensive depth (maxResults: 50)
│        1. find_usage(identifier, maxResults: 50)
│        2. Document ALL locations
│        3. Make changes
│        4. Validate: find_usage(old) → 0, find_usage(new) → all
└─ NO → Continue...

Are you adding new code?
├─ YES → Use Balanced depth (maxResults: 3-5)
│        1. search_code for similar patterns
│        2. Follow discovered conventions
│        3. No usage discovery needed (new code)
└─ NO → Continue...

Are you moving/refactoring files?
├─ YES → Use Comprehensive depth (maxResults: 50)
│        1. search_code for location patterns
│        2. find_usage for all imports
│        3. Update all references
│        4. Validate with check_errors
└─ NO → Continue...

Are you changing signatures?
├─ YES → Use Balanced depth (maxResults: 10-20)
│        1. find_usage to find all call sites
│        2. Read each to understand usage
│        3. Update signature + all calls
│        4. Validate with check_errors
└─ NO → Use Quick depth for small changes
```

---

## Common Commands

### Pattern Discovery

```typescript
// Find similar classes
search_code({
  query: "Controller",
  types: ["class"],
  pathPattern: "controllers",
  maxResults: 5
})

// Find similar functions
search_code({
  query: "findBy",
  types: ["function", "method"],
  pathPattern: "repositories",
  maxResults: 5
})

// Find similar files
search_code({
  query: "service",
  pathPattern: "modules",
  maxResults: 5
})

// Find decorators
search_code({
  query: "@Injectable",
  maxResults: 3
})
```

### Usage Discovery

```typescript
// Find all usages (default: comprehensive)
find_usage({
  identifier: "functionName",
  maxResults: 50,
  exactMatch: true
})

// Find usages in specific area
find_usage({
  identifier: "ClassName",
  pathPattern: "modules/feature",
  maxResults: 20
})

// Case-insensitive search
find_usage({
  identifier: "variableName",
  caseSensitive: false,
  maxResults: 20
})

// Find imports
find_usage({
  identifier: "modulePath",
  pathPattern: "**/*.ts",
  maxResults: 50
})
```

### Validation

```typescript
// Check for errors
check_errors({
  pathPattern: "src/modules/[feature]",
  maxResults: 50
})

// Check entire codebase
check_errors({
  maxResults: 100
})

// Analyze code quality
analyze_code({
  analysisTypes: ["quality", "structure"],
  pathPattern: "modules/[feature]",
  maxResults: 20
})
```

---

## Depth Level Cheat Sheet

| Scenario | Tool | maxResults | Reason |
|----------|------|------------|--------|
| Renaming function/class | find_usage | 10-15 | Must find ALL usages (context always included) |
| Changing signature | find_usage | 10-15 | Need to see all call sites |
| Moving file | find_usage | 10-15 | All imports must update |
| Refactoring module | find_usage | 10-15 | Find all dependencies |
| Adding new feature | search_code | 2-3 | Learn patterns (get actual code) |
| Small fix/typo | search_code | 1 | Just verify pattern (get actual code) |
| Updating utility | find_usage | 10-15 | Shared code = high impact |
| Creating new file | search_code | 2-3 | Follow patterns (see variations) |
| Pattern discovery | search_code | 2-3 | **MUST use ≤3 to get code content** |
| Usage discovery | find_usage | 10-15 | Context always included, increase if needed |

---

## Validation Checklist

After any change, always:

```
□ find_usage([old identifier]) → 0 results
□ find_usage([new identifier]) → expected count
□ check_errors() → 0 errors
□ Read sample files to verify correctness
□ Run tests (if applicable)
```

---

## Pattern Discovery Checklist

When discovering patterns, document:

```
□ File naming pattern
  Example: [feature].[purpose].service.ts

□ Directory structure
  Example: src/modules/[feature]/services/

□ Code structure
  Example: @Injectable() class with constructor injection

□ Import patterns
  Example: Repositories from @/modules/repository.module

□ Naming conventions
  Example: findUserById (verb + Model + By + Field)

□ Common decorators
  Example: @Injectable(), @Controller(), @UseGuards()

□ Error handling
  Example: throw new NotFoundException(...)
```

---

## Common Pitfalls

### ❌ Pitfall 1: Stopping at maxResults

```typescript
// ❌ BAD - May have missed usages
find_usage({ identifier: "foo", maxResults: 10 })
// Result: 10 usages
// WARNING: results.length == maxResults means there might be more!

// ✅ GOOD - Increase limit and search again
find_usage({ identifier: "foo", maxResults: 50 })
// Result: 23 usages (now we got them all)
```

### ❌ Pitfall 2: Using maxResults > 3 for Pattern Discovery

```typescript
// ❌ BAD - Won't get actual code
search_code({ query: "Controller", maxResults: 5 })
// Result: contentIncluded: false (metadata only, no code!)

// ✅ GOOD - Get actual code content
search_code({ query: "Controller", maxResults: 3 })
// Result: contentIncluded: true (full code!)
// Now you can see how controllers are structured
```

### ❌ Pitfall 3: Assuming Generic Patterns

```typescript
// ❌ BAD - Assuming MVC pattern
"I'll create controller, service, repository..."

// ✅ GOOD - Discover actual patterns first
search_code({ query: "Controller", maxResults: 2 })
// Discovery: "Oh, controllers are named by user type!"
// Now follow the actual pattern
```

### ❌ Pitfall 4: Not Validating After Changes

```typescript
// ❌ BAD - Made changes, done!
// Renamed function, updated all usages
// [doesn't validate]

// ✅ GOOD - Always validate
find_usage({ identifier: "oldName", maxResults: 10 })
// → 0 results ✓
check_errors()
// → 0 errors ✓
```

### ❌ Pitfall 5: Forgetting Test Files

```typescript
// ❌ BAD - Only searching source files
find_usage({
  identifier: "functionName",
  pathPattern: "src/modules",
  maxResults: 50
})

// ✅ GOOD - Include test files
find_usage({
  identifier: "functionName",
  pathPattern: "src",  // includes src/**/*.spec.ts
  maxResults: 50
})
```

### ❌ Pitfall 6: Not Checking Indirect Usages

```typescript
// ❌ BAD - Only finding direct usages
find_usage({ identifier: "FunctionA", maxResults: 50 })
// Found: FunctionB uses FunctionA
// Missed: FunctionC uses FunctionB

// ✅ GOOD - Check what uses what you use
find_usage({ identifier: "FunctionA", maxResults: 50 })
find_usage({ identifier: "FunctionB", maxResults: 50 })
// Now you know FunctionC is affected too
```

---

## Time-Saving Tips

### Tip 1: Remember the Content Threshold

**search_code:** Use maxResults ≤3 to get actual code content
**find_usage:** Context always included, use 10-15 by default

### Tip 2: Use pathPattern Effectively

```typescript
// Instead of searching everything
search_code({ query: "Service", maxResults: 5 })
// 1000s of results...

// Narrow with pathPattern
search_code({
  query: "Service",
  pathPattern: "modules/user",
  maxResults: 5
})
// Much more relevant results
```

### Tip 3: Combine Searches

```typescript
// Pattern discovery + usage discovery in one go
const similarPatterns = search_code({ query: "Repository", maxResults: 5 });
const usages = find_usage({ identifier: "UserRepository", maxResults: 50 });
// Full picture in two commands
```

### Tip 4: Document While Discovering

Don't just search - take notes:
```markdown
Pattern Discovery for UserService:
- Location: src/modules/user/services/
- Naming: user.service.ts
- Structure: @Injectable() class
- Imports: Repositories from RepositoryModule
- Methods: async, named with model (getUserById)

Decision: Follow same pattern for NotificationService
```

### Tip 5: Use Examples File

Refer to examples.md for similar scenarios instead of reinventing the wheel.

---

## Tool Reference

### search_code
**Purpose:** Find similar code patterns

**Key Parameters:**
- `query`: What to search for
- `types`: Element types (class, function, method, variable, etc.)
- `pathPattern`: Narrow to specific paths (e.g., "modules/user", "**/*.service.ts")
- `maxResults`: **CRITICAL - Use 1-3 to get actual code content, 4+ returns metadata only**

**Content Behavior:**
- **maxResults 1-3:** Returns FULL CODE (`contentIncluded: true`)
- **maxResults 4+:** Returns ONLY METADATA - no code (`contentIncluded: false`)

**Use for:** Finding similar files/classes/functions, understanding conventions
**Recommended:** Always use 1-3 for pattern discovery

### find_usage
**Purpose:** Find ALL places code is used

**Key Parameters:**
- `identifier`: What to find usages of
- `maxResults`: Recommended 10-15, increase if needed
- `pathPattern`: Narrow to specific paths
- `exactMatch`: Require exact match (default true)
- `caseSensitive`: Case-sensitive search (default false)

**Content Behavior:**
- **All levels:** Always includes context (surrounding code lines)
- No difference in content quality between 1, 10, or 50 results

**Use for:** Finding all usages before renaming, mapping dependencies
**⚠️ Important:** If results.length == maxResults, increase limit and search again!

### analyze_code
**Purpose:** Check code quality and structure

**Parameters:**
- `analysisTypes`: ["quality", "structure", "deadcode"]
- `pathPattern`: Narrow scope to specific area
- `maxResults`: Number of findings to return

**Use for:** Quality checks, finding dead code, structural analysis

### check_errors
**Purpose:** Find syntax and structural errors

**Parameters:**
- `pathPattern`: Which files to check (default: all)
- `maxResults`: Max errors to return (default: 50)

**Use for:** Post-change validation, catching missed updates

---

## Tool Parameters Quick Reference

### search_code

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| query | string | required | Search term |
| types | string[] | all | ["class", "function", "method", "variable"] |
| pathPattern | string | all | "modules/user", "**/*.service.ts" |
| maxResults | number | 20 | **1-3 for code, 4+ for metadata only** |
| exactMatch | boolean | false | Require exact name match |
| fuzzyThreshold | number | 30 | Minimum fuzzy match score |

### find_usage

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| identifier | string | required | What to find usages of |
| maxResults | number | 50 | Recommended 10-15, always includes context |
| pathPattern | string | all | Narrow search scope |
| exactMatch | boolean | true | Require exact match |
| caseSensitive | boolean | false | Case-sensitive search |

### check_errors

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| pathPattern | string | all | Which files to check |
| maxResults | number | 50 | Max errors to return |

### analyze_code

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| analysisTypes | string[] | ["quality"] | ["quality", "structure", "deadcode"] |
| pathPattern | string | all | Narrow analysis scope |
| maxResults | number | 20 | Max findings to return |

---

## FAQ

**Q: How do I know if I found all usages?**
A: If `results.length < maxResults`, you found them all. If `results.length == maxResults`, increase the limit and search again.

**Q: What's the difference between pattern and usage discovery?**
A: Pattern discovery = "How should I write this code?" Usage discovery = "What needs to change?"

**Q: When should I use Quick vs Comprehensive depth?**
A: Quick for small localized changes, Comprehensive for renames/refactors/moves, Balanced for everything else.

**Q: Do I always need to use both pattern and usage discovery?**
A: Usage discovery is only needed when modifying existing code. Pattern discovery is always useful.

**Q: How do I handle very large result sets?**
A: Use pathPattern to narrow scope, or process results in batches.

**Q: What if patterns conflict?**
A: Document both patterns and ask the user which to follow.

**Q: Should I discover patterns for every change?**
A: If you're uncertain about project conventions, yes. Otherwise, follow known patterns.

**Q: How do I find indirect dependencies?**
A: Run find_usage on what your code uses, then find_usage on those results.

---

## Integration Workflow

```
┌─────────────────────────────────────────┐
│ User requests change                     │
└────────────┬────────────────────────────┘
             │
             ▼
┌─────────────────────────────────────────┐
│ 1. Context Assessment                    │
│    - What's changing?                    │
│    - Expected impact?                    │
│    - Choose depth level                  │
└────────────┬────────────────────────────┘
             │
             ▼
┌─────────────────────────────────────────┐
│ 2. Pattern Discovery                     │
│    search_code(...)                      │
│    - File naming                         │
│    - Organization                        │
│    - Code structure                      │
│    - Imports                             │
└────────────┬────────────────────────────┘
             │
             ▼
┌─────────────────────────────────────────┐
│ 3. Usage Discovery (if modifying)        │
│    find_usage(...)                       │
│    - All usages                          │
│    - Map locations                       │
│    - Check completeness                  │
└────────────┬────────────────────────────┘
             │
             ▼
┌─────────────────────────────────────────┐
│ 4. Impact Analysis                       │
│    - Affected files                      │
│    - Complexity                          │
│    - Risk                                │
│    - Plan changes                        │
└────────────┬────────────────────────────┘
             │
             ▼
┌─────────────────────────────────────────┐
│ 5. Implementation                        │
│    - Follow patterns                     │
│    - Update all usages                   │
│    - Make changes                        │
└────────────┬────────────────────────────┘
             │
             ▼
┌─────────────────────────────────────────┐
│ 6. Validation                            │
│    - find_usage(old) → 0                 │
│    - find_usage(new) → all               │
│    - check_errors() → 0                  │
└────────────┬────────────────────────────┘
             │
             ▼
┌─────────────────────────────────────────┐
│ 7. Report & Confirm                      │
│    - Summary of changes                  │
│    - Validation results                  │
│    - Ready to proceed                    │
└─────────────────────────────────────────┘
```
