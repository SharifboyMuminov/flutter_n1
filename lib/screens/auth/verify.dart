import 'package:flutter/material.dart';
import 'package:flutter_n1/data/api_provider/api_provider.dart';
import 'package:flutter_n1/data/model/network_response.dart';
import 'package:flutter_n1/screens/home/home_screen.dart';

class VerifyScreen extends StatefulWidget {
  const VerifyScreen({super.key, required this.phoneNumber});

  final String phoneNumber;

  @override
  State<VerifyScreen> createState() => _VerifyScreenState();
}

class _VerifyScreenState extends State<VerifyScreen> {
  String code = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          TextFormField(
            onChanged: (String v) {
              code = v;
              setState(() {});
            },
          ),
          SizedBox(
            height: 50,
          ),
          TextButton(
            onPressed: () async {
              NetworkResponse networkResponse = await ApiProvider.verifyCode(
                phoneNumber: widget.phoneNumber,
                code: code,
              );

              if (networkResponse.errorText.isEmpty) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) {
                      return HomeScreen();
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
              "Tasdiqlash",
            ),
          ),
        ],
      ),
    );
  }
}
