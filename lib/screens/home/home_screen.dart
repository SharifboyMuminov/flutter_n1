import 'package:flutter/material.dart';
import 'package:flutter_n1/data/api_provider/api_provider.dart';
import 'package:flutter_n1/data/model/network_response.dart';
import 'package:flutter_n1/data/model/user_model.dart';
import 'package:flutter_n1/screens/auth/login.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  UserModel userModel = UserModel.initial();

  final ApiProvider apiProvider = ApiProvider();

  final TextEditingController controllerLastName = TextEditingController();
  final TextEditingController controllerFirstName = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
          future: ApiProvider.getUser(),
          builder: (
            BuildContext context,
            AsyncSnapshot<NetworkResponse> snapshot,
          ) {
            if (snapshot.data != null) {
              userModel = snapshot.data!.data as UserModel;

              controllerLastName.text = userModel.lastName;
              controllerFirstName.text = userModel.firstName;

              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextFormField(
                      controller: controllerFirstName,
                      decoration:
                          InputDecoration(hintText: "Enter first name..."),
                    ),
                    TextFormField(
                      controller: controllerLastName,
                      decoration:
                          InputDecoration(hintText: "Enter last name..."),
                    ),
                    SizedBox(height: 50),
                    TextButton(
                      onPressed: () async {
                        userModel = userModel.copyWith(
                          lastName: controllerLastName.text,
                          firstName: controllerFirstName.text,
                        );

                        NetworkResponse networkResponse =
                            await ApiProvider.updateUser(
                          userModel: userModel,
                        );

                        if (networkResponse.errorText.isEmpty) {
                          setState(() {});
                          showMySnackBar(message: "Good");
                        } else {
                          showMySnackBar(message: networkResponse.errorText);
                        }
                      },
                      child: Text("Update date"),
                    ),
                  ],
                ),
              );
            } else if (snapshot.hasError) {
              return Center(
                child: Text(
                  snapshot.error.toString(),
                ),
              );
            } else {
              return const Center(child: CircularProgressIndicator());
            }
          }),
      floatingActionButton: FloatingActionButton(onPressed: () async {
        NetworkResponse networkResponse =
            await ApiProvider.deleteUser(userId: userModel.id);

        if (networkResponse.errorText.isEmpty) {
          showMySnackBar(message: "Good");

          Navigator.pushAndRemoveUntil(context, MaterialPageRoute(
            builder: (context) {
              return LoginScreen();
            },
          ), (v) => false);
        } else {
          showMySnackBar(message: networkResponse.errorText);
        }
      }),
    );
  }

  void showMySnackBar({required String message}) {
    Future.microtask(() {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            message,
          ),
        ),
      );
    });
  }
}
