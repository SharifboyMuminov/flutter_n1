import 'package:flutter/material.dart';
import 'package:flutter_n1/data/api_provider/api_provider.dart';
import 'package:flutter_n1/data/model/network_response.dart';
import 'package:flutter_n1/screens/auth/verify.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  String phoneNumber = "";

  final FocusNode focusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          TextFormField(
            focusNode: focusNode,
            onChanged: (String v) {
              phoneNumber = v;
              setState(() {});
            },
          ),
          SizedBox(
            height: 50,
          ),
          TextButton(
            onPressed: () async {
              focusNode.unfocus();
              NetworkResponse networkResponse = await ApiProvider.createClient(
                phoneNumber: phoneNumber,
              );

              if (networkResponse.errorText.isEmpty) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) {
                      return VerifyScreen(phoneNumber: phoneNumber);
                    },
                  ),
                );
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      networkResponse.errorText,
                    ),
                  ),
                );
              }
            },
            child: Text(
              "SMS yuborish",
            ),
          ),
        ],
      ),
    );
  }
}
