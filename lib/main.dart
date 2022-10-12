import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_web_auth_2/flutter_web_auth_2.dart';

import 'dart:convert' show jsonDecode;
import 'package:http/http.dart' as http;

// App specific variables
final googleClientId = 'XXXXXXXXXXXX-xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx.apps.googleusercontent.com';
final callbackUrlScheme = 'com.googleusercontent.apps.XXXXXXXXXXXX-xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx';

// Construct the url
final url = Uri.https('accounts.google.com', '/o/oauth2/v2/auth', {
  'response_type': 'code',
  'client_id': googleClientId,
  'redirect_uri': '$callbackUrlScheme:/',
  'scope': 'email',
});

// Present the dialog to the user
  Future<String> getGoogleAuthCode() async {
  final result = await FlutterWebAuth2.authenticate(
    url: url.toString(),
    callbackUrlScheme: callbackUrlScheme,
  );

  // Extract the code from the response URL
  final code = await FlutterWebAuth2.authenticate(url: url.toString(), callbackUrlScheme: callbackUrlScheme);
  return code;
  return Future.value(code);

}

String casteo= getGoogleAuthCode() as String;
//final result = await FlutterWebAuth2.authenticate(url: url.toString(), callbackUrlScheme: callbackUrlScheme);

// Extract code from resulting url
final result1 = Uri.parse(casteo).queryParameters['code'];
print(result1) {
  // TODO: implement print
  throw UnimplementedError();
}

Future<String> finalresponse()async {
  final response = await http.post(
    Uri.parse('https://www.googleapis.com/oauth2/v4/token'),
    body: {
      'code': result1,
      'client_id': googleClientId,
      'redirect_uri': '$callbackUrlScheme:/',
      'grant_type': 'authorization_code',
    },
  );

  // Extract the access token from the response
  final body = jsonDecode(response.body);
  final accessToken = jsonDecode(response.body)['access_token'] as String;
  return accessToken;
}


class  miercoles extends StatelessWidget {
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

              // Exchange the code for an access token
              final accessToken = await exchangeCodeForToken(code);

              // Use the access token to access the Google API
              final response = await http.get(
                Uri.parse('https://www.googleapis.com/userinfo/v2/me'),
                headers: {
                  'Authorization': 'Bearer $accessToken',
                },
              );

              // Show the user's email address
              final body = jsonDecode(response.body);
              final email = body['email'] as String;
              print(email);
            },
          ),
        ),
      ),
      );
  }

  Future<String>exchangeCodeForToken(String code) async {
    final response = await http.post(
      Uri.parse('https://www.googleapis.com/oauth2/v4/token'),
      body: {
        'code': code,
        'client_id': googleClientId,
        'redirect_uri': '$callbackUrlScheme:/',
        'grant_type': 'authorization_code',
      },
    );

    // Extract the access token from the response
    final body = jsonDecode(response.body);
    final accessToken = jsonDecode(response.body)['access_token'] as String;
    return accessToken;
  }
}

