import 'package:auto_route/auto_route.dart';
import 'package:bolisati/application/provider/travel.repository.provider.dart';
import 'package:bolisati/domain/api/orders/travelorders/region/regionmodel.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class TravelInformationContainer extends HookWidget {
  final ValueChanged<String?>? name;
  final TextEditingController? namecontroller;
  final TextEditingController? yearcontroller;
  final TextEditingController? startdatecontroller;
  final TextEditingController? enddatecontroller;
  final TextEditingController? regioncontroller;
  final TextEditingController? valuecontroller;
  final TextEditingController? periodcontroller;
  final TextEditingController? countrycontroller;
  final TextEditingController? destinationcontroller;

  final VoidCallback? country;
  final ValueChanged<String?>? period;
  final ValueChanged<String?>? genderid;
  final ValueChanged<DateTime?>? startchanged;
  final ValueChanged<DateTime?>? endchanged;
  final ValueChanged<String?>? destination;

  final VoidCallback? travelyearfunction;
  final GlobalKey<FormState>? formkey;
  const TravelInformationContainer(
      {super.key,
      this.periodcontroller,
      this.country,
      this.startchanged,
      this.travelyearfunction,
      this.formkey,
      this.endchanged,
      this.name,
      this.destination,
      this.destinationcontroller,
      this.yearcontroller,
      this.regioncontroller,
      this.countrycontroller,
      this.valuecontroller,
      this.enddatecontroller,
      this.startdatecontroller,
      this.namecontroller,
      this.period,
      this.genderid});

  @override
  Widget build(BuildContext context) {
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
              Regions(
                regioncontroller: regioncontroller,
                width: double.infinity,
              ),
              PetCountry(
                ontap: country,
                controller: countrycontroller,
                width: double.infinity,
              ),
              CustomField(
                controller: destinationcontroller,
                type: TextInputType.text,
                readonly: false,
                validator: RequiredValidator(errorText: "reqfield".tr()),
                onchanged: destination,
                label: "des".tr(),
                width: double.infinity,
              ),
              YearPicker(
                controller: yearcontroller,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Align(
                  alignment: context.locale.languageCode == "ar"
                      ? Alignment.centerRight
                      : Alignment.centerLeft,
                  child: const Text(
                    "insuranceperiod",
                    style: TextStyle(fontSize: 20),
                  ).tr(),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  StartEndDate(
                    onchanged: startchanged,
                    startcontroller: startdatecontroller,
                    label: "startdate".tr(),
                    width: 150,
                  ),
                  EndDate(
                    onchanged: endchanged,
                    endcontroller: enddatecontroller,
                    label: "enddate".tr(),
                    width: 150,
                  ),
                ],
              ),
              CustomField(
                controller: periodcontroller,
                type: TextInputType.number,
                readonly: true,
                validator: RequiredValidator(errorText: "reqfield".tr()),
                label: "period".tr(),
                width: double.infinity,
              )
            ],
          )),
    );
  }
}

class PetCountry extends HookConsumerWidget {
  final double? width;
  final VoidCallback? ontap;
  final TextEditingController? controller;

