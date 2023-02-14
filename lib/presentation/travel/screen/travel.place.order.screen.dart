import 'dart:io';

import 'package:another_stepper/widgets/another_stepper.dart';
import 'package:auto_route/auto_route.dart';
import 'package:bolisati/application/travel/attachfile/attach.file.use.case.dart';
import 'package:bolisati/application/travel/attachfile/attach.file.use.case.input.dart';
import 'package:bolisati/application/travel/getoffers/get.offers.use.case.dart';
import 'package:bolisati/application/travel/getoffers/get.offers.use.case.input.dart';
import 'package:bolisati/application/travel/placeorder/place.order.use.case.dart';
import 'package:bolisati/application/travel/placeorder/place.order.use.case.input.dart';
import 'package:bolisati/constants.dart';
import 'package:bolisati/domain/api/orders/travelorders/travelordermodel.dart';
import 'package:bolisati/domain/api/travel/model/travelorderdonemodel.dart';
import 'package:bolisati/presentation/travel/widgets/travelbottomsheet.dart';
import 'package:bolisati/presentation/travel/widgets/travelinformationcontainer.dart';
import 'package:bolisati/presentation/travel/widgets/travelordercontainer.dart';
import 'package:bolisati/presentation/travel/widgets/traveluploadpage.dart';
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

import '../../../application/provider/pet.repository.provider.dart';
import '../../../application/provider/user.repository.provider.dart';
import '../../../domain/api/orders/travelorders/city/citymodel.dart';
import '../../../domain/api/pet/model/petcountrymodel.dart';
import '../../../domain/api/travel/model/travelmodel.dart';
import '../../../router/app_route.gr.dart';
import '../../widgets/back_insuarance_container.dart';

class TravelPlaceOrderScreen extends HookConsumerWidget {
  const TravelPlaceOrderScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final order = useState(const TravelOrderModel());
    final nameController = useTextEditingController();
    final regioncontroller = useTextEditingController();
    final yearcontroller = useTextEditingController();
    final startController = useTextEditingController();
    final endController = useTextEditingController();
    final periodcontroller = useTextEditingController();
    final countrycontroller = useTextEditingController();
    final filteredcontroller = useTextEditingController();
    final destinationcontroller = useTextEditingController();
    final offer = useState<List<TravelOffersModel>>([]);
    final travelkey = useState(GlobalKey<FormState>());
    final Box setting = Hive.box("setting");
    final Box travel = Hive.box("travel");
    final scrollcontroller = FixedExtentScrollController(initialItem: 0);
    final _isLoading = useState(false);
    final filtered = useState<List<PetCountryModel>>([]);
    final filteredcity = useState<List<CityModel>>([]);

