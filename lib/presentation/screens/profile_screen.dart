import 'package:auto_route/auto_route.dart';
import 'package:bolisati/application/auth/ali_api/delete_acc/delete_account.use_case.input.dart';
import 'package:bolisati/infrastructure/auth/api.auth.facade.dart';
import 'package:bolisati/presentation/domestic/widgets/domesticinformationcontainer.dart';
import 'package:bolisati/router/app_route.gr.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../application/auth/ali_api/delete_acc/delete_account.use_case.dart';
import '../../application/auth/ali_api/use_cases/update/update_use_case.dart';
import '../../application/auth/ali_api/use_cases/update/update_use_case.input.dart';

class ProfileScreen extends HookConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final namecontroller = useTextEditingController();
    final emailcontroller = useTextEditingController();
    final passwordcontroller = useTextEditingController();
    final phonecontroller = useTextEditingController();
    final namekey = useState(GlobalKey<FormState>());
    final emailkey = useState(GlobalKey<FormState>());
    final passwordkey = useState(GlobalKey<FormState>());
    final phonekey = useState(GlobalKey<FormState>());

    final Box user = Hive.box("setting");
    return SafeArea(
      child: Scaffold(
        body: Container(
          color: Colors.white,
          height: MediaQuery.of(context).size.height,
          child: Stack(
            children: [
              context.locale.languageCode == "en"
                  ? Positioned(
                      left: 20,
                      top: 30,
                      child: IconButton(
                          onPressed: () {
                            context.router.pop();
                          },
                          icon: const Icon(Icons.arrow_back_ios_new)))
                  : Positioned(
                      right: 20,
                      top: 30,
                      child: IconButton(
                          onPressed: () {
                            context.router.pop();
                          },
                          icon: const Icon(FontAwesomeIcons.arrowRight))),
              Positioned(
                  left: context.locale.languageCode == "ar" ? 0 : 80,
                  right: context.locale.languageCode == "ar" ? 80 : 0,
                  top: 40,
                  child: const Text(
                    "profile",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ).tr()),
              Positioned(
                top: 70,
                left: 20,
                right: 20,
                child: SizedBox(
                  height: MediaQuery.of(context).size.height,
                  child: ListView(
                    children: [
                      const SizedBox(
                        height: 50,
                      ),
                      ProfileContainer(
                        title: "name".tr(),
                        subtitle: user.get("name"),
                        ontap: () {
                          showDialog(
                            context: context,
                            builder: (context) {
                              return SimpleDialog(
                                  title: Row(
                                    children: [
                                      Image.asset(
                                        "assets/logo.png",
                                        scale: 1.5,
                                      ),
                                      const SizedBox(
                                        width: 20,
                                      ),
                                      const Text(
                                        'namechange',
                                      ).tr(),
                                    ],
                                  ),
                                  children: [
                                    Form(
                                      key: namekey.value,
                                      child: CustomField(
                                        validator: RequiredValidator(
                                            errorText: "reqfield".tr()),
                                        readonly: false,
                                        controller: namecontroller,
                                        type: TextInputType.text,
                                        label: "name".tr(),
                                        width: double.infinity,
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          left: 40.0, right: 40.0),
                                      child: GestureDetector(
                                        onTap: () async {
                                          if (namekey.value.currentState!
                                              .validate()) {
                                            ref
                                                .read(updateuserprovider)
                                                .execute(UpdateUserInput(
                                                  urlvalue: "name",
                                                  token: user.get("apitoken"),
                                                  value: user.get("name"),
                                                ))
                                                .then((value) => value.fold(
                                                        (l) => ScaffoldMessenger
                                                                .of(context)
                                                            .showSnackBar(SnackBar(
                                                                content: const Text(
                                                                        "contact")
                                                                    .tr())),
                                                        (r) async {
                                                      await user.put("name",
                                                          namecontroller.text);
                                                      if (context.mounted) {
                                                        await context.router
                                                            .pop();
                                                      }
                                                    }));
                                          }
                                        },
                                        child: Container(
                                          color: Colors.blue[600],
                                          width: 100,
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
                                    )
                                  ]);
                            },
                          );
                        },
                        icon: FontAwesomeIcons.user,
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      ProfileContainer(
                        title: "email".tr(),
                        subtitle: user.get("email"),
                        ontap: () {
                          showDialog(
                            context: context,
                            builder: (context) {
                              return SimpleDialog(
                                  title: Row(
                                    children: [
                                      Image.asset(
                                        "assets/logo.png",
                                        scale: 1.5,
                                      ),
                                      const SizedBox(
                                        width: 20,
                                      ),
                                      const Text(
                                        'emailchange',
                                      ).tr(),
                                    ],
                                  ),
                                  children: [
                                    Form(
                                      key: emailkey.value,
                                      child: CustomField(
                                        validator: RequiredValidator(
                                            errorText: "reqfield".tr()),
                                        readonly: false,
                                        controller: emailcontroller,
                                        type: TextInputType.emailAddress,
                                        label: "email".tr(),
                                        width: double.infinity,
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          left: 40.0, right: 40.0),
                                      child: GestureDetector(
                                        onTap: () async {
                                          if (emailkey.value.currentState!
                                              .validate()) {
                                            ref
                                                .read(updateuserprovider)
                                                .execute(UpdateUserInput(
                                                  urlvalue: "email",
                                                  token: user.get("apitoken"),
                                                  value: emailcontroller.text,
                                                ))
                                                .then((value) => value.fold(
                                                        (l) => ScaffoldMessenger
                                                                .of(context)
                                                            .showSnackBar(SnackBar(
                                                                content: const Text(
                                                                        "contact")
                                                                    .tr())),
                                                        (r) async {
                                                      await user.put("email",
                                                          namecontroller.text);
                                                      if (context.mounted) {
                                                        await context.router
                                                            .pop();
                                                      }
                                                    }));
                                          }
                                        },
                                        child: Container(
                                          color: Colors.blue[600],
                                          width: 100,
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
                                    )
                                  ]);
                            },
                          );
                        },
                        icon: FontAwesomeIcons.envelopesBulk,
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      ProfileContainer(
                        title: "phone".tr(),
                        subtitle: user.get("phone"),
                        ontap: () {
                          showDialog(
                            context: context,
                            builder: (context) {
                              return SimpleDialog(
                                  title: Row(
                                    children: [
                                      Image.asset(
                                        "assets/logo.png",
                                        scale: 1.5,
                                      ),
                                      const SizedBox(
                                        width: 20,
                                      ),
                                      const Text(
                                        "phonechange",
                                      ).tr(),
                                    ],
                                  ),
                                  children: [
                                    Form(
                                      key: phonekey.value,
                                      child: CustomField(
                                        validator: RequiredValidator(
                                            errorText: "reqfield".tr()),
                                        readonly: false,
                                        controller: phonecontroller,
                                        type: TextInputType.number,
                                        label: "phone".tr(),
                                        width: double.infinity,
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          left: 40.0, right: 40.0),
                                      child: GestureDetector(
                                        onTap: () async {
                                          if (namekey.value.currentState!
                                              .validate()) {
                                            ref
                                                .read(updateuserprovider)
                                                .execute(UpdateUserInput(
                                                  urlvalue: "phone",
                                                  token: user.get("apitoken"),
                                                  value: phonecontroller.text,
                                                ))
                                                .then((value) => value.fold(
                                                        (l) => ScaffoldMessenger
                                                                .of(context)
                                                            .showSnackBar(SnackBar(
                                                                content: const Text(
                                                                        "contact")
                                                                    .tr())),
                                                        (r) async {
                                                      await user.put("name",
                                                          namecontroller.text);
                                                      if (context.mounted) {
                                                        await context.router
                                                            .pop();
                                                      }
                                                    }));
                                          }
                                        },
                                        child: Container(
                                          color: Colors.blue[600],
                                          width: 100,
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
                                    )
                                  ]);
                            },
                          );
                        },
                        icon: FontAwesomeIcons.phone,
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      ProfileContainer(
                        title: "password".tr(),
                        subtitle: "********",
                        ontap: () {
                          showDialog(
                            context: context,
                            builder: (context) {
                              return SimpleDialog(
                                  title: Row(
                                    children: [
                                      Image.asset(
                                        "assets/logo.png",
                                        scale: 1.5,
                                      ),
                                      const SizedBox(
                                        width: 20,
                                      ),
                                      const Text(
                                        'passwordchange',
                                      ).tr(),
                                    ],
                                  ),
                                  children: [
                                    Form(
                                      key: passwordkey.value,
                                      child: CustomField(
                                        validator: RequiredValidator(
                                            errorText: "reqfield".tr()),
                                        readonly: false,
                                        controller: passwordcontroller,
                                        type: TextInputType.text,
                                        label: "password".tr(),
                                        width: double.infinity,
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          left: 40.0, right: 40.0),
                                      child: GestureDetector(
                                        onTap: () async {
                                          if (passwordkey.value.currentState!
                                              .validate()) {
                                            ref
                                                .read(updateuserprovider)
                                                .execute(UpdateUserInput(
                                                  urlvalue: "password",
                                                  token: user.get("apitoken"),
                                                  value:
                                                      passwordcontroller.text,
                                                ))
                                                .then((value) => value.fold(
                                                        (l) => ScaffoldMessenger
                                                                .of(context)
                                                            .showSnackBar(SnackBar(
                                                                content: const Text(
                                                                        "contact")
                                                                    .tr())),
                                                        (r) async {
                                                      await user.put("name",
                                                          namecontroller.text);
                                                      if (context.mounted) {
                                                        context.router.pop();
                                                      }
                                                    }));
                                          }
                                        },
                                        child: Container(
                                          color: Colors.blue[600],
                                          width: 100,
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
                                    )
                                  ]);
                            },
                          );
                        },
                        icon: FontAwesomeIcons.lock,
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      ProfileContainer(
                        title: "language".tr(),
                        subtitle: context.locale.toString(),
                        ontap: () {
                          showDialog(
                            context: context,
                            builder: (context) {
                              return SimpleDialog(
                                  title: Row(
                                    children: [
                                      Image.asset(
                                        "assets/logo.png",
                                        scale: 1.5,
                                      ),
                                      const SizedBox(
                                        width: 20,
                                      ),
                                      const Text(
                                        'languagechange',
                                      ).tr(),
                                    ],
                                  ),
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          left: 40.0, right: 40.0),
                                      child: GestureDetector(
                                        onTap: () async {
                                          context
                                              .setLocale(const Locale("ar"))
                                              .then((value) =>
                                                  context.router.pop());
                                        },
                                        child: Container(
                                          color: Colors.blue[600],
                                          width: 10,
                                          height: 60,
                                          child: const Center(
                                              child: Text(
                                            "العربية",
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold),
                                          )),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 20,
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          left: 40.0, right: 40.0),
                                      child: GestureDetector(
                                        onTap: () async {
                                          context
                                              .setLocale(const Locale("en"))
                                              .then((value) {
                                            context.router.pop();
                                          });
                                        },
                                        child: Container(
                                          color: Colors.blue[600],
                                          width: 10,
                                          height: 60,
                                          child: const Center(
                                              child: Text(
                                            "English",
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold),
                                          )),
                                        ),
                                      ),
                                    )
                                  ]);
                            },
                          );
                        },
                        icon: FontAwesomeIcons.language,
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      ProfileContainer(
                        title: "logout".tr(),
                        ontap: () async {
                          await showDialog(
                            context: context,
                            builder: (context) {
                              return SimpleDialog(
                                  title: Row(
                                    children: [
                                      Image.asset(
                                        "assets/logo.png",
                                        scale: 1.5,
                                      ),
                                      const SizedBox(
                                        width: 20,
                                      ),
                                      const Text(
                                        'logoutdes',
                                        style: TextStyle(fontSize: 10),
                                      ).tr(),
                                    ],
                                  ),
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          left: 40.0, right: 40.0),
                                      child: GestureDetector(
                                        onTap: () async {
                                          await ApiAuthFacade()
                                              .signOut(context)
                                              .then((value) async {
                                            await context.router
                                                .replaceAll([MyApp()]);
                                          });
                                        },
                                        child: Container(
                                          color: Colors.blue[600],
                                          width: 10,
                                          height: 60,
                                          child: Center(
                                              child: const Text(
                                            "globalsyes",
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold),
                                          ).tr()),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 20,
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          left: 40.0, right: 40.0),
                                      child: GestureDetector(
                                        onTap: () async {
                                          context.router.pop();
                                        },
                                        child: Container(
                                          color: Colors.blue[600],
                                          width: 10,
                                          height: 60,
                                          child: Center(
                                              child: const Text(
                                            "globalsno",
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold),
                                          ).tr()),
                                        ),
                                      ),
                                    )
                                  ]);
                            },
                          );
                        },
                        icon: FontAwesomeIcons.rightFromBracket,
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      ProfileContainer(
                        title: "deleteacc".tr(),
                        ontap: () async {
                          await showDialog(
                            context: context,
                            builder: (context) {
                              return SimpleDialog(
                                  title: Row(
                                    children: [
                                      Image.asset(
                                        "assets/logo.png",
                                        scale: 1.5,
                                      ),
                                      const SizedBox(
                                        width: 20,
                                      ),
                                      const Text(
                                        'deleteaccdes',
                                        style: TextStyle(fontSize: 10),
                                      ).tr(),
                                    ],
                                  ),
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          left: 40.0, right: 40.0),
                                      child: GestureDetector(
                                        onTap: () async {
                                          ref
                                              .read(
                                                  deleteaccountUseCaseprovider)
                                              .execute(DeleteAccountUseCaseInput(
                                                  token: user.get("apitoken")))
                                              .then((value) => value.fold(
                                                  (l) => ScaffoldMessenger.of(
                                                          context)
                                                      .showSnackBar(SnackBar(
                                                          content: const Text(
                                                                  "contact")
                                                              .tr())),
                                                  (r) => context.router
                                                      .replaceAll([MyApp()])));
                                        },
                                        child: Container(
                                          color: Colors.blue[600],
                                          width: 10,
                                          height: 60,
                                          child: Center(
                                              child: const Text(
                                            "globalsyes",
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold),
                                          ).tr()),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 20,
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          left: 40.0, right: 40.0),
                                      child: GestureDetector(
                                        onTap: () async {
                                          context.router.pop();
                                        },
                                        child: Container(
                                          color: Colors.blue[600],
                                          width: 10,
                                          height: 60,
                                          child: Center(
                                              child: const Text(
                                            "globalsno",
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold),
                                          ).tr()),
                                        ),
                                      ),
                                    )
                                  ]);
                            },
                          );
                        },
                        icon: FontAwesomeIcons.xmark,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ProfileContainer extends HookWidget {
  final String? title;
  final String? subtitle;
  final VoidCallback? ontap;
  final IconData? icon;
  const ProfileContainer(
      {super.key, this.icon, this.title, this.subtitle, this.ontap});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80,
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            spreadRadius: 5,
            blurRadius: 25,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: ListTile(
        onTap: ontap,
        leading: Padding(
          padding: const EdgeInsets.only(top: 10.0, bottom: 12.0),
          child: Icon(
            icon,
            size: 30,
          ),
        ),
        title: Text(
          title!,
          style:
              const TextStyle(color: Colors.grey, fontWeight: FontWeight.bold),
        ),
        subtitle: Text(
          subtitle ?? "",
          style:
              const TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
