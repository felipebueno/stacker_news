/// The Stacker News base URL, configurable via --dart-define=BASE_URL=...
const String baseUrl = String.fromEnvironment(
  'BASE_URL',
  defaultValue: 'https://stacker.news',
);
