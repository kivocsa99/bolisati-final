import 'dart:io';

import 'package:another_stepper/widgets/another_stepper.dart';
import 'package:auto_route/auto_route.dart';

import 'package:bolisati/application/retirment/use_cases/attachfile/attach.file.use.case.dart';
import 'package:bolisati/application/retirment/use_cases/attachfile/attach.file.use.case.input.dart';
import 'package:bolisati/constants.dart';
import 'package:bolisati/domain/api/orders/retirementorders/retirementordermodel.dart';

import 'package:bolisati/domain/api/retirment/model/retirmentdonemodel.dart';
import 'package:bolisati/presentation/retirement/widgets/retirmentuploadpage.dart';
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
import '../../../application/retirment/use_cases/placeorder/place.order.use.case.dart';
import '../../../application/retirment/use_cases/placeorder/place.order.use.case.input.dart';
import '../../../router/app_route.gr.dart';
import '../../widgets/back_insuarance_container.dart';
import '../widgets/retirmentinformationcontainer.dart';

class RetirmentPlaceOrderScreen extends HookConsumerWidget {
  const RetirmentPlaceOrderScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final nameController = useTextEditingController();
    final yearcontroller = useTextEditingController();
    final retiremenrController = useTextEditingController();
    final insurancecontroller = useTextEditingController();

    final monthly = useTextEditingController();
    final fullfee = useTextEditingController();
    final controller = useTextEditingController();

