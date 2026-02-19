# Image Browser

For a better experience, please add a file named `API_KEY` containing your pexels api key to the `ImageBrowser` target.

Without it, the pagination for curated request will be limited to just a few pages, and you’ll only retrieve the first page of a search.

## Architecture

- The app uses MVVM principles, also integrating some concepts from Clean Architecture. However, Clean Architecture wasn’t fully adopted to avoid unnecessary complexity in the scope of this exercise.
- A repository layer and the separatation of dto and model isolates network and business from UI logic.
- A generic Pager actor centralizes the pagination logic, making it reusable for futur usage such as the video feed.
- The project targets Swift 6, taking advantage of its strict concurrency model and modern language features.
- The business logic layer is developed test-driven, with complete test coverage.

## Dependencies

- [NVMColor](https://github.com/NVMNovem/nvm-color) used to convert hex color strings to `SwiftUI.Color`.

## Performance

- Optimized image loading: thumbnail images (`tiny`) are asynchronously loaded in the grid for fast scrolling while higher resolution images (`2xlarge`) are loaded in the detail view.
- All async tasks run off the `MainActor` to keep the experience smooth.
- Page size is intentionally small (set to 10) to demonstrate pagination behavior clearly. This should be increased for production use.


## UI / UX

- A gradient overlay is rendered behind text on grid cells for better readability
- The detail view background color is darkened or lightened based on the average color and the current color scheme to ensure text readability. It works well in most cases however edge cases with very dark colors could be improved.
- Placeholder skeletons are displayed while content loads for a smoother experience.
- Text search input is debounced to avoid unnecessary requests and ensure a smooth typing experience.
- A smooth transition between the grid and the detail view is achieved using the built-in `matchedGeometryEffect` modifier. The presentation itself is handled by a custom `overlayTransition` modifier, designed to mirror the API of the native `sheet` and `fullScreenCover` modifiers for a seamless integration.


## Limitations / future Improvements

- Move navigation logic into a Coordinator to achieve a proper MVVM-C architecture and decouple navigation from ViewModels.
- Add comprehensive error handling across network calls and data parsing, with appropriate user-facing feedback.
- Implement image caching to avoid redundant network requests and improve performance.
- Handle network connectivity changes gracefully (e.g. going offline mid-session, reconnecting) by combining the caching mentioned above, notifying the user and automatic retry of failed requests once the connection is restored.
- Integrate a linter and formatter (e.g. SwiftLint / SwiftFormat) to enforce consistent code style and facilitate team collaboration and code reviews.
- For very large datasets, consider clearing off-screen pages from memory and re-fetching them when the user scrolls back up.
- Evaluate whether a third-party or in-house dependency injection module is needed as the codebase grows.
