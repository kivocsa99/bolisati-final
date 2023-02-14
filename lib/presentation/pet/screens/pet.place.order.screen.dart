import 'dart:io';

import 'package:another_stepper/another_stepper.dart';
import 'package:auto_route/auto_route.dart';
import 'package:bolisati/application/pet/use_cases/attachfile/attach.file.use.case.dart';
import 'package:bolisati/application/pet/use_cases/attachfile/attach.file.use.case.input.dart';
import 'package:bolisati/application/pet/use_cases/placeorder/place.order.use.case.dart';
import 'package:bolisati/application/pet/use_cases/placeorder/place.order.use.case.input.dart';
import 'package:bolisati/application/provider/pet.repository.provider.dart';
import 'package:bolisati/constants.dart';
import 'package:bolisati/domain/api/orders/petorders/petordermodel.dart';
import 'package:bolisati/domain/api/pet/model/petoffermodel.dart';
import 'package:bolisati/domain/api/pet/model/petorderdonemodel.dart';
import 'package:bolisati/presentation/pet/widgets/petbottomsheet.dart';
import 'package:bolisati/presentation/pet/widgets/petinformationcontainer.dart';
import 'package:bolisati/presentation/pet/widgets/petordercontainer.dart';
import 'package:bolisati/presentation/pet/widgets/petuploadpictures.dart';
import 'package:bolisati/presentation/widgets/back_insuarance_container.dart';
import 'package:bolisati/router/app_route.gr.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:image_picker/image_picker.dart';

import '../../../application/provider/user.repository.provider.dart';
import '../../../domain/api/orders/travelorders/city/citymodel.dart';
import '../../../domain/api/pet/model/petcountrymodel.dart';

class PetPlaceOrderScreen extends HookConsumerWidget {
  const PetPlaceOrderScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final order = useState(const PetOrderModel());
    final carformkey = useState(GlobalKey<FormState>());
    final index = useState(0);
    final offers = useState<List<PetOffersModel>>([]);
    final Box setting = Hive.box("setting");
    final Box pet = Hive.box("pet");
    final nameController = useTextEditingController();
    final yearController = useTextEditingController();
    final startController = useTextEditingController();
    final endController = useTextEditingController();
    final countrycontroller = useTextEditingController();
    final filteredcontroller = useTextEditingController();

    final pettypecontroller = useTextEditingController();
    final petcountrycontroller = useTextEditingController();
    final gendercontroller = useTextEditingController();
    final filtered = useState<List<PetCountryModel>>([]);

    final isloading = useState(false);
    final genderscrollcontroller = FixedExtentScrollController(initialItem: 0);
    final typescrollcontroller = FixedExtentScrollController(initialItem: 0);
    final _images = useState<List<String>>([]);
    final imageCount = useState(0);
    final scrollcontroller = FixedExtentScrollController(initialItem: 0);
    final selecteddate = useState("");

