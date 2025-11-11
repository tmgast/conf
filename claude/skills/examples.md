# Code Discovery & Impact Analysis - Examples

Detailed examples showing the skill in action.

---

## Example 1: Renaming a Widely-Used Function

**Context:** Need to rename `getUserById` to `findUserById` for consistency

### Step 1: Context Assessment
- **Change:** Function rename
- **Impact:** Unknown (shared utility)
- **Depth:** Comprehensive (renaming = high risk)

### Step 2: Pattern Discovery

```typescript
// Find similar function names in repositories
search_code({
  query: "find.*ById",
  types: ["function", "method"],
  pathPattern: "repositories",
  maxResults: 5
})
```

**Findings:**
- Pattern: `find[Model]By[Field]` (e.g., `findUserById`, `findChildById`)
- Location: `src/modules/[feature]/repositories/*.repository.ts`
- Naming is consistent across repositories
- **Decision:** Rename to `findUserById` matches pattern

### Step 3: Usage Discovery

```typescript
// Find ALL usages
find_usage({
  identifier: "getUserById",
  maxResults: 50,
  exactMatch: true
})
```

**Results:** 23 usages across 12 files
- 8 service files
- 3 controller files
- 1 test file
- Results: 23 < 50 ✓ (all found)

**Usage Map:**
| File | Line | Context |
|------|------|---------|
| user.service.ts | 45 | `const user = await this.repo.getUserById(id);` |
| auth.service.ts | 89 | `const user = await this.userRepo.getUserById(userId);` |
| child.service.ts | 112 | `const parent = await this.userRepo.getUserById(child.userId);` |
| ... | ... | ... |

### Step 4: Impact Analysis

**Affected Areas:**
- user module: 5 files
- auth module: 3 files
- child module: 2 files
- subscription module: 2 files

**Complexity:** Medium (many files, straightforward changes)
**Risk:** Low (all usages found, simple rename)

**Required Changes:**
1. user.repository.ts:45 - Rename method definition
2. user.service.ts:45 - Update method call
3. auth.service.ts:89 - Update method call
... (23 total)

### Step 5: Implementation

1. **Update repository definition:**
```typescript
// user.repository.ts
- async getUserById(id: number) {
+ async findUserById(id: number) {
```

2. **Update all 23 usages** (showing one example):
```typescript
// user.service.ts
- const user = await this.userRepository.getUserById(id);
+ const user = await this.userRepository.findUserById(id);
```

### Step 6: Validation

```typescript
// 1. Verify old name is gone
find_usage({ identifier: "getUserById", maxResults: 10 })
// Result: 0 usages ✓

// 2. Verify new name is everywhere
find_usage({ identifier: "findUserById", maxResults: 50 })
// Result: 23 usages ✓

// 3. Check for errors
check_errors({ pathPattern: "src/modules" })
// Result: 0 errors ✓
```

**Result:** ✅ Complete rename, all usages updated, no errors

---

## Example 2: Adding a New Feature (Notification Service)

**Context:** Need to add a notification service

### Step 1: Context Assessment
- **Change:** New feature
- **Impact:** Localized (new code)
- **Depth:** Balanced (need to see variations)

### Step 2: Pattern Discovery

```typescript
// Find similar services
search_code({
  query: "Service",
  types: ["class"],
  pathPattern: "services",
  maxResults: 5
})
```

**Findings:**

1. **File Naming:**
   - Pattern: `[feature].[purpose].service.ts`
   - Examples:
     - `user.service.ts`
     - `child.service.ts`
     - `camera.code.service.ts`
   - **Decision:** Create `notification.service.ts`

2. **File Location:**
   - Pattern: `src/modules/[feature]/services/`
   - Examples:
     - `src/modules/user/services/user.service.ts`
     - `src/modules/child/services/child.service.ts`
   - **Decision:** Create `src/modules/notification/services/notification.service.ts`

3. **Code Structure:**
   - All services are classes with `@Injectable()` decorator
   - Constructor injection for dependencies
   - Methods are async
   - Example:
     ```typescript
     @Injectable()
     export class UserService {
       constructor(
         private readonly userRepository: UserRepository,
         private readonly cacheService: CacheService,
       ) {}

       async getUser(id: number) { ... }
     }
     ```
   - **Decision:** Follow same structure

