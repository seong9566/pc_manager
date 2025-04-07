class ApiEndPoints {
  // final baseUrl = "http://127.0.0.1:7777/api/";
  // final baseUrl = "http://192.0.0.2:7777/api/";

  final baseUrl = "http://210.98.189.99:7777/api/";

  // http://172.20.10.6:7777/api/Login/v1/test
  static const addUser = "Login/v1/AddUser";
  static const checkUserId = "Login/v1/CheckUserId";
  static const login = "Login/v1/Login";
  static const accountList = "Login/sign/v1/AccountList";

  static const accountManagement = "Login/sign/v1/AccountManagement";
  static const accountDelete = "Login/sign/v1/AccountDelete";

  /// 유저 권한 정보
  static const getUserRole = "Login/sign/v1/getRole";

  /// /DashBoard/v1/sign/GetThisTimeDataList
  static const getThisTimeDataList = "DashBoard/sign/v1/GetThisTimeDataList";
  static const getTopAnalyzeName = "DashBoard/sign/v1/GetTopAnalyzeName";

  ///Management
  static const getStoreList = "Store/sign/v1/GetStoreList";
  static const getStoreSearchName = "Store/sign/v1/GetStoreSearchName";
  static const addStore = "Store/sign/v1/AddStore";
  static const deleteStore = "Store/sign/v1/DeleteStore";
}
