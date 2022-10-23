import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_web_auth_2/flutter_web_auth_2.dart';

import 'dart:convert' show jsonDecode;
import 'package:http/http.dart' as http;

// App specific variables
final googleClientId = '37130';
final callbackUrlScheme = 'com.example.ui://';

// Construct the url
final url = Uri.https('bungie.com', '/en/oauth/authorize', {
  'client_id': googleClientId,
  'response_type': 'code',
});

// Present the dialog to the user
Future<String?> getGoogleAuthCode() async {
  final result = await FlutterWebAuth2.authenticate(
    url: url.toString(),
    callbackUrlScheme: callbackUrlScheme,
  );

  // Extract the code from the response URL

  //String casteo = getGoogleAuthCode().toString();
//final result = await FlutterWebAuth2.authenticate(url: url.toString(), callbackUrlScheme: callbackUrlScheme);

// Extract code from resulting url
  final result1 = Uri.parse(result).queryParameters['code'];
  print(result) {
    // TODO: implement print
    throw UnimplementedError();
  }

  var headers = {
    'Content-Type': 'application/x-www-form-urlencoded',
    'code': '$result1',
  };
  var request = http.Request(
      'POST', Uri.parse('https://www.bungie.net/platform/app/oauth/token'));

  request.headers.addAll(headers);

  http.StreamedResponse response = await request.send();

  if (response.statusCode == 200) {
    print(await response.stream.bytesToString());
  } else {
    print(response.reasonPhrase);
  }

  // Extract the access token from the response
  //final data = jsonDecode(response.body);

  // Use the access token to access the Google API

  // Do something with the data
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

              getGoogleAuthCode();
            },
          ),
        ),
      ),
    );
  }
}