    final endselecteddate = useState("");
    final imageCount = useState(0);
    final _images = useState<List<String>>([]);
    List<Widget> cases = [
      TravelInformationContainer(
        destination: (value) {
          order.value = order.value.copyWith(destination: value);
        },
        destinationcontroller: destinationcontroller,
        country: () async {
          _isLoading.value = true;
          final country = await ref
              .read(getcountryProvider(setting.get("apitoken")).future);

          country.fold(
              (l) => ScaffoldMessenger.of(context)
                  .showSnackBar(SnackBar(content: Text("contact".tr()))),
              (r) async {
            _isLoading.value = false;

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
                                    ? travel.put("country", cars[value].name)
                                    : travel.put(
                                        "country", filtered.value[value].name);
                                filtered.value.isEmpty
                                    ? countrycontroller.text = cars[value].name!
                                    : countrycontroller.text =
                                        filtered.value[value].name!;
                              },
                              children: filtered.value.isNotEmpty
                                  ? List<Widget>.generate(filtered.value.length,
                                      (int index) {
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
                                        const Duration(milliseconds: 500), () {
                                      filtered.value.isEmpty
                                          ? travel.put("country", cars[0].name)
                                          : travel.put("country",
                                              filtered.value[0].name);
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
        },
        countrycontroller: countrycontroller,
        startchanged: (val) {
          travel.put(
              "startdate", DateFormat("yyyy-MM-dd HH:mm:ss").format(val!));
          startController.text = DateFormat("d/M/y").format(val);
          travel.put("start", val);

          if (travel.get("start") != null && travel.get("end") != null) {
            DateTime start = travel.get("start");
            DateTime end = travel.get("end");
            print(start);
            print(end);
            int? period = end.difference(start).inDays + 1;
            periodcontroller.text = period.toString();
            print(periodcontroller.text);
          }
        },
        endchanged: (val) {
          endselecteddate.value = val!.toString();

          travel.put("enddate", DateFormat("yyyy-MM-dd HH:mm:ss").format(val));
          travel.put("end", val);

          endController.text = DateFormat("d/M/y").format(val);
          if (travel.get("start") != null && travel.get("end") != null) {
            DateTime start = travel.get("start");
            DateTime end = travel.get("end");
            print(start);
            print(end);
            int? period = end.difference(start).inDays + 1;
            periodcontroller.text = period.toString();
            print(periodcontroller.text);
          }
        },
        namecontroller: nameController,
        name: (value) => order.value = order.value.copyWith(name: value),
        regioncontroller: regioncontroller,
        yearcontroller: yearcontroller,
        startdatecontroller: startController,
        enddatecontroller: endController,
        period: (value) => order.value =
            order.value.copyWith(period_of_stay: int.parse(value!)),
        periodcontroller: periodcontroller,
        formkey: travelkey.value,
      ),
      TravelOrderOffersContainer(
        offers: offer.value,
      ),
      TravelUploadPage(
        delete: (value) {
          print("object");
          _images.value.removeAt(value!);
          imageCount.value = imageCount.value - 1;
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
                            if (imageCount.value < 4) {
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
                            if (imageCount.value < 4) {
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
                        const EdgeInsets.only(left: 30, right: 30, top: 30),
                    child: SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          BackInsuranceContainer(
                            name: "travel".tr(),
                            description: "traveldes".tr(),
                            icon: "assets/travel.svg",
                            function: () => context.router.pop(),
                            containercolor: travelcontainer,
                          ),
                          const SizedBox(
                            height: 50,
                          ),
                          Container(
                            color: Colors.white,
                            width: double.infinity,
                            child: Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: AnotherStepper(
                                    scrollPhysics:
                                        const BouncingScrollPhysics(),
                                    activeIndex: index.value,
                                    stepperList: travelstepperdata,
                                    stepperDirection: Axis.horizontal,
                                    inverted: false,
                                  ),
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                                AnimatedSwitcher(
                                  duration: const Duration(milliseconds: 500),
                                  child: cases[index.value],
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    GestureDetector(
                                      onTap: () async {
                                        if (index.value == 1) {
                                          await travel.delete("travelid");
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
                                                if (travelkey
                                                    .value.currentState!
                                                    .validate()) {
                                                  _isLoading.value = true;
                                                  await ref
                                                      .read(
                                                          travelgetOffersProvider)
                                                      .execute(TravelGetOffersUseCaseInput(
                                                          regionid: travel
                                                              .get("region"),
                                                          token: token,
                                                          age:
                                                              travel.get("age"),
                                                          periodindays: int.parse(
                                                              periodcontroller
                                                                  .text)))
                                                      .then(
                                                          (value) =>
                                                              value.fold((l) {
                                                                _isLoading
                                                                        .value =
                                                                    false;

                                                                ScaffoldMessenger.of(
                                                                        context)
                                                                    .showSnackBar(SnackBar(
                                                                        content:
                                                                            const Text("contact").tr()));
                                                              }, (r) {
                                                                _isLoading
                                                                        .value =
                                                                    false;

                                                                offer.value = r;

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
                                                if (travel.get("travelid") !=
                                                    null) {
                                                  final isLaseIndex =
                                                      index.value ==
                                                          cases.length - 1;
                                                  index.value = isLaseIndex
                                                      ? 0
                                                      : index.value + 1;
                                                } else {
                                                  ScaffoldMessenger.of(context)
                                                      .showSnackBar(SnackBar(
                                                          content: Text(
                                                              "offersdes"
                                                                  .tr())));
                                                }
                                              } else if (index.value == 2) {
                                                if (_images.value.isNotEmpty) {
                                                  await Future.delayed(
                                                      const Duration(
                                                          seconds: 1), (() {
                                                    order.value = order.value
                                                        .copyWith(
                                                            travel_insurance_id:
                                                                travel.get(
                                                                    "travelid"));

                                                    order.value = order.value
                                                        .copyWith(
                                                            start_date:
                                                                travel.get(
                                                                    "startdate"));
                                                    order.value = order.value
                                                        .copyWith(
                                                            end_date:
                                                                travel.get(
                                                                    "enddate"));
                                                    order.value = order.value
                                                        .copyWith(
                                                            destination:
                                                                "${travel.get("country")}-${order.value.destination}");
                                                    order.value = order.value
                                                        .copyWith(
                                                            birthdate: travel.get(
                                                                "birthdate"));
                                                  }));
                                                  final TravelOffersModel
                                                      offersModel =
                                                      offer.value.firstWhere(
                                                          (element) =>
                                                              element.id ==
                                                              travel.get(
                                                                  "travelid"));

                                                  if (context.mounted) {
                                                    showModalBottomSheet(
                                                      isScrollControlled: true,
                                                      isDismissible: true,
                                                      context: context,
                                                      builder: (ctx) {
                                                        return TravelBottomSheet(
                                                          function: () {
                                                            _isLoading.value =
                                                                true;
                                                            ref
                                                                .read(
                                                                    travelplaceorderProvider)
                                                                .execute(TravelPlaceOrderUseCaseInput(
                                                                    travelOrder:
                                                                        order
                                                                            .value,
                                                                    token:
                                                                        token,
                                                                    addons:
                                                                        travel.get("addon") ??
                                                                            ""))
                                                                .then((value) =>
                                                                    value.fold(
                                                                        (l) {
                                                                      _isLoading
                                                                              .value =
                                                                          false;

                                                                      ScaffoldMessenger.of(
                                                                              context)
                                                                          .showSnackBar(
                                                                              SnackBar(content: const Text("contact").tr()));
                                                                    }, (r) async {
                                                                      context
                                                                          .router
                                                                          .pop();
                                                                      TravelOrderDoneModel
                                                                          orderdone =
                                                                          r;
                                                                      final List<
                                                                              String>
                                                                          hello =
                                                                          _images
                                                                              .value;

                                                                      for (var element
                                                                          in hello) {
                                                                        ref.read(travelattachfileProvider).execute(TravelAttachFileUseCaseInput(token: token, orderid: orderdone.id, file: File(element))).then((value) =>
                                                                            value.fold((l) => ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: const Text("contact").tr())),
                                                                                (r) async {
                                                                              if (element == hello.last) {
                                                                                _isLoading.value = false;
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
                                                                                                    style: TextStyle(color: Colors.white),
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
                                                } else {
                                                  ScaffoldMessenger.of(context)
                                                      .showSnackBar(SnackBar(
                                                          content: Text(
                                                              "picupload"
                                                                  .tr())));
                                                }
                                              }
                                            },
                                            child: Container(
                                              color: Colors.blue[600],
                                              width: 175,
                                              height: 60,
                                              child: Center(
                                                  child: Text(
                                                index.value != 2
                                                    ? "next"
                                                    : "confirm",
                                                style: const TextStyle(
                                                    color: Colors.white,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ).tr()),
                                            ),
                                          );
                                        }),
                                  ],
                                ),
                                const SizedBox(
                                  height: 50,
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ),
        Visibility(
          visible: _isLoading.value,
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