    List<Widget> cases = [
      PetInformationContainer(
        petcountry: () async {
          isloading.value = true;

          final country = await ref
              .read(getcountryProvider(setting.get("apitoken")).future);

          country.fold((l) {
            isloading.value = false;

            ScaffoldMessenger.of(context)
                .showSnackBar(SnackBar(content: Text("contact".tr())));
          }, (r) async {
            isloading.value = true;
            final country = await ref
                .read(getcountryProvider(setting.get("apitoken")).future);

            country.fold(
                (l) => ScaffoldMessenger.of(context)
                    .showSnackBar(SnackBar(content: Text("contact".tr()))),
                (r) async {
              isloading.value = false;

              List<PetCountryModel> cars = r;

              FocusScope.of(context).unfocus();
              await showCupertinoModalPopup(
                context: context,
                builder: (_) {
                  return StatefulBuilder(builder: (_, setstate) {
                    return Material(
                      child: Container(
                        height: MediaQuery.of(context).size.height / 2,
                        color: const Color.fromARGB(255, 255, 255, 255),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            CustomField(
                              controller: filteredcontroller,
                              type: TextInputType.text,
                              readonly: false,
                              onchanged: (value) {
                                setstate(
                                  () {
                                    filtered.value = cars
                                        .where((element) => element.name!
                                            .toLowerCase()
                                            .startsWith(value!.toLowerCase()))
                                        .toList();
                                  },
                                );
                              },
                              label: "search".tr(),
                              width: double.infinity,
                            ),
                            SizedBox(
                              height: 200,
                              width: double.infinity,
                              child: CupertinoPicker(
                                scrollController: scrollcontroller,
                                looping: false,
                                itemExtent: 46,
                                onSelectedItemChanged: (value) {
                                  filtered.value.isEmpty
                                      ? pet.put("country", cars[value].id)
                                      : pet.put(
                                          "country", filtered.value[value].id);
                                  filtered.value.isEmpty
                                      ? countrycontroller.text =
                                          cars[value].name!
                                      : countrycontroller.text =
                                          filtered.value[value].name!;
                                },
                                children: filtered.value.isNotEmpty
                                    ? List<Widget>.generate(
                                        filtered.value.length, (int index) {
                                        return Center(
                                          child: Text(
                                            filtered.value[index].name!,
                                            style: const TextStyle(
                                                fontSize: 17,
                                                color: CupertinoColors.black),
                                          ),
                                        );
                                      })
                                    : List<Widget>.generate(cars.length,
                                        (int index) {
                                        return Center(
                                          child: Text(
                                            cars[index].name!,
                                            style: const TextStyle(
                                                fontSize: 17,
                                                color: CupertinoColors.black),
                                          ),
                                        );
                                      }),
                              ),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            // Close the modal
                            Align(
                              alignment: Alignment.bottomCenter,
                              child: SizedBox(
                                height: 70,
                                child: CupertinoButton(
                                  child: const Text(
                                    'confirm',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20),
                                  ).tr(),
                                  onPressed: () async {
                                    filteredcontroller.clear();
                                    if (scrollcontroller.selectedItem == 0) {
                                      Future.delayed(
                                          const Duration(milliseconds: 500),
                                          () {
                                        filtered.value.isEmpty
                                            ? pet.put("country", cars[0].id)
                                            : pet.put("country",
                                                filtered.value[0].id);
                                        filtered.value.isEmpty
                                            ? countrycontroller.text =
                                                cars[0].name!
                                            : countrycontroller.text =
                                                filtered.value[0].name!;
                                      });
                                    }

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
              );
            });
          });
        },
        ontap: () async {
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
                              initialDateTime:
                                  DateTime.now().add(const Duration(hours: 1)),
                              minimumDate: DateTime.now(),
                              maximumDate:
                                  DateTime.now().add(const Duration(days: 356)),
                              onDateTimeChanged: (val) {
                                selecteddate.value =
                                    DateFormat("d/M/y").format(val);

                                pet.put(
                                    "startdate",
                                    DateFormat("yyyy-MM-dd HH:mm:ss")
                                        .format(val)
                                        .toString());
                                pet.put(
                                    "enddate",
                                    DateFormat("yyyy-MM-dd HH:mm:ss").format(
                                        val.add(const Duration(days: 365))));
                                startController.text =
                                    selecteddate.value.toString();
                                endController.text = DateFormat("d/M/y")
                                    .format(val.add(const Duration(days: 365)));
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
                                if (selecteddate.value == "") {
                                  pet.put(
                                      "startdate",
                                      DateFormat("yyyy-MM-dd HH:mm:ss")
                                          .format(DateTime.now())
                                          .toString());
                                  pet.put(
                                      "enddate",
                                      DateFormat("yyyy-MM-dd HH:mm:ss").format(
                                          DateTime.now()
                                              .add(const Duration(days: 365))));
                                  startController.text = DateFormat("d/M/y")
                                      .format(DateTime.now());
                                  endController.text = DateFormat("d/M/y")
                                      .format(DateTime.now()
                                          .add(const Duration(days: 365)));
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
        gender: () async {
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
                            scrollController: genderscrollcontroller,
                            looping: false,
                            itemExtent: 46,
                            onSelectedItemChanged: (value) {
                              order.value = order.value
                                  .copyWith(gender_id: value == 0 ? 1 : 2);
                              gendercontroller.text = value == 0
                                  ? "globalsmale".tr()
                                  : "globalsfemale".tr();
                            },
                            children: [
                              const Text("globalsmale").tr(),
                              const Text("globalsfemale").tr(),
                            ],
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
                                if (genderscrollcontroller.selectedItem == 0) {
                                  order.value =
                                      order.value.copyWith(gender_id: 1);
                                  gendercontroller.text = "globalsmale".tr();
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
        pettype: () async {
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
                            scrollController: typescrollcontroller,
                            looping: false,
                            itemExtent: 46,
                            onSelectedItemChanged: (value) {
                              order.value = order.value.copyWith(
                                  pet_type_id: value == 0
                                      ? 1
                                      : value == 1
                                          ? 2
                                          : 3);
                              pettypecontroller.text = value == 0
                                  ? "pettypecat".tr()
                                  : value == 1
                                      ? "pettypedog".tr()
                                      : "pettypeother".tr();
                            },
                            children: [
                              const Text("pettypecat").tr(),
                              const Text("pettypedog").tr(),
                              const Text("pettypeother").tr(),
                            ],
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
                                if (typescrollcontroller.selectedItem == 0) {
                                  order.value =
                                      order.value.copyWith(pet_type_id: 1);
                                  pettypecontroller.text = "pettypecat".tr();
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
        startdatecontroller: startController,
        enddatecontroller: endController,
        yearcontroller: yearController,
        namecontroller: nameController,
        petcountrycontroller: countrycontroller,
        gendercontroller: gendercontroller,
        pettypecontroller: pettypecontroller,
        name: (value) {
          order.value = order.value.copyWith(name: value);
        },
        formkey: carformkey.value,
        key: const Key("1"),
      ),
      PetOrderContainer(
        offers: offers.value,
        key: const Key("2"),
      ),
      PetPicturesContainer(
        delete0: (value) {
          imageCount.value = imageCount.value - 1;
          _images.value.removeAt(value!);
        },
        images: _images.value,
        function0: () async {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: const Text("imageselect").tr(),
                content: const Text("imageselectdes").tr(),
                actions: <Widget>[
                  ButtonBar(
                      alignment: MainAxisAlignment.spaceEvenly,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        IconButton(
                          icon: const Icon(FontAwesomeIcons.image),
                          onPressed: () async {
                            if (imageCount.value < 2) {
                              final pickedFile = await ImagePicker()
                                  .pickImage(source: ImageSource.gallery);
                              if (pickedFile != null) {
                                imageCount.value++;
                                _images.value.add(pickedFile.path);
                              }
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: const Text("picdes").tr()));
                            }
                            if (context.mounted) context.router.pop();
                          },
                        ),
                        IconButton(
                          icon: const Icon(FontAwesomeIcons.camera),
                          onPressed: () async {
                            if (imageCount.value < 2) {
                              final pickedFile = await ImagePicker()
                                  .pickImage(source: ImageSource.camera);
                              if (pickedFile != null) {
                                imageCount.value++;
                                _images.value.add(pickedFile.path);
                              }
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: const Text("picdes").tr()));
                            }
                            if (context.mounted) context.router.pop();
                          },
                        ),
                      ]),
                ],
              );
            },
          );
        },
        key: const Key("4"),
      ),
    ];
    return Stack(
      children: [
        SafeArea(
            child: Padding(
                padding: EdgeInsets.only(
                    bottom: MediaQuery.of(context).viewInsets.bottom),
                child: Scaffold(
                  resizeToAvoidBottomInset: false,
                  backgroundColor: const Color(0xFFF5F5F7),
                  body: KeyboardVisibilityBuilder(
                    builder: (p0, isKeyboardVisible) {
                      return Padding(
                        padding:
                            const EdgeInsets.only(left: 20, right: 20, top: 40),
                        child: SingleChildScrollView(
                          physics: !isKeyboardVisible
                              ? const NeverScrollableScrollPhysics()
                              : const BouncingScrollPhysics(),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              BackInsuranceContainer(
                                name: "pet".tr(),
                                description: "petdes".tr(),
                                icon: 'assets/pet.svg',
                                function: () => context.router.pop(),
                                containercolor: carcontainer,
                              ),
                              const SizedBox(
                                height: 50,
                              ),
                              Container(
                                color: Colors.white,
                                width: double.infinity,
                                height:
                                    MediaQuery.of(context).size.height - 200,
                                child: SingleChildScrollView(
                                    child: Column(
                                  children: [
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: AnotherStepper(
                                        scrollPhysics:
                                            const BouncingScrollPhysics(),
                                        activeIndex: index.value,
                                        stepperList: petstepperData,
                                        stepperDirection: Axis.horizontal,
                                        inverted: false,
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 20,
                                    ),
                                    AnimatedSwitcher(
                                      duration:
                                          const Duration(milliseconds: 500),
                                      child: cases[index.value],
                                    ),
                                    const SizedBox(
                                      height: 20,
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        GestureDetector(
                                          onTap: () async {
                                            if (index.value == 1) {
                                              await pet.delete("petid");
                                              index.value = index.value - 1;
                                            } else if (index.value != 0) {
                                              index.value = index.value - 1;
                                            }
                                          },
                                          child: Container(
                                            color: index.value == 0
                                                ? Colors.grey
                                                : Colors.blue[600],
                                            width: 175,
                                            height: 60,
                                            child: Center(
                                                child: Text(
                                              "back".tr(),
                                              style: const TextStyle(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.bold),
                                            )),
                                          ),
                                        ),
                                        ValueListenableBuilder(
                                          valueListenable: setting.listenable(),
                                          builder: (context, Box box, child) {
                                            final token = box.get("apitoken");

                                            return GestureDetector(
                                              onTap: () async {
                                                if (index.value == 0) {
                                                  if (carformkey
                                                      .value.currentState!
                                                      .validate()) {
                                                    isloading.value = true;
                                                    await ref
                                                        .read(getoffersProvider(
                                                                token)
                                                            .future)
                                                        .then((value) =>
                                                            value.fold((l) {
                                                              isloading.value =
                                                                  false;

                                                              ScaffoldMessenger
                                                                      .of(
                                                                          context)
                                                                  .showSnackBar(
                                                                      SnackBar(
                                                                          content:
                                                                              const Text("contact").tr()));
                                                            }, (r) {
                                                              isloading.value =
                                                                  false;
                                                              offers.value = r;
                                                              final isLaseIndex =
                                                                  index.value ==
                                                                      cases.length -
                                                                          1;
                                                              index.value =
                                                                  isLaseIndex
                                                                      ? 0
                                                                      : index.value +
                                                                          1;
                                                            }));
                                                  }
                                                } else if (index.value == 1) {
                                                  if (pet.get("petid") !=
                                                      null) {
                                                    final isLaseIndex =
                                                        index.value ==
                                                            cases.length - 1;
                                                    index.value = isLaseIndex
                                                        ? 0
                                                        : index.value + 1;
                                                  } else {
                                                    ScaffoldMessenger.of(
                                                            context)
                                                        .showSnackBar(SnackBar(
                                                            content: Text(
                                                                "offersdes"
                                                                    .tr())));
                                                  }
                                                } else if (index.value == 2) {
                                                  if (_images
                                                      .value.isNotEmpty) {
                                                    await Future.delayed(
                                                        const Duration(
                                                            seconds: 1), (() {
                                                      order.value = order.value
                                                          .copyWith(
                                                              pet_insurance_id:
                                                                  pet.get(
                                                                      "petid"));
                                                      order.value = order.value
                                                          .copyWith(
                                                              birthdate: pet.get(
                                                                  "birthdate"));
                                                      order.value = order.value
                                                          .copyWith(
                                                              start_date: pet.get(
                                                                  "startdate"));
                                                      order.value = order.value
                                                          .copyWith(
                                                              end_date: pet.get(
                                                                  "enddate"));
                                                      order.value = order.value
                                                          .copyWith(
                                                              country_id: pet.get(
                                                                  "country"));
                                                    }));

                                                    final PetOffersModel
                                                        offersModel =
                                                        offers.value.firstWhere(
                                                            (element) =>
                                                                element.id ==
                                                                pet.get(
                                                                    "petid"));

                                                    if (context.mounted) {
                                                      showModalBottomSheet(
                                                        isScrollControlled:
                                                            true,
                                                        isDismissible: true,
                                                        context: context,
                                                        builder: (ctx) {
                                                          return PetBottomSheet(
                                                            function: () async {
                                                              isloading.value =
                                                                  true;
                                                              await context
                                                                  .router
                                                                  .pop();

                                                              ref
                                                                  .read(
                                                                      petplaceOrderProvider)
                                                                  .execute(PetPlaceOrderUseCaseInput(
                                                                      model: order
                                                                          .value,
                                                                      token:
                                                                          token,
                                                                      addons:
                                                                          pet.get("addon") ??
                                                                              ""))
                                                                  .then((value) =>
                                                                      value.fold(
                                                                          (l) {
                                                                        isloading.value =
                                                                            false;
                                                                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                                                            content:
                                                                                const Text("contact").tr()));
                                                                      }, (r) async {
                                                                        PetOrderDoneModel
                                                                            orderdone =
                                                                            r;
                                                                        for (var element
                                                                            in _images.value) {
                                                                          ref.read(petattachfileProvider).execute(PetAttachFileUseCaseInput(token: token, orderid: orderdone.id, file: File(element))).then((value) =>
                                                                              value.fold((l) => ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: const Text("contact").tr())), (r) async {
                                                                                if (element == _images.value.last) {
                                                                                  isloading.value = false;
                                                                                  if (context.mounted) {
                                                                                    showDialog(
                                                                                      barrierDismissible: false,
                                                                                      context: context,
                                                                                      builder: (context) {
                                                                                        return SimpleDialog(
                                                                                            title: Row(
                                                                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                                                                                                padding: const EdgeInsets.only(left: 40.0, right: 40.0),
                                                                                                child: const Text("orderconfirm").tr(),
                                                                                              ),
                                                                                              Padding(
                                                                                                padding: const EdgeInsets.only(left: 40.0, right: 40.0),
                                                                                                child: GestureDetector(
                                                                                                  onTap: () async {
                                                                                                    await context.router.replaceAll([HomeScreen()]).then((value) async => await ref.refresh(GetorderProvider(token).future));
                                                                                                  },
                                                                                                  child: Container(
                                                                                                    color: Colors.blue[600],
                                                                                                    width: 100,
                                                                                                    height: 60,
                                                                                                    child: Center(
                                                                                                        child: const Text(
                                                                                                      "confirm",
                                                                                                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                                                                                                    ).tr()),
                                                                                                  ),
                                                                                                ),
                                                                                              )
                                                                                            ]);
                                                                                      },
                                                                                    );
                                                                                  }
                                                                                }
                                                                              }));
                                                                        }
                                                                      }));
                                                            },
                                                            offerModel:
                                                                offersModel,
                                                          );
                                                        },
                                                      );
                                                    }
                                                  }
                                                } else {
                                                  ScaffoldMessenger.of(context)
                                                      .showSnackBar(SnackBar(
                                                          content: Text(
                                                              "picupload"
                                                                  .tr())));
                                                }
                                              },
                                              child: Container(
                                                color: Colors.blue[600],
                                                width: 175,
                                                height: 60,
                                                child: Center(
                                                    child: Text(
                                                  index.value != 3
                                                      ? "next"
                                                      : "confirm",
                                                  style: const TextStyle(
                                                      color: Colors.white,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ).tr()),
                                              ),
                                            );
                                          },
                                        ),
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 50,
                                    )
                                  ],
                                )),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ))),
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