  const PetCountry({
    super.key,
    this.ontap,
    this.width,
    this.controller,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final travel = Hive.box("travel");

    final Box setting = Hive.box("setting");

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
          child: ValueListenableBuilder(
            valueListenable: setting.listenable(),
            builder: (context, Box box, child) {
              final apitoken = box.get("apitoken");
              return TextFormField(
                readOnly: true,
                validator: RequiredValidator(errorText: "reqfield".tr()),
                onTap: ontap,
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
                  labelText: "country".tr(),
                  hintStyle: const TextStyle(
                    color: Colors.black26,
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                controller: controller,
              );
            },
          ),
        ));
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
  const CustomField(
      {super.key,
      this.width,
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
    final Box travel = Hive.box("travel");

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
                                    travel.put("birthdate", selectedYear.value);
                                    travel.put("age", result);
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
                                      travel.put(
                                          "birthdate", selectedYear.value);
                                      travel.put("age", result);
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
            }
            // async {
            //   FocusScope.of(context).unfocus();
            //   final pickedYear = await showDatePicker(
            //     context: context,
            //     initialDate: DateTime.now(),
            //     firstDate: DateTime(1900),
            //     lastDate: DateTime.now().add(const Duration(days: 356)),
            //     builder: (context, child) {
            //       return Theme(
            //         data: ThemeData.light().copyWith(
            //           colorScheme:
            //               const ColorScheme.light(primary: Colors.blue),
            //           buttonTheme: const ButtonThemeData(
            //             textTheme: ButtonTextTheme.primary,
            //           ),
            //         ),
            //         child: child!,
            //       );
            //     },
            //   );
            //   if (pickedYear != null) {
            // String picked = DateFormat.y().format(pickedYear);
            // String now = DateFormat.y().format(DateTime.now());
            // int result = int.parse(now) - int.parse(picked);
            // selectedYear.value =
            //     DateFormat("yyyy-MM-dd").format(pickedYear);
            // travel.put("birthdate", selectedYear.value);
            // travel.put("age", result);
            // controller!.text = selectedYear.value.toString();
            //   }
            // }
            ,
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

class StartEndDate extends HookWidget {
  final double? width;
  final String? label;
  final ValueChanged<DateTime?>? onchanged;
  final TextEditingController? startcontroller;

  const StartEndDate({
    super.key,
    this.onchanged,
    this.width,
    this.startcontroller,
    this.label,
  });

  @override
  Widget build(BuildContext context) {
    final Box travel = Hive.box("travel");

    final selecteddate = useState("");
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
            readOnly: true,
            validator: RequiredValidator(errorText: "reqfield".tr()),
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
                                  initialDateTime: DateTime.now()
                                      .add(const Duration(hours: 1)),
                                  minimumDate: DateTime.now(),
                                  maximumDate: DateTime.now()
                                      .add(const Duration(days: 356)),
                                  onDateTimeChanged: onchanged!),
                            ),

                            // Close the modal
                            Align(
                              alignment: Alignment.bottomCenter,
                              child: SizedBox(
                                height: 70,
                                child: CupertinoButton(
                                  child: const Text('confirm').tr(),
                                  onPressed: () async {
                                    if (startcontroller!.text == "") {
                                      selecteddate.value = DateFormat("d/M/y")
                                          .format(DateTime.now());
                                      travel.put("start", DateTime.now());
                                      travel.put(
                                          "startdate",
                                          DateFormat("yyyy-MM-dd HH:mm:ss")
                                              .format(DateTime.now()));

                                      startcontroller!.text =
                                          selecteddate.value.toString();
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
              labelText: label,
              hintStyle: const TextStyle(
                color: Colors.black26,
                fontSize: 18,
                fontWeight: FontWeight.w800,
              ),
            ),
            controller: startcontroller,
          ),
        ));
  }
}

class EndDate extends HookWidget {
  final double? width;
  final String? label;
  final TextEditingController? endcontroller;
  final ValueChanged<DateTime?>? onchanged;

  const EndDate(
      {super.key, this.onchanged, this.width, this.label, this.endcontroller});

  @override
  Widget build(BuildContext context) {
    final Box travel = Hive.box("travel");

    final selecteddate = useState("");
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
            readOnly: true,
            validator: RequiredValidator(errorText: "reqfield".tr()),
            onTap: () async {
              FocusScope.of(context).unfocus();
              await showCupertinoModalPopup(
                  context: context,
                  builder: (_) {
                    DateTime endd = travel.get("start") ?? DateTime.now();
                    return Container(
                      height: 250,
                      color: const Color.fromARGB(255, 255, 255, 255),
                      child: Column(
                        children: [
                          SizedBox(
                            height: 180,
                            child: CupertinoDatePicker(
                                dateOrder: DatePickerDateOrder.dmy,
                                mode: CupertinoDatePickerMode.date,
                                initialDateTime: endd,
                                minimumDate: endd,
                                maximumDate: DateTime.now()
                                    .add(const Duration(days: 356)),
                                onDateTimeChanged: onchanged!),
                          ),
                          Align(
                            alignment: Alignment.bottomCenter,
                            child: SizedBox(
                              height: 70,
                              child: CupertinoButton(
                                child: const Text('confirm').tr(),
                                onPressed: () async {
                                  if (endcontroller!.text == "") {
                                    selecteddate.value = DateFormat("d/M/y")
                                        .format(DateTime.now());
                                    travel.put("end", DateTime.now());
                                    travel.put(
                                        "enddate",
                                        DateFormat("yyyy-MM-dd HH:mm:ss")
                                            .format(DateTime.now()));
                                    endcontroller!.text =
                                        selecteddate.value.toString();
                                  }
                                  context.router.pop();
                                },
                              ),
                            ),
                          )
                        ],
                      ),
                    );
                  });
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
              labelText: label,
              hintStyle: const TextStyle(
                color: Colors.black26,
                fontSize: 18,
                fontWeight: FontWeight.w800,
              ),
            ),
            controller: endcontroller,
          ),
        ));
  }
}

