import 'package:auto_route/auto_route.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:hive_flutter/hive_flutter.dart';

class ReitirementInformationContainer extends HookWidget {
  final ValueChanged<String?>? name;
  final TextEditingController? namecontroller;
  final TextEditingController? yearcontroller;
  final TextEditingController? monthlycontroller;
  final TextEditingController? yearlycontroller;

  final TextEditingController? fullfee;
  final TextEditingController? retirementcontroller;
  final TextEditingController? insurancecontroller;

  final ValueChanged<String?>? monthly;
  final ValueChanged<String?>? yearly;

  final VoidCallback? retirement;
  final VoidCallback? insurance;

  final GlobalKey<FormState>? formkey;
  const ReitirementInformationContainer(
      {super.key,
      this.monthlycontroller,
      this.retirement,
      this.fullfee,
      this.insurance,
      this.retirementcontroller,
      this.insurancecontroller,
      this.formkey,
      this.name,
      this.yearcontroller,
      this.namecontroller,
      this.monthly,
      this.yearly,
      this.yearlycontroller});

  @override
  Widget build(BuildContext context) {
    final Box retirement1 = Hive.box("retirement");
    return SizedBox(
      child: Form(
          key: formkey,
          child: Column(
            children: [
              CustomField(
                controller: namecontroller,
                type: TextInputType.text,
                readonly: false,
                validator: RequiredValidator(errorText: "reqfield".tr()),
                onchanged: name,
                label: "insname".tr(),
                width: double.infinity,
              ),
              YearPicker(
                controller: yearcontroller,
              ),
              CustomField(
                controller: insurancecontroller,
                function: insurance,
                label: "inursancet".tr(),
                readonly: true,
                width: double.infinity,
              ),
              retirement1.get("type") == 1
                  ? CustomField(
                      formatter: [ThousandsSeparatorInputFormatter()],
                      controller: monthlycontroller,
                      type: TextInputType.number,
                      readonly: false,
                      validator: RequiredValidator(errorText: "reqfield".tr()),
                      onchanged: monthly,
                      label: "monthly".tr(),
                      width: double.infinity,
                    )
                  : const SizedBox.shrink(),
              retirement1.get("type") == 2
                  ? CustomField(
                      formatter: [ThousandsSeparatorInputFormatter()],
                      controller: fullfee,
                      type: TextInputType.number,
                      readonly: false,
                      validator: RequiredValidator(errorText: "reqfield".tr()),
                      onchanged: monthly,
                      label: "fullfee".tr(),
                      width: double.infinity,
                    )
                  : const SizedBox.shrink(),
              CustomField(
                controller: retirementcontroller,
                type: TextInputType.number,
                readonly: true,
                validator: RequiredValidator(errorText: "reqfield".tr()),
                function: retirement,
                label: "retirementage".tr(),
                width: double.infinity,
              ),
            ],
          )),
    );
  }
}

class CustomField extends StatelessWidget {
  final ValueChanged<String?>? onchanged;
  final String? Function(String?)? validator;
  final VoidCallback? function;
  final TextEditingController? controller;

  final String? label;
  final double? width;
  final bool? readonly;
  final String? initial;
  final TextInputType? type;
  final List<TextInputFormatter>? formatter;
  const CustomField(
      {super.key,
      this.width,
      this.formatter,
      this.type,
      this.function,
      this.readonly,
      this.controller,
      this.label,
      this.onchanged,
      this.initial,
      this.validator});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Container(
        decoration: const BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: Colors.grey,
              width: 2,
            ),
          ),
        ),
        height: 80,
        width: width,
        child: TextFormField(
          inputFormatters: formatter,
          controller: controller,
          onTap: function,
          initialValue: initial,
          readOnly: readonly!,
          onChanged: onchanged,
          validator: validator,
          decoration: InputDecoration(
            border: InputBorder.none,
            focusedErrorBorder: const UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.red)),
            errorBorder: const UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.red)),
            contentPadding:
                const EdgeInsets.only(left: 10, top: 10, bottom: 10, right: 10),
            filled: true,
            fillColor: Colors.blue[350],
            labelText: label,
            hintStyle: const TextStyle(
              color: Colors.black26,
              fontSize: 18,
              fontWeight: FontWeight.w800,
            ),
          ),
          keyboardType: type,
        ),
      ),
    );
  }
}

class YearPicker extends HookWidget {
  final double? width;
  final String? selectedyear;
  final TextEditingController? controller;
  const YearPicker({super.key, this.width, this.controller, this.selectedyear});

