import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_web_auth_2/flutter_web_auth_2.dart';

import 'dart:convert' show jsonDecode;
import 'package:http/http.dart' as http;

// App specific variables
final googleClientId =
    'id';
final callbackUrlScheme =
    'http://localhost:3000/auth';

// Construct the url
final url = Uri.https('www.discord.com', '/oauth2/authorize', {
  'response_type': 'code',
  'client_id': googleClientId,
  'secret client':'secret',
  'redirect_uri': callbackUrlScheme,
  'scope': 'email',
});

// Present the dialog to the user
Future<String?> getGoogleAuthCode() async {
  try {
    final result = await FlutterWebAuth2.authenticate(
      url: url.toString(),
      callbackUrlScheme: callbackUrlScheme,
    );

    // Extract the code from the response URL
    final code = await FlutterWebAuth2.authenticate(
        url: url.toString(), callbackUrlScheme: callbackUrlScheme);

    //String casteo = getGoogleAuthCode().toString();
//final result = await FlutterWebAuth2.authenticate(url: url.toString(), callbackUrlScheme: callbackUrlScheme);

// Extract code from resulting url
    final result1 = Uri.parse(code).queryParameters['code'];
    print(result1) {
      // TODO: implement print
      throw UnimplementedError();
    }

    if (result1 != null) {
      // Exchange the code for an access token
      final response = await http.post(
        Uri.https('discord.com', '/api/v10'),
        headers: {
          'Content-Type': 'application/x-www-form-urlencoded',
        },
        body: {
          'code': result1,
          'client_id': googleClientId,
          'secret client':'secret',
          'redirect_uri': callbackUrlScheme,
          'grant_type': 'authorization_code',
        },

      );

      // Extract the access token from the response
      final data = jsonDecode(response.body);
      print(data);
      final accessToken = data['access_token'];
      print(accessToken);

      // Use the access token to access the Google API
      final userInfoResponse = await http.get(
        Uri.https('www.googleapis.com', '/oauth2/v2/userinfo'),
        headers: {
          'Authorization': 'Bearer $accessToken',
        },
      );
      return userInfoResponse.body.toString();

      // Extract the required data
      final userInfo = jsonDecode(userInfoResponse.body);
      final email = userInfo['email'];
      final name = userInfo['name'];
      final picture = userInfo['picture'];

      // Do something with the data
      print(email);
      print(name);
      print(picture);
    }
  } catch (e) {
    print(e);
  }
}

void main() {
  runApp(miercoles());
}

class miercoles extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Google Sign In'),
        ),
        body: Center(
          child: ElevatedButton(
            child: Text('Sign in with Google'),
            onPressed: () async {
              // Get the auth code
              final code = await getGoogleAuthCode();
            },
          ),
        ),
      ),
    );
  }

}