class Regions extends HookConsumerWidget {
  final double? width;

  final TextEditingController? regioncontroller;

  const Regions({
    super.key,
    this.width,
    this.regioncontroller,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final travel = Hive.box("travel");
    final scrollcontroller = FixedExtentScrollController(initialItem: 0);
    final Box setting = Hive.box("setting");

    return Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            Container(
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
              child: ValueListenableBuilder(
                valueListenable: setting.listenable(),
                builder: (context, Box box, child) {
                  final apitoken = box.get("apitoken");

                  return TextFormField(
                    readOnly: true,
                    validator: RequiredValidator(errorText: "reqfield".tr()),
                    onTap: () async {
                      final value =
                          await ref.read(getreregionsProvider(apitoken).future);
                      value.fold(
                          (l) => ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text("contact".tr()))),
                          (r) async {
                        List<RegionModel> regions = r;

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
                                  child: CupertinoPicker(
                                    scrollController: scrollcontroller,
                                    looping: false,
                                    itemExtent: 46,
                                    onSelectedItemChanged: (value) {
                                      travel.put("region", regions[value].id);
                                      regioncontroller!.text =
                                          context.locale.languageCode == "en"
                                              ? regions[value].name!
                                              : regions[value].name_ar!;
                                      print(travel.get("region"));
                                    },
                                    children: List<Widget>.generate(
                                        regions.length, (int index) {
                                      return Text(
                                        context.locale.languageCode == "en"
                                            ? regions[index].name!
                                            : regions[index].name_ar!,
                                        style: const TextStyle(
                                            color: CupertinoColors.black),
                                      );
                                    }),
                                  ),
                                ),

                                // Close the modal
                                Align(
                                  alignment: Alignment.bottomCenter,
                                  child: SizedBox(
                                    height: 70,
                                    child: CupertinoButton(
                                      child: const Text('confirm').tr(),
                                      onPressed: () async {
                                        if (scrollcontroller.selectedItem ==
                                            0) {
                                          travel.put("region", regions[0].id);
                                          regioncontroller!.text =
                                              context.locale.languageCode ==
                                                      "en"
                                                  ? regions[0].name!
                                                  : regions[0].name_ar!;
                                        }
                                        print(travel.get("region"));

                                        await context.router.pop();
                                      },
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        );
                      });
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
                      labelText: "region".tr(),
                      hintStyle: const TextStyle(
                        color: Colors.black26,
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    controller: regioncontroller,
                  );
                },
              ),
            ),
          ],
        ));
  }
}