  @override
  Widget build(BuildContext context) {
    final Box retirement = Hive.box("retirement");

    final selectedYear = useState("");
    return Padding(
        padding: const EdgeInsets.all(10.0),
        child: Container(
          decoration: const BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: Colors.grey,
                width: 2,
              ),
            ),
          ),
          height: 80,
          width: width,
          child: TextFormField(
            validator: RequiredValidator(errorText: "reqfield".tr()),
            readOnly: true,
            onTap: () async {
              FocusScope.of(context).unfocus();
              await showCupertinoModalPopup(
                  context: context,
                  builder: (_) => Container(
                        height: 250,
                        color: const Color.fromARGB(255, 255, 255, 255),
                        child: Column(
                          children: [
                            SizedBox(
                              height: 180,
                              child: CupertinoDatePicker(
                                  dateOrder: DatePickerDateOrder.dmy,
                                  mode: CupertinoDatePickerMode.date,
                                  initialDateTime: DateTime.now(),
                                  minimumDate: DateTime(1900),
                                  maximumDate: DateTime.now(),
                                  onDateTimeChanged: (val) {
                                    String picked = DateFormat.y().format(val);
                                    String now =
                                        DateFormat.y().format(DateTime.now());
                                    int result =
                                        int.parse(now) - int.parse(picked);
                                    selectedYear.value =
                                        DateFormat("yyyy-MM-dd").format(val);
                                    retirement.put(
                                        "birthdate", selectedYear.value);
                                    retirement.put("age", result);
                                    controller!.text =
                                        selectedYear.value.toString();
                                  }),
                            ),
                            // Close the modal
                            Align(
                              alignment: Alignment.bottomCenter,
                              child: SizedBox(
                                height: 70,
                                child: CupertinoButton(
                                  child: const Text('confirm').tr(),
                                  onPressed: () async {
                                    if (controller!.text == "") {
                                      String picked =
                                          DateFormat.y().format(DateTime.now());
                                      String now =
                                          DateFormat.y().format(DateTime.now());
                                      int result =
                                          int.parse(now) - int.parse(picked);
                                      selectedYear.value =
                                          DateFormat("yyyy-MM-dd")
                                              .format(DateTime.now());
                                      retirement.put(
                                          "birthdate", selectedYear.value);
                                      retirement.put("age", result);
                                      controller!.text =
                                          selectedYear.value.toString();
                                    }
                                    context.router.pop();
                                  },
                                ),
                              ),
                            )
                          ],
                        ),
                      ));
            },
            decoration: InputDecoration(
              border: InputBorder.none,
              focusedErrorBorder: const UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.red)),
              errorBorder: const UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.red)),
              contentPadding: const EdgeInsets.only(
                  left: 10, top: 10, bottom: 10, right: 10),
              filled: true,
              fillColor: Colors.blue[350],
              labelText: "birthdate".tr(),
              hintStyle: const TextStyle(
                color: Colors.black26,
                fontSize: 18,
                fontWeight: FontWeight.w800,
              ),
            ),
            controller: controller,
          ),
        ));
  }
}

class Insurance extends HookWidget {
  final ValueChanged<String?>? onchanged;
  final String? Function(String?)? validator;
  final String? label;
  final double? width;
  const Insurance(
      {super.key, this.width, this.onchanged, this.label, this.validator});

  @override
  Widget build(BuildContext context) {
    final dropDownValue = useState("N/A");
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: SizedBox(
        height: 80,
        width: width,
        child: DropdownButtonFormField<String>(
          validator: RequiredValidator(errorText: ""),
          focusColor: Colors.grey,
          iconEnabledColor: Colors.grey,
          value: dropDownValue.value,
          onChanged: onchanged,
          items: ["N/A", "Monthly Fee", "Full Fee"]
              .map<DropdownMenuItem<String>>(
                  (String value) => DropdownMenuItem<String>(
                      value: value,
                      child: Text(
                        value,
                      )))
              .toList(),
        ),
      ),
    );
  }
}

class ThousandsSeparatorInputFormatter extends TextInputFormatter {
  static const separator = ','; // Change this to '.' for other locales

  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    // Short-circuit if the new value is empty
    if (newValue.text.isEmpty) {
      return newValue.copyWith(text: '');
    }

    // Handle "deletion" of separator character
    String oldValueText = oldValue.text.replaceAll(separator, '');
    String newValueText = newValue.text.replaceAll(separator, '');

    if (oldValue.text.endsWith(separator) &&
        oldValue.text.length == newValue.text.length + 1) {
      newValueText = newValueText.substring(0, newValueText.length - 1);
    }

    // Only process if the old value and new value are different
    if (oldValueText != newValueText) {
      int selectionIndex =
          newValue.text.length - newValue.selection.extentOffset;
      final chars = newValueText.split('');

      String newString = '';
      for (int i = chars.length - 1; i >= 0; i--) {
        if ((chars.length - 1 - i) % 3 == 0 && i != chars.length - 1) {
          newString = separator + newString;
        }
        newString = chars[i] + newString;
      }

      return TextEditingValue(
        text: newString.toString(),
        selection: TextSelection.collapsed(
          offset: newString.length - selectionIndex,
        ),
      );
    }

    // If the new value and old value are the same, just return as-is
    return newValue;
  }
}
