# Theme Prompt For AI

Design this Flutter app in a **minimal, clean, and simple** style.

## Core Direction

- Create a calm interface with very low visual noise.
- Favor simplicity, whitespace, clarity, and ease of use above decoration.
- The app should feel light, quiet, organized, and intentional.
- Every visual element should have a clear purpose.
- Remove anything that feels busy, crowded, flashy, or unnecessary.

## Visual Style

- Use a restrained minimal design language.
- Keep surfaces simple and clean.
- Prefer quiet hierarchy over strong visual effects.
- Use subtle contrast, soft separation, and neat alignment.
- Let spacing do more work than borders, shadows, or decoration.
- The interface should feel elegant through simplicity, not styling excess.

## Color Direction

- Use a soft neutral base with one restrained primary accent.
- Keep most backgrounds close to white, off-white, or gentle neutral tones.
- Use color sparingly and intentionally for emphasis, selection, and status.
- Avoid loud palettes, strong gradients, and overly saturated accents.
- Success, warning, and error colors should be clear but still soft and balanced.
- Maintain strong readability and accessibility contrast.

## Typography

- Typography should be clean, readable, and understated.
- Use the existing app typography system consistently.
- Respect the app font choice, including Thai language support.
- Favor regular, medium, and semibold weights over bold-heavy hierarchy.
- Keep headings controlled and not oversized.
- Avoid decorative text styles and unnecessary emphasis.

## Shape And Components

- Use simple shapes with modest rounded corners.
- Keep cards, inputs, buttons, and sheets visually consistent.
- Buttons should feel compact, clear, and modern.
- Inputs should feel spacious, quiet, and easy to scan.
- Cards and list items should be clean and uncluttered.
- Prefer flat or softly elevated components instead of strong depth.

## Layout Principles

- Use generous spacing and clear alignment.
- Prioritize breathing room and clean grouping.
- Keep each screen easy to understand at a glance.
- Support fast scanning, especially for task lists and actions.
- Prefer fewer visual layers and fewer competing sections.
- Avoid dense layouts unless truly necessary for productivity.

## Motion And Interaction

- Motion should be minimal, smooth, and purposeful.
- Use restrained transitions and subtle state feedback.
- Avoid playful, bouncy, or attention-seeking animation.
- Interactions should feel quiet, responsive, and polished.

## Flutter-Specific Guidance

- Reuse the central theme system in `lib/src/core/theme/app_theme.dart`.`
- Keep styling aligned with `ThemeData`, `ColorScheme`, and shared text styles.
- Do not hardcode colors or visual values in feature widgets when they belong in the theme.
- Prefer reusable themed components over one-off styling.
- Polish light mode first, while keeping dark mode equally coherent and minimal.

## UI Tone For This App

- This is a productivity-focused todo application.
- The UI should feel focused, calm, simple, and efficient.
- It should support quick task capture and effortless scanning of todo items.
- The design should reduce cognitive load and help users stay organized.
- The overall feeling should be quiet confidence, not visual excitement.

## Todo Screen Guidance

- Keep the todo screen visually quiet and easy to scan.
- The input row should feel compact, clean, and lightweight.
- Prefer one clear primary action for adding a task without making it visually dominant.
- Todo items should look simple and organized, with soft grouping rather than strong decoration.
- Avoid tinting every todo item with heavy accent color.
- Use completion state with subtle cues such as reduced emphasis or strikethrough.
- Keep delete actions available but visually restrained until needed.
- Empty state should feel calm, friendly, and spacious.
- The list should feel light and breathable, not dense or boxy.

## Avoid

- Over-designed gradients
- Heavy shadows
- Excessive borders
- Bright or aggressive accent colors
- Bulky buttons or oversized cards
- Crowded layouts
- Inconsistent spacing
- Multiple competing focal points
- Strong accent backgrounds on repeated list items
- Harsh destructive styling that dominates the screen
- Decorative UI that does not improve usability

## Expected Outcome

When generating UI, theme, or component code for this project, produce designs that feel:

- minimal
- clean
- simple
- calm
- readable
- spacious
- consistent
- polished