    final order = useState(const RetirementOrderModel());
    final retirementkey = useState(GlobalKey<FormState>());
    final Box setting = Hive.box("setting");
    final Box retirement = Hive.box("retirement");
    final insurancescrollcontroller =
        FixedExtentScrollController(initialItem: 0);
    final scrollcontroller = FixedExtentScrollController(initialItem: 0);
    final imageCount = useState(0);
    final isloading = useState(false);
    final _images = useState<List<String>>([]);
    List<Widget> cases = [
      ReitirementInformationContainer(
        retirementcontroller: retiremenrController,
        retirement: () async {
          List<int> list = [];
          for (int i = 35; i <= 70; i++) {
            list.add(i);
          }
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
                              retirement.put("retage", list[value]);
                              retiremenrController.text =
                                  list[value].toString();
                            },
                            children:
                                List<Widget>.generate(list.length, (int index) {
                              return Text(
                                list[index].toString(),
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
                                if (scrollcontroller.selectedItem == 0) {
                                  retirement.put("retage", list[0]);
                                  retiremenrController.text =
                                      list[0].toString();
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
        namecontroller: nameController,
        name: (value) => order.value = order.value.copyWith(name: value),
        yearcontroller: yearcontroller,
        monthly: (value) {
          var myInt = int.parse(value!.replaceAll(",", ""));

          order.value = order.value.copyWith(monthly_fee: myInt);
        },
        monthlycontroller: monthly,
        formkey: retirementkey.value,
        insurance: () async {
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
                            scrollController: insurancescrollcontroller,
                            looping: false,
                            itemExtent: 46,
                            onSelectedItemChanged: (value) async {
                              order.value = order.value.copyWith(
                                  retirement_type_id: value == 0 ? 1 : 2);
                              insurancecontroller.text =
                                  value == 0 ? "monthly".tr() : "fullfee".tr();
                              await retirement.put("type", value == 0 ? 1 : 2);
                            },
                            children: [
                              const Text("monthly").tr(),
                              const Text("fullfee").tr(),
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
                                await context.router.pop();

                                if (insurancescrollcontroller.selectedItem ==
                                    0) {
                                  order.value = order.value
                                      .copyWith(retirement_type_id: 1);
                                  insurancecontroller.text = "monthly".tr();
                                  await retirement.put("type", 1);
                                }
                                if (insurancecontroller.text ==
                                    "monthly".tr()) {
                                  if (context.mounted) {
                                    showDialog(
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
                                                  'typedes',
                                                ).tr(),
                                              ],
                                            ),
                                            children: [
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 40.0, right: 40.0),
                                                child: const Text("mfee").tr(),
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
                                                    width: 100,
                                                    height: 60,
                                                    child: Center(
                                                        child: const Text(
                                                      "confirm",
                                                      style: TextStyle(
                                                          color: Colors.white,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ).tr()),
                                                  ),
                                                ),
                                              )
                                            ]);
                                      },
                                    );
                                  }
                                } else {
                                  if (insurancecontroller.text ==
                                      "fullfee".tr()) {
                                    if (context.mounted) {
                                      showDialog(
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
                                                    'typedes',
                                                  ).tr(),
                                                ],
                                              ),
                                              children: [
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 40.0,
                                                          right: 40.0),
                                                  child:
                                                      const Text("ffee").tr(),
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 40.0,
                                                          right: 40.0),
                                                  child: GestureDetector(
                                                    onTap: () async {
                                                      context.router.pop();
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
                                  }
                                }
                              },
                            ),
                          ),
                        )
                      ],
                    ),
                  ));
        },
        insurancecontroller: insurancecontroller,
        fullfee: fullfee,
      ),
      RetirementUploadPage(
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
      )
    ];
    final index = useState(0);
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
                                name: "retirement".tr(),
                                description: "insurancedes".tr(),
                                icon: "assets/ret.svg",
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
                                        stepperList: retirementstepperdata,
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
                                          onTap: () {
                                            if (index.value != 0) {
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
                                                if (index.value == 0 &&
                                                    retirementkey
                                                        .value.currentState!
                                                        .validate()) {
                                                  final isLaseIndex =
                                                      index.value ==
                                                          cases.length - 1;
                                                  index.value = isLaseIndex
                                                      ? 0
                                                      : index.value + 1;
                                                } else if (index.value == 1 &&
                                                    _images.value.length == 2) {
                                                  isloading.value = true;

                                                  await Future.delayed(
                                                      const Duration(
                                                          seconds: 1), (() {
                                                    order.value = order.value
                                                        .copyWith(
                                                            birthdate:
                                                                retirement.get(
                                                                    "birthdate"));
                                                    order.value = order.value
                                                        .copyWith(
                                                            retirement_age:
                                                                retirement.get(
                                                                    "retage"));
                                                  }));

                                                  ref
                                                      .read(
                                                          retirmentplaceOrderProvider)
                                                      .execute(
                                                          RetirmentPlaceOrderUseCaseInput(
                                                              retirementOrderModel:
                                                                  order.value,
                                                              token: token))
                                                      .then(
                                                          (value) =>
                                                              value.fold((l) {
                                                                isloading
                                                                        .value =
                                                                    false;

                                                                ScaffoldMessenger.of(
                                                                        context)
                                                                    .showSnackBar(SnackBar(
                                                                        content:
                                                                            const Text("contact").tr()));
                                                              }, (r) async {
                                                                RetirmentDoneModel
                                                                    orderdone =
                                                                    r;
                                                                for (var element
                                                                    in _images
                                                                        .value) {
                                                                  ref
                                                                      .read(
                                                                          retirmentattachplaceOrderProvider)
                                                                      .execute(RetirmentAttachFileUseCaseInput(
                                                                          token:
                                                                              token,
                                                                          orderid: orderdone
                                                                              .id,
                                                                          file: File(
                                                                              element)))
                                                                      .then((value) =>
                                                                          value.fold(
                                                                              (l) {
                                                                            isloading.value =
                                                                                false;

                                                                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: const Text("contact").tr()));
                                                                          }, (r) async {
                                                                            if (element ==
                                                                                _images.value.last) {
                                                                              isloading.value = false;
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
                                                                                              await context.router.replaceAll([
                                                                                                HomeScreen(order: true)
                                                                                              ]).then((value) => ref.refresh(GetorderProvider(token).future));
                                                                                            },
                                                                                            child: Container(
                                                                                              color: Colors.blue[600],
                                                                                              width: 100,
                                                                                              height: 60,
                                                                                              child: Center(
                                                                                                  child: const Text(
                                                                                                "confirm",
                                                                                                style: TextStyle(color: Colors.white),
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
                                                              }));
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
                                                  index.value != 1
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
