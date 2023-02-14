import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:bolisati/presentation/auth/widgets/email.dart';
import 'package:bolisati/presentation/auth/widgets/name.dart';
import 'package:bolisati/presentation/auth/widgets/otp.dart';
import 'package:bolisati/presentation/auth/widgets/password.dart';
import 'package:bolisati/presentation/auth/widgets/welcome.dart';
import 'package:bolisati/presentation/widgets/main_widget.dart';
import 'package:bolisati/presentation/widgets/animated_bolisati.dart';
import 'package:bolisati/presentation/widgets/animated_buttons.dart';
import 'package:bolisati/presentation/widgets/animated_form.dart';
import 'package:bolisati/presentation/widgets/animated_landing_container.dart';
import 'package:bolisati/presentation/widgets/animated_logo.dart';
import 'package:bolisati/presentation/widgets/animated_video.dart';
import 'package:bolisati/router/app_route.gr.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../application/auth/ali_api/use_cases/sign_up_with_email_and_password/sign_up_with_email_and_password.input.dart';
import '../../../application/auth/ali_api/use_cases/sign_up_with_email_and_password/sign_up_with_email_and_password.use_case.dart';
import '../../../application/auth/ali_api/use_cases/update/update_use_case.dart';
import '../../../application/auth/ali_api/use_cases/update/update_use_case.input.dart';
import '../../../domain/api/user/model/usermodel.dart';
import '../../../main.dart';
import '../../auth/widgets/PhoneNumber.dart';

class LandingScreen extends HookConsumerWidget {
  final BoxConstraints? constraints;

  const LandingScreen({super.key, this.constraints});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final Box setting = Hive.box("setting");
    MediaQuery.of(context).removePadding(removeTop: true);
    final passswordController = useTextEditingController();
    final otpcontroller = useTextEditingController();
    final nameformkey = useState(GlobalKey<FormState>());
    final otpformkey = useState(GlobalKey<FormState>());
    final phoneformkey = useState(GlobalKey<FormState>());
    final emailformkey = useState(GlobalKey<FormState>());
    final passformkey = useState(GlobalKey<FormState>());
    final islogodone = useState(false);
    final isstarted = useState(false);
    final islogostarted = useState(false);
    final isLoginFormStarted = useState(false);
    final isloginended = useState(false);
    final isgettingmain = useState(false);
    final user = useState(const UserModel());
    final isloading = useState(false);
    final enabled = useState(false);
    final myfuture = useMemoized(() async {
      await Future.delayed(const Duration(microseconds: 200), () {
        isstarted.value = true;
        islogostarted.value = true;
      });
    }, []);
    final button = useState(false);

