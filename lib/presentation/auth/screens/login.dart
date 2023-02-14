// ignore_for_file: prefer_const_constructors, avoid_print

import 'package:auto_route/auto_route.dart';
import 'package:bolisati/domain/api/failures/api.failures.dart';
import 'package:bolisati/router/app_route.gr.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../application/auth/ali_api/use_cases/sign_in_with_email_and_password/sign_in_with_email_and_password.input.dart';
import '../../../application/auth/ali_api/use_cases/sign_in_with_email_and_password/sign_in_with_email_and_password.use_case.dart';
import '../../../application/auth/ali_api/use_cases/update/update_use_case.dart';
import '../../../application/auth/ali_api/use_cases/update/update_use_case.input.dart';
import '../../../domain/api/user/model/usermodel.dart';
import '../../../main.dart';
import '../widgets/PhoneNumber.dart';
import '../widgets/password.dart';

class LoginScreen extends HookConsumerWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = useState(const UserModel());

    final passswordController = useTextEditingController();
    final phoneformkey = useState(GlobalKey<FormState>());
    final passformkey = useState(GlobalKey<FormState>());
    List<Widget> cases = [
      PhoneNumberField(
        forget: true,
        validator: MultiValidator([
          RequiredValidator(errorText: "reqfield".tr()),
          LengthRangeValidator(min: 10, max: 10, errorText: "phonereq".tr())
        ]),
        formkey: phoneformkey.value,
        onchanged: (value) => user.value = user.value.copyWith(phone: value),
        key: const Key("0"),
      ),
      PasswordField(
        obscureText: true,
        validator: MultiValidator([
          RequiredValidator(errorText: "reqfield".tr()),
          LengthRangeValidator(
              min: 8,
              max: 20,
              errorText: "Please Provide a password between 8 and 20 digits")
        ]),
        controller: passswordController,
        formkey: passformkey.value,
        key: const Key("1"),
      )
    ];
    final isloading = useState(false);
    final index = useState(0);
    return Stack(
      children: [
        Scaffold(
          body: SafeArea(
            child: Container(
              color: Colors.white,
              height: MediaQuery.of(context).size.height,
              child: Stack(
                children: [
                  Positioned(
                    left: MediaQuery.of(context).size.width / 2 - 130,
                    top: 30,
                    child: Image.asset(
                      "assets/bolisati.png",
                      color: Colors.black,
                    ),
                  ),
                  Positioned(
                    left: 52,
                    top: 30,
                    child: Image.asset(
                      "assets/logo.png",
                    ),
                  ),
                  Positioned(
                      top: 100,
                      right: 0,
                      left: 0,
                      child: AnimatedSwitcher(
                        duration: const Duration(microseconds: 500),
                        child: SizedBox(
                          width: double.infinity,
                          child: cases[index.value],
                        ),
                      )),
                  Positioned(
                    top: 350,
                    left: 40,
                    right: 40,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        GestureDetector(
                          onTap: () {
                            if (index.value != 0) {
                              index.value = index.value - 1;
                            }
                          },
                          child: Container(
                            color: index.value == 0
                                ? Colors.grey
                                : Colors.blue[600],
                            width: MediaQuery.of(context).size.width / 3,
                            height: 60,
                            child: Center(
                                child: Text(
                              "back".tr(),
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                            )),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            if (index.value == 0) {
                              if (phoneformkey.value.currentState!.validate()) {
                                FocusScope.of(context).unfocus();
                                final isLaseIndex =
                                    index.value == cases.length - 1;
                                index.value = isLaseIndex ? 0 : index.value + 1;
                              }
                            } else if (index.value == 1) {
                              if (passformkey.value.currentState!.validate()) {
                                FocusScope.of(context).unfocus();

                                isloading.value = true;

                                ref
                                    .read(
                                        signInWithEmailAndPasswordUseCaseProvider)
                                    .execute(
                                        SignInWithEmailAndPasswordUseCaseInput(
                                            email: user.value.phone,
                                            password: passswordController.text))
                                    .then((value) => value.fold((l) {
                                          isloading.value = false;
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(SnackBar(
                                                  content:
                                                      Text("contact").tr()));
                                        }, (r) {
                                          if (r ==
                                              const ApiFailures.authFailed()) {
                                            isloading.value = false;
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(SnackBar(
                                                    content: Text("logincheck")
                                                        .tr()));
                                          } else {
                                            ref
                                                .read(updateuserprovider)
                                                .execute(UpdateUserInput(
                                                  urlvalue: "fcm_token",
                                                  token: r,
                                                  value: token,
                                                ))
                                                .then((value) =>
                                                    value.fold((l) {
                                                      isloading.value = false;
                                                      ScaffoldMessenger.of(
                                                              context)
                                                          .showSnackBar(SnackBar(
                                                              content: const Text(
                                                                      "contact")
                                                                  .tr()));
                                                    }, (r) async {
                                                      isloading.value = false;
                                                      context.router.replaceAll(
                                                          [HomeScreen()]);
                                                    }));
                                          }
                                        }));
                              }
                            }
                          },
                          child: Container(
                            color: Colors.blue[600],
                            width: MediaQuery.of(context).size.width / 3,
                            height: 60,
                            child: Center(
                                child: Text(
                              "confirm",
                              style: TextStyle(color: Colors.white),
                            ).tr()),
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
        Visibility(
          visible: isloading.value,
          child: Material(
            child: Center(
              child: Container(
                height: MediaQuery.of(context).size.height,
                width: double.infinity,
                color: Colors.black45,
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SpinKitThreeInOut(
                        color: Colors.blue,
                      ),
                      const Text("processorder").tr()
                    ],
                  ),
                ),
              ),
            ),
          ),
        )
      ],
    );
  }
}
