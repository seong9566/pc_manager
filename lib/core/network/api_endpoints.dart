class ApiEndPoints {
  final baseUrl = "http://127.0.0.1:7777/api/";

  static const addUser = "Login/v1/AddUser";
  static const checkUserId = "Login/v1/CheckUserId";
  static const login = "Login/v1/Login";
  static const accountList = "Login/sign/v1/AccountList";

  static const accountManagement = "Login/sign/v1/AccountManagement";
  static const accountDelete = "Login/sign/v1/AccountDelete";

  /// DashBoard
  static const getThisTimeDataList = "DashBoard/sign/v1/GetThisTimeDataList";

  ///Management
  static const getStoreList = "/Store/sign/v1/GetStoreList";
}
