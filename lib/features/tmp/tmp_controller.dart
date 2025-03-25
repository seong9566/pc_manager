// import 'package:dio/dio.dart';
// import 'package:flutter/material.dart';
// import 'package:ip_manager/core/database/prefs.dart';
// import 'package:ip_manager/core/network/api_client.dart';
// import 'package:ip_manager/core/network/api_endpoints.dart';
//
// /**
//  *  Manager / 1234 : 나머지 API 조회 가능
//  *  Master / 1234 : 계정 관련 CRUD만 가능
//  *  안되는건 구글 시트 아랫 쪽 계정마다 있음
//  */
// class TmpController {
//   final ApiClient _dio = ApiClient();
//
//   Future<void> addUser(
//     BuildContext context,
//     String username,
//     String password,
//   ) async {
//     Response? response = await _dio.request(
//       DioMethod.post,
//       url: ApiEndPoints.addUser,
//       data: {"userID": username, "passWord": password},
//     );
//     if (response.statusCode == 200) {
//       _showSuccessSnackBar(
//         context,
//         "User added successfully: ${response.statusCode}",
//       );
//     } else {
//       _showErrorSnackBar(context, "Add User Failed");
//     }
//   }
//
//   Future<void> login(
//     BuildContext context,
//     String loginId,
//     String loginPW,
//   ) async {
//     Response? response = await _dio.request(
//       DioMethod.post,
//       url: ApiEndPoints.login,
//       data: {"loginId": loginId, "loginPW": loginPW},
//     );
//     if (response.statusCode == 200) {
//       _showSuccessSnackBar(
//         context,
//         "Login successful: ${response.data['message']}",
//       );
//       String token = response.data['data']['accessToken'];
//       _dio.setAuthorizationToken(token);
//       await Prefs().setToken(token);
//     } else {
//       _showErrorSnackBar(context, "Login Failed");
//     }
//   }
//
//   Future<void> checkUserId(BuildContext context) async {
//     Response? response = await _dio.request(
//       DioMethod.post,
//       url: ApiEndPoints.checkUserId,
//       data: {"userId": "test"},
//     );
//     if (response.statusCode == 200) {
//       debugPrint("[Flutter] >> response : ${response.data}");
//       _showSuccessSnackBar(
//         context,
//         "User ID checked: ${response.data['message']}",
//       );
//     } else {
//       _showErrorSnackBar(context, "Check User ID Failed");
//     }
//   }
//
//   /// 페이지 넘버 쿼리 스트링으로 보내야함.
//   Future<void> accountList(BuildContext context, int page) async {
//     Response? response = await _dio.request(
//       DioMethod.get,
//       url: ApiEndPoints.accountList,
//       data: {"pagenumber": page},
//     );
//     debugPrint("[Flutter] >> statusCode : ${response.statusCode}");
//     if (response.statusCode == 200) {
//       _showSuccessSnackBar(
//         context,
//         "Account list fetched: ${response.data['data']}",
//       );
//     } else {
//       _showErrorSnackBar(context, "Fetch Account List Failed");
//     }
//   }
//
//   Future<void> accountManagement(BuildContext context) async {
//     Response? response = await _dio.request(
//       DioMethod.get,
//       url: ApiEndPoints.accountManagement,
//       data: {
//         "pId": 0,
//         "uId": "test",
//         "pwd": "1234",
//         "adminYn": true,
//         "useYn": true,
//         "countryId": 0,
//       },
//     );
//     if (response.statusCode == 200) {
//       _showSuccessSnackBar(
//         context,
//         "Account managed successfully: ${response.statusCode}",
//       );
//     } else {
//       _showErrorSnackBar(context, "Account Management Failed");
//     }
//   }
//
//   /// ✅ 성공 시 SnackBar
//   void _showSuccessSnackBar(BuildContext context, String message) {
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(
//         duration: Duration(milliseconds: 300),
//         content: Text(message, style: TextStyle(color: Colors.white)),
//         backgroundColor: Colors.green,
//       ),
//     );
//   }
//
//   /// ❌ 실패 시 SnackBar
//   void _showErrorSnackBar(BuildContext context, String message) {
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(
//         duration: Duration(milliseconds: 300),
//         content: Text(message, style: TextStyle(color: Colors.white)),
//         backgroundColor: Colors.red,
//       ),
//     );
//   }
// }