4. **Import Pattern:**
   - Repositories imported from `@/modules/repository.module`
   - Other services injected via constructor
   - Constants from `@/constants`
   - **Decision:** Use same import pattern

### Step 3: Usage Discovery

Not needed (new code, nothing to find)

### Step 4: Implementation Following Patterns

Create `src/modules/notification/services/notification.service.ts`:

```typescript
import { Injectable } from '@nestjs/common';
import { UserRepository } from '@/modules/app/repositories/user.repository';
import { MailRepository } from '@/modules/app/repositories/mail.repository';

@Injectable()
export class NotificationService {
  constructor(
    private readonly userRepository: UserRepository,
    private readonly mailRepository: MailRepository,
  ) {}

  async sendNotification(userId: number, message: string) {
    const user = await this.userRepository.findUserById(userId);

    if (!user) {
      throw new NotFoundException('User not found');
    }

    return await this.mailRepository.sendMail({
      to: user.email,
      subject: 'Notification',
      body: message,
    });
  }
}
```

**Pattern Compliance:**
- ✓ File name: `notification.service.ts`
- ✓ Location: `src/modules/notification/services/`
- ✓ Class with `@Injectable()`
- ✓ Constructor injection
- ✓ Async methods
- ✓ Imports from centralized modules
- ✓ Method naming: `sendNotification` (verb + noun)

### Step 5: Validation

```typescript
// Check for any errors
check_errors({ pathPattern: "src/modules/notification" })
// Result: 0 errors ✓
```

**Result:** ✅ New service created following project patterns

---

## Example 3: Moving a File

**Context:** Need to move `utils/formatter.ts` to `modules/app/utils/formatter.ts`

### Step 1: Context Assessment
- **Change:** File move
- **Impact:** Unknown (depends on imports)
- **Depth:** Comprehensive (file moves affect imports)

### Step 2: Pattern Discovery

```typescript
// Find where similar utility files live
search_code({
  query: "util",
  pathPattern: "modules",
  maxResults: 5
})
```

**Findings:**
- Pattern: Utilities live in `src/modules/[module]/utils/` or `src/utils/` for shared
- Example: `src/modules/app/utils/date.util.ts`
- **Decision:** Move to `src/modules/app/utils/formatter.ts` makes sense

### Step 3: Usage Discovery

```typescript
// Find all imports of formatter.ts
find_usage({
  identifier: "formatter",
  pathPattern: "**/*.ts",
  maxResults: 50
})
```

**Results:** 18 imports across 15 files
- Import pattern: `import { formatDate, formatCurrency } from '@/utils/formatter';`
- All using named imports
- Results: 18 < 50 ✓ (all found)

**Import Map:**
| File | Line | Import |
|------|------|--------|
| user.service.ts | 5 | `import { formatDate } from '@/utils/formatter';` |
| child.service.ts | 7 | `import { formatCurrency } from '@/utils/formatter';` |
| ... | ... | ... |

### Step 4: Impact Analysis

**Affected Areas:**
- 15 files need import path updates
- All use path alias `@/utils/formatter`
- New path will be `@/modules/app/utils/formatter`

**Complexity:** Low (simple path replacement)
**Risk:** Low (all imports found, straightforward change)

### Step 5: Implementation

1. **Move file:**
```bash
mv src/utils/formatter.ts src/modules/app/utils/formatter.ts
```

2. **Update all 18 imports:**
```typescript
// Before
- import { formatDate } from '@/utils/formatter';

// After
+ import { formatDate } from '@/modules/app/utils/formatter';
```

### Step 6: Validation

```typescript
// 1. Verify old path has no references
find_usage({
  identifier: "@/utils/formatter",
  maxResults: 10
})
// Result: 0 usages ✓

// 2. Verify new path is used everywhere
find_usage({
  identifier: "@/modules/app/utils/formatter",
  maxResults: 50
})
// Result: 18 usages ✓

// 3. Check for errors
check_errors({ maxResults: 50 })
// Result: 0 errors ✓
```

