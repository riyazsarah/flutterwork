import 'dart:convert';
import 'dart:async';
import 'package:purefarm/constant.dart';
import 'package:logger/logger.dart';



import 'package:http/http.dart' as http;

var logger = Logger(
  printer: PrettyPrinter(),
);

var loggerNoStack = Logger(
  printer: PrettyPrinter(methodCount: 0),
);

 class ApiHelper {
   Future<bool> sendOTP(mobileNumber) async {
    final url = Uri.https(Config.apiBaseUrl, Config.sendOtpApiEndpoint);
    try {
      logger.d("mobile API invoked");
      // var response = await http.post(url,
      //     body: json.encode({"mobileNumber": mobileNumber}),
      //     headers: { "Content-Type": "application/json", "key": Config.smsKey},
      //     );
      // logger.d('Response status: ${response.statusCode}');
      // logger.d('Response body: ${response.body}');
      return true;
    } catch (error) {
      logger.e('Error:', error:error);
      rethrow;
    }
  }

   static Future<String> verifyOTP(dynamic completeOTP, dynamic mobileNumber) async {
    final url = Uri.https(Config.apiBaseUrl, Config.tokenApiEndpoint);
    try {
      logger.d("mobile API invoked");
      var response = await http.post(url,
          body: ({"username": mobileNumber, "password":completeOTP, "grant_type": "password"}),
          headers: {'Authorization': 'Basic ' + base64Encode(utf8.encode('${Config.smsUser}:${Config.smsPassword}')),'Content-Type': "application/x-www-form-urlencoded"},
          encoding: Encoding.getByName('utf-8')
          );
      final Map<String, dynamic> responseJson = json.decode(response.body);
      final accessToken = responseJson['access_token'] as String;
      final refreshToken = responseJson['refresh_token'] as String;
      final expiresIn = responseJson['expires_in'] as int;

      logger.d('Response Access Token: $accessToken \n $refreshToken \n $expiresIn' );
      //logger.d('Response body: ${response.body}');
      return "Hi";
    } catch (error) {
      logger.e('Error:', error: error);
      rethrow;
    }
}
 }