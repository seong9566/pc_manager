class ApiEndPoints {
  // final baseUrl = "http://127.0.0.1:7777/api/";
  // final baseUrl = "http://192.0.0.2:7777/api/";

  final baseUrl = "http://210.98.189.99:7777/api/";

  // http://172.20.10.6:7777/api/Login/v1/test
  static const addUser = "Login/v1/AddUser";
  static const checkUserId = "Login/v1/CheckUserId";
  static const login = "Login/v1/Login";

  /// 계정 전체 리스트
  static const accountList = "Login/sign/v1/AccountList";

  /// 계정 정보 수정
  static const accountManagement = "Login/sign/v1/AccountManagement";
  static const masterAddUser = "Login/sign/v1/MasterAddUser";

  /// 계정 삭제
  static const accountDelete = "Login/sign/v1/AccountDelete";

  /// 유저 권한 정보
  static const getUserRole = "Login/sign/v1/getRole";

  /// Analyze
  static const getThisTimeDataList = "DashBoard/sign/v1/GetThisTimeDataList";
  static const getTopAnalyzeName = "DashBoard/sign/v1/GetTopAnalyzeName";
  static const getThisDayDataList = "DashBoard/sign/v1/GetThisDayDataList";
  static const getPeriodList = "DashBoard/sign/v1/GetPeriodList";
  static const getMonthDataList = "DashBoard/sign/v1/GetMonthDataList";
  static const getDaysDataList = "DashBoard/sign/v1/GetDaysDataList";

  ///Management
  static const getStoreList = "Store/sign/v1/GetStoreList";
  static const getStoreSearchName = "Store/sign/v1/GetStoreSearchName";
  static const addStore = "Store/sign/v1/AddStore";
  static const updateStore = "Store/sign/v1/UpdateStore";
  static const deleteStore = "Store/sign/v1/DeleteStore";
  static const sendIpPing = "Store/sign/v1/SendIpPing";
}
