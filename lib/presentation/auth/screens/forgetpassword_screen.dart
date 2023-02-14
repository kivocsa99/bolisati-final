import 'package:auto_route/auto_route.dart';
import 'package:bolisati/application/auth/ali_api/forget_paswword/forget.password.use.case.input.dart';
import 'package:bolisati/presentation/auth/widgets/email.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../application/auth/ali_api/forget_paswword/forget.password.use_case.dart';
import '../../../domain/api/failures/api.failures.dart';
import '../../../domain/api/user/model/usermodel.dart';
import '../../../router/app_route.gr.dart';
import '../widgets/PhoneNumber.dart';

class ForgetPasswordScreen extends HookConsumerWidget {
  const ForgetPasswordScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = useState(const UserModel());

    final phoneformkey = useState(GlobalKey<FormState>());
    final emailformkey = useState(GlobalKey<FormState>());
    final isloading = useState(false);
    List<Widget> cases = [
      PhoneNumberField(
        forget: false,
        validator: MultiValidator([
          RequiredValidator(errorText: "reqfield".tr()),
          LengthRangeValidator(min: 10, max: 10, errorText: "phonereq".tr())
        ]),
        formkey: phoneformkey.value,
        onchanged: (value) => user.value = user.value.copyWith(phone: value),
        key: const Key("0"),
      ),
      EmailField(
        forget: true,
        validator: RequiredValidator(errorText: "reqfield".tr()),
        formkey: emailformkey.value,
        onchanged: (value) => user.value = user.value.copyWith(email: value),
        key: const Key("1"),
      ),
    ];
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
                              style: const TextStyle(color: Colors.white),
                            )),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            if (index.value == 0) {
                              if (phoneformkey.value.currentState!.validate()) {
                                final isLaseIndex =
                                    index.value == cases.length - 1;
                                index.value = isLaseIndex ? 0 : index.value + 1;
                              }
                            } else if (index.value == 1) {
                              if (emailformkey.value.currentState!.validate()) {
                                FocusScope.of(context).unfocus();
                                isloading.value = true;
                                ref
                                    .read(forgetPasswordUseCaseprovider)
                                    .execute(ForgetPasswordUseCaseInput(
                                        email: user.value.email,
                                        phone: user.value.phone))
                                    .then((value) => value.fold((l) {
                                          isloading.value = false;
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(SnackBar(
                                                  content: const Text("contact")
                                                      .tr()));
                                        }, (r) {
                                          isloading.value = false;
                                          if (r ==
                                              const ApiFailures.authFailed()) {
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(SnackBar(
                                                    content:
                                                        const Text("logincheck")
                                                            .tr()));
                                          } else {
                                            showDialog(
                                              barrierDismissible: false,
                                              context: context,
                                              builder: (context) {
                                                return SimpleDialog(
                                                    title: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        Image.asset(
                                                          "assets/logo.png",
                                                          scale: 1.5,
                                                        ),
                                                        const SizedBox(
                                                          width: 10,
                                                        ),
                                                        const Text(
                                                          'orderdes',
                                                        ).tr(),
                                                      ],
                                                    ),
                                                    children: [
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                    .only(
                                                                left: 40.0,
                                                                right: 40.0),
                                                        child:
                                                            const Text("pass")
                                                                .tr(),
                                                      ),
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                    .only(
                                                                left: 40.0,
                                                                right: 40.0),
                                                        child: GestureDetector(
                                                          onTap: () async {
                                                            await context.router
                                                                .replaceAll([
                                                              const LoginScreen()
                                                            ]);
                                                          },
                                                          child: Container(
                                                            color: Colors
                                                                .blue[600],
                                                            width: 100,
                                                            height: 60,
                                                            child: Center(
                                                                child:
                                                                    const Text(
                                                              "confirm",
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .white,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold),
                                                            ).tr()),
                                                          ),
                                                        ),
                                                      )
                                                    ]);
                                              },
                                            );
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
                                child: const Text(
                              "confirm",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
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
