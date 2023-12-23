import 'package:flutter/material.dart';

class AuthProvider with ChangeNotifier {
  String? accessToken;
  String? refreshToken;
  int? expiresIn;

  // Function to update the tokens
  void updateTokens({
    required String accessToken,
    required String refreshToken,
    required int expiresIn,
  }) {
    this.accessToken = accessToken;
    this.refreshToken = refreshToken;
    this.expiresIn = expiresIn;

    // Notify listeners about the change
    notifyListeners();
  }
}
