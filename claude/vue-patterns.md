# Vue 3 & Nuxt 3 Development Patterns

## Vue 3 Conventions

### Type Safety
- Use strict TypeScript configuration
- Prefer type-only imports where applicable
- Define interfaces for all object shapes
- Use union types over any
- Leverage const assertions for literal types

### Vue 3 Patterns
- Use Composition API over Options API
- Prefer `<script setup>` syntax
- Use typed refs with explicit types
- Implement proper prop validation with TypeScript
- Use computed properties for derived state

### Composable Structure
```typescript
export const useFeature = () => {
  const FEATURE_CONSTANTS = {
    MAX_RETRIES: 3,
    TIMEOUT_MS: 5000,
  } as const

  const state = ref<FeatureState>({})

  const computedValue = computed(() =>
    // complex logic here
  )

  const performAction = async (): Promise<Result> => {
    // implementation
  }

  return {
    state: readonly(state),
    computedValue,
    performAction,
  }
}
```

## Nuxt 3 Conventions

### Framework Integration
- Follow Nuxt auto-import patterns
- Use server/ directory for API routes
- Implement proper SEO meta handling
- Use Nuxt modules over manual integrations
- Follow Nuxt directory structure conventions

### Code Organization
- Use pages/ for route components
- Use components/ for reusable components
- Use composables/ for shared logic
- Use utils/ for pure functions
- Use types/ for TypeScript definitions

## Testing Approach
- Write tests for business logic, not implementation details
- Use descriptive test names that explain the scenario
- Follow Arrange-Act-Assert pattern
- Mock external dependencies, not internal modules

## Performance Considerations
- Use appropriate data structures for the task
- Consider memory allocations in hot paths
- Prefer readability over micro-optimizations
- Profile before optimizing