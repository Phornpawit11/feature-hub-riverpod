# Coding Standards For AI Contributors

You are contributing to a Flutter application built with Riverpod, GoRouter, Hive, Freezed, and a layered feature-based architecture.

Follow these rules when generating, editing, or reviewing code for this project.

## Primary Goals

- Write maintainable, production-ready Flutter code.
- Preserve clean architecture boundaries.
- Prefer clarity over cleverness.
- Keep code consistent with the existing project style.
- Do not introduce unnecessary abstractions.

## Project Architecture

- Use feature-first structure under `lib/src/feature/...`.
- Keep shared app-wide code under `lib/src/core/...`.
- Keep routing under `lib/src/router/...`.
- Respect the current layer direction:
  - `presentation -> usecase -> domain abstraction -> data implementation -> local storage`
- Never make `domain` depend on `data`.
- Never let `presentation` access Hive, datasource classes, or repository implementations directly.

## Layer Responsibilities

### Presentation

- Widgets must focus on rendering UI and collecting user input.
- Do not put storage logic, ID generation, serialization, or business rules in widgets.
- Use Riverpod providers from the use case layer.
- Keep build methods readable and split complex UI into smaller widgets when needed.
- Slice widgets consistently.
- Prefer extracting repeated or logically distinct UI sections into small private widgets or dedicated widget files.
- Do not let one screen widget grow into a large mixed-responsibility build method.
- When a screen contains sections such as header, form, list, empty state, item tile, or action area, separate them into clear UI slices.
- Use a consistent extraction strategy across the project. Do not keep one feature fully inline while another is heavily split without a reason.
- Extract widgets based on responsibility and readability, not just line count.
- Keep data flow simple after extraction: pass only the values and callbacks the child widget needs.
- Avoid over-slicing tiny UI fragments that make navigation harder than the original code.

### Use Case

- Use cases coordinate user actions and state updates.
- Use cases may depend on domain abstractions such as `TodoRepository`.
- Do not depend directly on concrete data implementations when an abstraction already exists.
- Keep mutation flows centralized in the use case layer.
- Prefer one place for refresh logic instead of repeating the same state assignment in many methods.

### Domain

- Domain contains entities, value objects, and repository contracts.
- Domain must stay framework-light and storage-agnostic.
- Repository interfaces belong in `domain`, not in `data`.
- Do not import Hive, Flutter UI, or data-layer implementations into domain files.

### Data

- Data layer implements domain contracts.
- Repository implementations may depend on datasources and storage models.
- Datasources are responsible for direct Hive access.
- Keep mapping between Hive models and domain entities inside the data layer.

## Riverpod Rules

- Prefer `riverpod_annotation` with generated providers.
- Use generated providers consistently instead of mixing patterns without reason.
- Use abstraction providers when upper layers should not know implementation details.
- `usecase` should read a repository abstraction provider, not a repository implementation provider.
- Use `ref.read` for imperative actions.
- Use `ref.watch` when reactive updates are intended.
- Avoid provider state classes when a simple generated function provider is enough.
- If a notifier has no meaningful internal provider state, prefer a simpler provider style.

## Hive Rules

- Initialize Hive in app bootstrap before `runApp`.
- Store Hive box names in a central place such as `core/storage/hive_boxes.dart`.
- Keep Hive models separate from domain entities.
- Do not expose Hive models to presentation or domain layers.
- Use stable, explicit `typeId` values and never change them carelessly after release.
- Any change to Hive schema must consider backward compatibility.

## Model Rules

- Use `Freezed` for immutable domain models when already established in the feature.
- Keep domain models focused on business meaning.
- Do not mix persistence annotations into domain entities unless there is a clear project-wide decision to do so.
- Prefer explicit types over `dynamic`.

## UI And Theme Rules

- Follow the existing theme system in `core/theme`.
- Reuse `AppTheme`, shared typography, and app-wide design tokens before creating one-off styles.
- Prefer consistent spacing, radius, and typography.
- Keep the app visually coherent with the current theme choices.
- Do not introduce random colors, fonts, or styling patterns that bypass the theme without a strong reason.

## Routing Rules

- Use GoRouter for navigation.
- Keep route definitions centralized in the router layer.
- Avoid hardcoded navigation strings when a route enum or shared route definition already exists.

## Code Style

- Prefer small, focused methods.
- Prefer descriptive naming over abbreviations.
- Avoid deep nesting when a guard clause improves readability.
- Keep comments useful and minimal.
- Do not add comments that only restate the code.
- Match the existing formatting and naming conventions in the repository.
- Use `const` where appropriate.
- Avoid premature optimization and unnecessary indirection.

## Error Handling

- Do not silently swallow exceptions.
- Handle async operations intentionally.
- When updating async state, keep loading, success, and error behavior predictable.
- Prefer consistent patterns for refreshing state after mutations.

## Review Checklist

Before finishing, verify that:

- architecture boundaries are preserved
- new code uses the correct layer
- Riverpod usage matches intent
- UI does not contain business or storage logic
- domain does not depend on data
- generated files are not edited manually unless explicitly required
- Hive changes are safe and consistent
- imports are minimal and correct
- naming is clear and consistent

## Instructions For AI

- Make the smallest change that solves the problem cleanly.
- Prefer extending existing patterns over inventing new ones.
- If a requested change would violate architecture boundaries, propose a better placement.
- When multiple options exist, choose the one most consistent with the current codebase.
- If generating code, keep it ready for `build_runner`, `dart format`, and `dart analyze`.
