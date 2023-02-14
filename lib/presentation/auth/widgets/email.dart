import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class EmailField extends HookWidget {
  final TextEditingController? controller;
  final ValueChanged<String?>? onchanged;
  final GlobalKey<FormState>? formkey;
  final String? Function(String?)? validator;
  final bool? forget;
  const EmailField(
      {super.key,
      this.controller,
      this.onchanged,
      this.forget,
      this.formkey,
      this.validator});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Form(
        key: formkey,
        child: Padding(
          padding:
              const EdgeInsets.only(left: 50.0, right: 50, bottom: 0, top: 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                forget != true ? "startemail" : "emailenter",
                style: const TextStyle(fontSize: 36),
              ).tr(),
              const SizedBox(
                height: 5,
              ),
              forget != true
                  ? Row(
                      children: [
                        const Text(
                          "startemaildes",
                          style: TextStyle(fontSize: 14),
                        ).tr(),
                        const SizedBox(
                          width: 5,
                        ),
                      ],
                    )
                  : const SizedBox.shrink(),
              const SizedBox(
                height: 30,
              ),
              SizedBox(
                height: 100,
                width: double.infinity,
                child: TextFormField(
                  onChanged: onchanged,
                  validator: validator,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    focusedErrorBorder: const UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.red)),
                    errorBorder: const UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.red)),
                    contentPadding: const EdgeInsets.only(
                        left: 10, top: 10, bottom: 10, right: 10),
                    hintText: "email".tr(),
                    hintStyle: const TextStyle(
                      color: Colors.black26,
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  keyboardType: TextInputType.emailAddress,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
