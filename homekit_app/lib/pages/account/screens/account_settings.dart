import 'package:homekit_app/common/widgets/custom_button.dart';
import 'package:homekit_app/common/widgets/custom_textfield.dart';
import 'package:homekit_app/constants/global_variables.dart';
import 'package:homekit_app/pages/account/services/account_services.dart';
import 'package:flutter/material.dart';

class AccountSettings extends StatefulWidget {
  static const String routeName = '/update';
  const AccountSettings({super.key});

  @override
  State<AccountSettings> createState() => _AccountSettingsState();
}

class _AccountSettingsState extends State<AccountSettings> {
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _passwordDeleteController =
      TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final AccountServices accountServices = AccountServices();
  final _updatePasswordFormKey = GlobalKey<FormState>();
  final _deleteAccountFormKey = GlobalKey<FormState>();

  void updatePassword() {
    accountServices.updatePassword(
      context: context,
      password: _passwordController.text,
      newPassword: _newPasswordController.text,
    );
  }

  void deleteAccount() {
    accountServices.deleteAccount(
      context: context,
      password: _passwordDeleteController.text,
    );
  }

  Future<void> askPassword() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: true, // Allow dismissal by tapping outside
      builder: (BuildContext context) {
        return AlertDialog.adaptive(
          title: const Text('Deleting Account:'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Form(
                  key: _deleteAccountFormKey,
                  child: Column(
                    children: [
                      const SizedBox(height: 50),
                      const Text(
                        "Enter Your Password!",
                        style: TextStyle(
                          fontSize: 24, // Set the font size to 24
                          fontWeight: FontWeight.bold, // Make the text bold
                        ),
                      ),
                      const SizedBox(height: 50),
                      CustomTextField(
                        controller: _passwordDeleteController,
                        filled: false,
                        hintText: 'Password',
                      ),
                      const SizedBox(height: 10),
                      CustomButton(
                        icon: Icons.delete_forever_outlined,
                        color: GlobalVariables.buttonDeleteColor,
                        text: 'Confirm Deleting Account',
                        onTap: () {
                          if (_deleteAccountFormKey.currentState!.validate()) {
                            deleteAccount();
                          }
                        },
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
      ),
      body: Container(
        padding: const EdgeInsets.all(10),
        color: GlobalVariables.fieldColor,
        child: Column(
          children: [
            DecoratedBox(
              decoration: BoxDecoration(
                border: Border.all(
                  color: const Color(0xFFE75480), // Rose
                  width: 0.5,
                ),
                borderRadius: BorderRadius.circular(5),
                color: const Color(0xFFf5c8ca), // Light Rose
              ),
              child: Container(
                height: MediaQuery.of(context).size.height / 2.55,
                width: MediaQuery.of(context).size.width,
                padding: const EdgeInsets.all(10),
                child: Column(
                  children: [
                    Form(
                      key: _updatePasswordFormKey,
                      child: Column(
                        children: [
                          SizedBox(
                              height:
                                  MediaQuery.of(context).size.height * 0.025),
                          const Text(
                            "Change Password",
                            style: TextStyle(
                              fontSize: 24, // Set the font size to 24
                              fontWeight: FontWeight.bold, // Make the text bold
                            ),
                          ),
                          SizedBox(
                              height:
                                  MediaQuery.of(context).size.height * 0.03),
                          CustomTextField(
                            controller: _passwordController,
                            color: GlobalVariables.fieldColor,
                            filled: true,
                            hintText: 'Current Password',
                          ),
                          const SizedBox(height: 10),
                          CustomTextField(
                            controller: _newPasswordController,
                            color: GlobalVariables.fieldColor
                            ,
                            filled: true,
                            hintText: 'New Password',
                          ),
                          SizedBox(
                              height:
                                  MediaQuery.of(context).size.height * 0.035),
                          CustomButton(
                            icon: Icons.update,
                            color: GlobalVariables.buttonBackgroundColor,
                            text: 'Change Password',
                            onTap: () {
                              if (_updatePasswordFormKey.currentState!
                                  .validate()) {
                                updatePassword();
                              }
                            },
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const Expanded(
              child: SizedBox(), // Add any other content here
            ),
            SizedBox(
              child: CustomButton(
                text: 'Delete Account',
                icon: Icons.delete,
                color: GlobalVariables.buttonDeleteColor,
                onTap: () {
                  askPassword();
                },
              ),
            ),
            const SizedBox(height: 50),
          ],
        ),
      ),
    );
  }
}