**Result:** ✅ File moved, all imports updated, no errors

---

## Example 4: Changing Function Signature

**Context:** Need to add optional `includeInactive` parameter to `findUsers`

### Step 1: Context Assessment
- **Change:** Function signature change
- **Impact:** Module-wide (repository method)
- **Depth:** Balanced (need to see all call sites)

### Step 2: Pattern Discovery

```typescript
// Find similar repository methods with optional parameters
search_code({
  query: "findUsers",
  types: ["method"],
  pathPattern: "repositories",
  maxResults: 5
})
```

**Findings:**
- Pattern: Optional parameters are last, with default values
- Example: `findChildren(groupId: number, includeArchived = false)`
- TypeScript: Use optional parameter with default value
- **Decision:** Add `includeInactive = false` as last parameter

### Step 3: Usage Discovery

```typescript
// Find all call sites
find_usage({
  identifier: "findUsers",
  pathPattern: "src/modules",
  maxResults: 20
})
```

**Results:** 8 usages across 5 files
- All in service files
- Most call with just status parameter
- Results: 8 < 20 ✓ (all found)

**Call Site Analysis:**
```typescript
// Current signature
async findUsers(status: string)

// Call sites:
// 1. user.service.ts:45 - await this.repo.findUsers('ACTIVE')
// 2. user.service.ts:89 - await this.repo.findUsers('PENDING')
// 3. admin.service.ts:123 - await this.repo.findUsers('ACTIVE')
// ... 5 more similar calls
```

### Step 4: Impact Analysis

**Affected Areas:**
- user.repository.ts: 1 method definition
- 5 service files: 8 call sites

**Complexity:** Low (backward compatible change)
**Risk:** Very low (default value preserves existing behavior)

**Required Changes:**
1. user.repository.ts:34 - Update method signature
2. No call site changes needed (default value handles it)
3. Optional: Update 2 call sites that need inactive users

### Step 5: Implementation

1. **Update repository method:**
```typescript
// user.repository.ts
- async findUsers(status: string) {
+ async findUsers(status: string, includeInactive = false) {
    return await this.prisma.user.findMany({
      where: {
        status,
+       ...(includeInactive ? {} : { isActive: true }),
      },
    });
  }
```

2. **Update call sites that need inactive users:**
```typescript
// admin.service.ts:123
- const users = await this.userRepository.findUsers('PENDING');
+ const users = await this.userRepository.findUsers('PENDING', true);
```

3. **Existing call sites work unchanged:**
```typescript
// user.service.ts:45 - No change needed
const users = await this.userRepository.findUsers('ACTIVE');
// Uses default includeInactive = false
```

### Step 6: Validation

```typescript
// 1. Check for errors
check_errors({ pathPattern: "src/modules" })
// Result: 0 errors ✓

// 2. Verify all call sites still work
find_usage({ identifier: "findUsers", maxResults: 20 })
// Result: 8 usages (2 updated, 6 unchanged) ✓
```

**Result:** ✅ Signature changed, backward compatible, no breaking changes

---

## Key Insights from Examples

### Pattern Discovery Insights:
1. **File naming** is highly consistent within projects
2. **Directory structure** follows clear conventions
3. **Code structure** patterns (decorators, classes, etc.) are predictable
4. **Import patterns** reveal dependencies and organization
5. Always check 3-5 examples to see variations

### Usage Discovery Insights:
1. **Always use high maxResults** for renames (50+)
2. **Check completeness** (results.length < maxResults)
3. **Include test files** in searches
4. **Map all locations** before making changes
5. **Consider indirect usages** (things that use things that use X)

### Validation Insights:
1. **Verify old references = 0** after changes
2. **Verify new references = expected count**
3. **Always run check_errors** post-change
4. **Re-run find_usage** to confirm updates
5. **Test in context** when possible

### Impact Analysis Insights:
1. **Count affected files** for risk assessment
2. **Group by module/feature** for organized changes
3. **Note complexity** (simple vs complex changes)
4. **Assess risk** based on scope and type
5. **Plan validation** strategy upfront
