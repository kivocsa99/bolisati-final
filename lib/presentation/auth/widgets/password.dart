import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class PasswordField extends HookWidget {
  final TextEditingController? controller;
  final ValueChanged<String?>? onchanged;
  final GlobalKey<FormState>? formkey;
  final IconData? prefixIcon;
  final bool? obscureText;
  final bool? signup;
  final bool? button;
  final String? Function(String?)? validator;

  const PasswordField(
      {super.key,
      this.prefixIcon,
      this.obscureText,
      this.signup,
      this.controller,
      this.button,
      this.onchanged,
      this.formkey,
      this.validator});

  @override
  Widget build(BuildContext context) {
    final Box setting = Hive.box("setting");
    final hidden = useState(obscureText);
    final buttonon = useState(button);
    return Container(
      color: Colors.white,
      child: Form(
        key: formkey,
        child: Padding(
          padding:
              const EdgeInsets.only(left: 40.0, right: 40.0, bottom: 0, top: 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "password".tr(),
                style: const TextStyle(fontSize: 36),
              ),
              const SizedBox(
                height: 5,
              ),
              const SizedBox(height: 10),
              const SizedBox(
                height: 20,
              ),
              SizedBox(
                height: 100,
                width: double.infinity,
                child: TextFormField(
                  obscureText: hidden.value!,
                  validator: validator,
                  onChanged: onchanged,
                  controller: controller,
                  textAlign: TextAlign.start,
                  decoration: InputDecoration(
                    suffixIcon: obscureText!
                        ? IconButton(
                            onPressed: () => hidden.value = !hidden.value!,
                            icon: Icon(hidden.value!
                                ? Icons.visibility_off
                                : Icons.visibility),
                          )
                        : const SizedBox.shrink(),
                    border: InputBorder.none,
                    focusedErrorBorder: const UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.red)),
                    errorBorder: const UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.red)),
                    contentPadding: const EdgeInsets.only(
                        left: 10, top: 10, bottom: 10, right: 10),
                    hintText: "password".tr(),
                    hintStyle: const TextStyle(
                      color: Colors.black26,
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  keyboardType: TextInputType.text,
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              signup == true
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            const Text(
                              "agree",
                              style: TextStyle(fontSize: 13),
                            ).tr(),
                            GestureDetector(
                              child: const Text(
                                "privacy",
                                style:
                                    TextStyle(fontSize: 13, color: Colors.blue),
                              ).tr(),
                              onTap: () async {
                                if (await canLaunchUrl(Uri.parse(
                                    "https://bolisati.com/privacypolicy.html"))) {
                                  await launchUrl(
                                      Uri.parse(
                                          "https://bolisati.com/privacypolicy.html"),
                                      mode: LaunchMode.inAppWebView);
                                } else {
                                  throw Exception('Could not launch ');
                                }
                              },
                            ),
                            const Text(
                              "and",
                              style: TextStyle(fontSize: 13),
                            ).tr(),
                            GestureDetector(
                              child: const Text(
                                "terms",
                                style:
                                    TextStyle(fontSize: 13, color: Colors.blue),
                              ).tr(),
                              onTap: () async {
                                if (await canLaunchUrl(Uri.parse(
                                    "https://bolisati.com/terms.html"))) {
                                  await launchUrl(
                                      Uri.parse(
                                          "https://bolisati.com/terms.html"),
                                      mode: LaunchMode.inAppWebView);
                                } else {
                                  throw Exception('Could not launch ');
                                }
                              },
                            )
                          ],
                        ),
                        CupertinoSwitch(
                            value: buttonon.value!,
                            onChanged: (v) {
                              print(v);
                              setting.put("privacy", v);
                              buttonon.value = v;
                            }),
                      ],
                    )
                  : const SizedBox.shrink(),
              const SizedBox(
                height: 40,
              )
            ],
          ),
        ),
      ),
    );
  }
}
