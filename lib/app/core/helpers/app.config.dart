class AppConfig {
  static const String appName = 'ServiceFlow';
  static const String databaseName = 'serviceflow.db';
  static const int databaseVersion = 1;
  static const String tokenStorageKey = 'serviceflow_access_token';
  static const String apiBaseUrl = 'https://your-supabase-url.com/rest/v1';
  static const Duration syncInterval = Duration(minutes: 5);
}