    useFuture(myfuture);
    List<Widget> registercases = [
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
      OtpVerfication(
        enabled: enabled.value,
        function: enabled.value == true
            ? () async {
                FocusScope.of(context).unfocus();

                isloading.value = true;
                await FirebaseAuth.instance.verifyPhoneNumber(
                    phoneNumber: "+962${user.value.phone!.substring(1)}",
                    verificationCompleted: (verificationCompleted) {},
                    verificationFailed: (verificationFailed) {
                      isloading.value = false;
                      ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: const Text("contact").tr()));
                    },
                    codeSent: (value, codeSent) async {
                      isloading.value = false;
                      enabled.value = false;
                      Timer(const Duration(seconds: 30), () {
                        enabled.value = true;
                      });
                      ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: const Text("resend").tr()));
                      await setting.put("firebase", value);
                    },
                    codeAutoRetrievalTimeout: (codeAutoRetrievalTimeout) {});
              }
            : () {
                FocusScope.of(context).unfocus();
                ScaffoldMessenger.of(context)
                    .showSnackBar(SnackBar(content: const Text("after").tr()));
              },
        validator: MultiValidator([
          RequiredValidator(errorText: "reqfield".tr()),
          LengthRangeValidator(
              min: 6, max: 6, errorText: "Please Provide a 6 digit code")
        ]),
        formkey: otpformkey.value,
        controller: otpcontroller,
        key: const Key("1"),
      ),
      NameField(
        validator: RequiredValidator(errorText: "reqfield".tr()),
        formkey: nameformkey.value,
        onchanged: (value) => user.value = user.value.copyWith(name: value),
        key: const Key("2"),
      ),
      EmailField(
        validator: RequiredValidator(errorText: "reqfield".tr()),
        formkey: emailformkey.value,
        onchanged: (value) => user.value = user.value.copyWith(email: value),
        key: const Key("3"),
      ),
      PasswordField(
        button: button.value,
        signup: true,
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
        key: const Key("4"),
      ),
      WelcomeAboard(
        name: user.value.name,
        key: const Key("5"),
      ),
      const MainScreen(
        key: Key("6"),
      )
    ];

    final index = useState(0);
    return Scaffold(
      backgroundColor: Colors.white,
      body: SizedBox(
        height: constraints!.maxHeight,
        width: constraints!.maxWidth,
        child: Stack(
          children: [
            AnimatedLandingContainer(
              isStarted: isstarted.value,
              width: constraints!.maxWidth,
              function1: () async {
                islogodone.value = true;
                isstarted.value = false;
                isLoginFormStarted.value = true;
              },
              function: () async {
                context.router.push(const LoginScreen());
              },
            ),
            AnimatedVideo(
              isStarted: isstarted.value,
              width: constraints!.maxWidth,
            ),
            AnimatedLogo(
              isgettingmain: isgettingmain.value,
              isdone: isloginended.value,
              isStarted: islogostarted.value,
              islogodone: islogodone.value,
              width: 50,
            ),
            AnimatedSignUpForm(
              backcolor: index.value == 0 ? Colors.grey : Colors.blue[600],
              function1: () {
                if (index.value != 0) {
                  index.value = index.value - 1;
                }
              },
              isgettingmain: isgettingmain.value,
              isdone: isloginended.value,
              isStarted: isLoginFormStarted.value,
              width: constraints!.maxWidth,
              index: index.value,
              list: registercases,
              function: () async {
                if (index.value == 0 &&
                    phoneformkey.value.currentState!.validate()) {
                  FocusScope.of(context).unfocus();
                  isloading.value == true;
                  await FirebaseAuth.instance
                      .verifyPhoneNumber(
                          phoneNumber: "+962${user.value.phone!.substring(1)}",
                          verificationCompleted: (verificationCompleted) {},
                          verificationFailed: (verificationFailed) {
                            isloading.value = false;
                            ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: const Text("contact").tr()));
                          },
                          codeSent: (value, codeSent) async {
                            Timer(const Duration(seconds: 30), () {
                              enabled.value = true;
                            });
                            isloading.value = false;
                            await setting.put("firebase", value);
                            final isLaseIndex =
                                index.value == registercases.length - 1;
                            index.value = isLaseIndex ? 0 : index.value + 1;
                          },
                          timeout: const Duration(seconds: 30),
                          codeAutoRetrievalTimeout:
                              (codeAutoRetrievalTimeout) {})
                      .then((value) => null);
                } else if (index.value == 1 &&
                    otpformkey.value.currentState!.validate()) {
                  FocusScope.of(context).unfocus();

                  isloading.value = true;
                  final phone = PhoneAuthProvider.credential(
                      verificationId: setting.get("firebase"),
                      smsCode: otpcontroller.text);
                  try {
                    await FirebaseAuth.instance
                        .signInWithCredential(phone)
                        .then((value) {
                      isloading.value = false;
                      final isLaseIndex =
                          index.value == registercases.length - 1;
                      index.value = isLaseIndex ? 0 : index.value + 1;
                    });
                  } catch (error) {
                    print(error);
                    isloading.value = false;
                    ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: const Text("contact").tr()));
                  }
                } else if (index.value == 2 &&
                    nameformkey.value.currentState!.validate()) {
                  final isLaseIndex = index.value == registercases.length - 1;
                  index.value = isLaseIndex ? 0 : index.value + 1;
                } else if (index.value == 3 &&
                    emailformkey.value.currentState!.validate()) {
                  final isLaseIndex = index.value == registercases.length - 1;
                  index.value = isLaseIndex ? 0 : index.value + 1;
                } else if (index.value == 4 &&
                    passformkey.value.currentState!.validate()) {
                  FocusScope.of(context).unfocus();
                  if (setting.get("privacy") == true) {
                    isloading.value = true;
                    await setting.put("name", user.value.name);
                    await ref
                        .read(signUpWithEmailAndPasswordUseCaseProvider)
                        .execute(SignUpWithEmailAndPasswordUseCaseInput(
                            user: user.value,
                            password: passswordController.text))
                        .then(
                          (result) => result.fold(
                            (l) async {
                              isloading.value = false;
                              ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                      content: const Text("contact").tr()));
                            },
                            (r) async {
                              if (r.toString() == "ApiFailures.authFailed()") {
                                isloading.value = false;

                                ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                        content:
                                            const Text("logincheck").tr()));
                              } else {
                                isloading.value = false;
                                ref
                                    .read(updateuserprovider)
                                    .execute(UpdateUserInput(
                                      urlvalue: "fcm_token",
                                      token: r,
                                      value: token,
                                    ))
                                    .then((value) => value.fold((l) {
                                          print(l);
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(SnackBar(
                                                  content: const Text("contact")
                                                      .tr()));
                                        }, (r) async {
                                          context.router
                                              .replaceAll([HomeScreen()]);
                                        }));
                              }
                            },
                          ),
                        );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: const Text("acceptpolicy").tr()));
                  }
                }
              },
            ),
            AnimatedBolisati(
              isgettingui: isgettingmain.value,
            ),
            AnimatedButtons(
              isgettingui: isgettingmain.value,
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
            ),
          ],
        ),
      ),
    );
  }
}
