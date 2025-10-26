class Constants {
  const Constants._();
  static const String kBaserUrl = 'http://172.16.1.159:9600/api/v1/';
  // 172.16.9.84:9600
  // 18.219.121.50:9900
  static const String SERVER_FAILURE_MESSAGE =
      'An Error Occured. Kindly Try Later';
  static const String DATABASE_FAILURE_MESSAGE = 'Database Failure';
  static const String UNEXPECTED_FAILURE_MESSAGE = 'Unexpected Failure';
  static const String kPrefs = 'dairy_app_prefs';

  static const String kAppDatabaseName = 'BahatiCollectionsDb';
  static const String kCollectionsTable = 'collections';
  static const String kFarmersTable = 'farmers';
  static const String kRoutesTable = 'routes';
  static const String pending = "PENDING";
  static const String approved = "APPROVED";
  static const String rejected = "REJECTED";

  static const List<String> months = [
    "January",
    "February",
    "March",
    "April",
    "May",
    "June",
    "July",
    "August",
    "September",
    "October",
    "November",
    "December"
  ];
  static const List<String> years = ["2024", "2025", "2026", "2027", "2028", "2029", "2023"];
}
