import 'package:auto_route/auto_route.dart';
import 'package:bolisati/application/motor/placeorder/place.order.use.case.dart';
import 'package:bolisati/application/motor/placeorder/place.order.use.case.input.dart';
import 'package:bolisati/application/motor/setstatus/set.status.use.case.input.dart';
import 'package:bolisati/domain/api/orders/motororders/motorordermodel.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../application/motor/setstatus/set.status.use.case.dart';
import '../../application/provider/user.repository.provider.dart';
import '../../constants.dart';
import '../../domain/api/files/filesmodel.dart';
import '../../router/app_route.gr.dart';

class MotorInsuranceScreen extends HookConsumerWidget {
  final MotorOrderModel? model;
  final String? id;
  final String? type;
  const MotorInsuranceScreen({super.key, this.id, this.type, this.model});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    print(model);
    print(id);
    final Box setting = Hive.box("setting");
    final apitoken = setting.get("apitoken");
    final order = useState(const MotorOrderModel());

    return SafeArea(
      child: Scaffold(
        body: id == null
            ? Column(
                children: [
                  Container(
                      color: Colors.white,
                      width: double.infinity,
                      height: MediaQuery.of(context).size.height - 250,
                      child: SingleChildScrollView(
                        child: SizedBox(
                          width: double.infinity,
                          height: MediaQuery.of(context).size.height,
                          child: Stack(
                            children: [
                              context.locale.languageCode == "en"
                                  ? Positioned(
                                      left: 20,
                                      top: 30,
                                      child: IconButton(
                                          onPressed: () async {
                                            await context.router.replaceAll([
                                              HomeScreen()
                                            ]).then((value) async =>
                                                await ref.refresh(
                                                    GetorderProvider(apitoken)
                                                        .future));
                                          },
                                          icon: const Icon(
                                              Icons.arrow_back_ios_new)))
                                  : Positioned(
                                      right: 20,
                                      top: 30,
                                      child: IconButton(
                                          onPressed: () async {
                                            await context.router.replaceAll([
                                              HomeScreen()
                                            ]).then((value) async =>
                                                await ref.refresh(
                                                    GetorderProvider(apitoken)
                                                        .future));
                                          },
                                          icon: const Icon(
                                              FontAwesomeIcons.arrowRight))),
                              Positioned(
                                  left: context.locale.languageCode == "ar"
                                      ? 0
                                      : 80,
                                  right: context.locale.languageCode == "ar"
                                      ? 80
                                      : 0,
                                  top: 40,
                                  child: Text(
                                    "insuinfo".tr(),
                                    style: const TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold),
                                  )),
                              Positioned(
                                top: 120,
                                left: 40,
                                right: 40,
                                child: SizedBox(
                                    child: Row(
                                  children: [
                                    Container(
                                      decoration: const BoxDecoration(
                                          color: carcontainer,
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(12))),
                                      height: 56,
                                      width: 56,
                                      child: Center(
                                          child: SvgPicture.asset(
                                              "assets/car.svg")),
                                    ),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    Column(
                                      children: [
                                        Text(
                                          model!.car_make!,
                                          style: const TextStyle(
                                              fontSize: 10, color: Colors.grey),
                                        ),
                                        Text(
                                          model!.car_model!,
                                          style: const TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        Text(
                                          model!.car_year!,
                                          style: const TextStyle(
                                              fontSize: 10, color: Colors.grey),
                                        ),
                                      ],
                                    )
                                  ],
                                )),
                              ),
                              Positioned(
                                top: 200,
                                left: 40,
                                right: 40,
                                child: const Text(
                                  "insuranceinfo",
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold),
                                ).tr(),
                              ),
                              Positioned(
                                top: 240,
                                left: 40,
                                right: 40,
                                child: Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            const Text("insname").tr(),
                                            Text(model!.name!,
                                                style: const TextStyle(
                                                    fontSize: 15,
                                                    color: Colors.grey))
                                          ],
                                        ),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            const Text("idnumber").tr(),
                                            Text(model!.id.toString(),
                                                style: const TextStyle(
                                                    fontSize: 15,
                                                    color: Colors.grey)),
                                          ],
                                        ),
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            const Text("insucompany").tr(),
                                            Text(
                                                context.locale.languageCode ==
                                                        "ar"
                                                    ? model!.company!.name_ar!
                                                    : model!.company!.name!,
                                                style: const TextStyle(
                                                    fontSize: 15,
                                                    color: Colors.grey))
                                          ],
                                        ),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.end,
                                          children: [
                                            const Text("orderstatus").tr(),
                                            Text(model!.status!.name!,
                                                style: const TextStyle(
                                                    fontSize: 10,
                                                    color: Colors.grey)),
                                          ],
                                        ),
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            const Text("price").tr(),
                                            Text(
                                                "${model!.total.toString()} ${"jod".tr()}",
                                                style: const TextStyle(
                                                    fontSize: 15,
                                                    color: Colors.grey))
                                          ],
                                        ),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            const Text("addoncount").tr(),
                                            Text(
                                                model!.addons!.length
                                                    .toString(),
                                                style: const TextStyle(
                                                    fontSize: 15,
                                                    color: Colors.grey))
                                          ],
                                        )
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            const Text("startdate").tr(),
                                            Text(
                                                DateFormat('dd/MM/yyyy').format(
                                                    DateTime.parse(
                                                        model!.start_date!)),
                                                style: const TextStyle(
                                                    fontSize: 15,
                                                    color: Colors.grey))
                                          ],
                                        ),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            const Text("enddate").tr(),
                                            Text(
                                                DateFormat('dd/MM/yyyy').format(
                                                    DateTime.parse(
                                                        model!.end_date!)),
                                                style: const TextStyle(
                                                    fontSize: 15,
                                                    color: Colors.grey)),
                                          ],
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                              ),
                              Positioned(
                                top: 460,
                                left: 40,
                                right: 40,
                                child: const Text(
                                  "cardes",
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold),
                                ).tr(),
                              ),
                              Positioned(
                                top: 500,
                                left: 40,
                                right: 40,
                                child: Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            const Text("carbrand").tr(),
                                            Text(model!.car_make!,
                                                style: const TextStyle(
                                                    fontSize: 15,
                                                    color: Colors.grey))
                                          ],
                                        ),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            const Text("carmodel").tr(),
                                            Text(model!.car_model!,
                                                style: const TextStyle(
                                                    fontSize: 15,
                                                    color: Colors.grey)),
                                          ],
                                        ),
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            const Text("value").tr(),
                                            Text(
                                                "${model!.estimated_car_price!.toString()} ${"jod".tr()}",
                                                style: const TextStyle(
                                                    fontSize: 15,
                                                    color: Colors.grey))
                                          ],
                                        ),
                                      ],
                                    ),
                                    const Divider(
                                      thickness: 2,
                                      color: Colors.black,
                                    ),
                                    Builder(builder: (context) {
                                      final List<FilesModel> policy = model!
                                          .files!
                                          .where((element) =>
                                              element.flag == "admin" ||
                                              element.flag == "system")
                                          .toList();
                                      return SingleChildScrollView(
                                        child: ExpansionTile(
                                          title: const Text("files").tr(),
                                          children: [
                                            SingleChildScrollView(
                                              child: Column(
                                                  children: policy
                                                      .map(
                                                          (file) =>
                                                              ExpansionTile(
                                                                title: const Text(
                                                                        "file")
                                                                    .tr(),
                                                                children: [
                                                                  GestureDetector(
                                                                      onTap:
                                                                          () async {
                                                                        if (await canLaunchUrl(
                                                                            Uri.parse("https://system.bolisati.com/storage/${file.name}"))) {
                                                                          await launchUrl(
                                                                              Uri.parse("https://system.bolisati.com/storage/${file.name}"),
                                                                              mode: LaunchMode.externalApplication);
                                                                        } else {
                                                                          throw Exception(
                                                                              'Could not launch ');
                                                                        }
                                                                      },
                                                                      child: const Text(
                                                                              "viewfile")
                                                                          .tr()),
                                                                ],
                                                              ))
                                                      .toList()),
                                            )
                                          ],
                                        ),
                                      );
                                    }),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      )),
                  model!.status!.id == 4
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                              GestureDetector(
                                onTap: () async {
                                  ref
                                      .read(setstatusOrderProvider)
                                      .execute(SetStatusOrderUseCaseInput(
                                          token: apitoken,
                                          id: model!.id.toString(),
                                          status: "accepted_by_client"))
                                      .then((value) => value.fold(
                                              (l) => ScaffoldMessenger.of(
                                                      context)
                                                  .showSnackBar(SnackBar(
                                                      content:
                                                          const Text("contact")
                                                              .tr())),
                                              (r) async {
                                            await showDialog(
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
                                                        child: const Text(
                                                                "approveorder")
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
                                                            await context.router.replaceAll([
                                                              HomeScreen()
                                                            ]).then((value) async =>
                                                                await ref.refresh(
                                                                    GetorderProvider(
                                                                            apitoken)
                                                                        .future));
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
                                          }));
                                },
                                child: Container(
                                  color: Colors.green,
                                  width: 175,
                                  height: 60,
                                  child: Center(
                                      child: const Text(
                                    "approve",
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 13),
                                  ).tr()),
                                ),
                              ),
                              GestureDetector(
                                onTap: () async {
                                  ref
                                      .read(setstatusOrderProvider)
                                      .execute(SetStatusOrderUseCaseInput(
                                          token: apitoken,
                                          id: model!.id.toString(),
                                          status: "rejected"))
                                      .then((value) => value.fold(
                                              (l) => ScaffoldMessenger.of(
                                                      context)
                                                  .showSnackBar(SnackBar(
                                                      content:
                                                          const Text("contact")
                                                              .tr())),
                                              (r) async {
                                            await showDialog(
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
                                                        child: const Text(
                                                                "declineorder")
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
                                                            await context.router.replaceAll([
                                                              HomeScreen()
                                                            ]).then((value) async =>
                                                                await ref.refresh(
                                                                    GetorderProvider(
                                                                            apitoken)
                                                                        .future));
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
                                          }));
                                },
                                child: Container(
                                  color: Colors.red,
                                  width: 175,
                                  height: 60,
                                  child: Center(
                                      child: const Text(
                                    "decline",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 13,
                                        fontWeight: FontWeight.bold),
                                  ).tr()),
                                ),
                              )
                            ])
                      : const SizedBox.shrink(),
                  const SizedBox(
                    height: 20,
                  ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: GestureDetector(
                      onTap: () {
                        if (DateTime.parse(model!.end_date!)
                                .difference(DateTime.parse(model!.start_date!))
                                .inDays !=
                            14) {
                          ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: const Text("renewdes").tr()));
                        } else {
                          ref
                              .read(motorplaceOrderProvider)
                              .execute(MotorPlaceOrderUseCaseInput(
                                  motorOrder: model ?? order.value,
                                  token: apitoken,
                                  addons: ""))
                              .then((value) => value.fold((l) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
                                            content:
                                                const Text("contact").tr()));
                                  },
                                      (r) async => showDialog(
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
                                                          const EdgeInsets.only(
                                                              left: 40.0,
                                                              right: 40.0),
                                                      child: const Text(
                                                              "orderconfirm")
                                                          .tr(),
                                                    ),
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              left: 40.0,
                                                              right: 40.0),
                                                      child: GestureDetector(
                                                        onTap: () async {
                                                          await context.router.replaceAll([
                                                            HomeScreen()
                                                          ]).then((value) async =>
                                                              await ref.refresh(
                                                                  GetorderProvider(
                                                                          apitoken)
                                                                      .future));
                                                        },
                                                        child: Container(
                                                          color:
                                                              Colors.blue[600],
                                                          width: 100,
                                                          height: 60,
                                                          child: Center(
                                                              child: const Text(
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
                                          )));
                        }
                      },
                      child: Container(
                        color: DateTime.parse(model!.end_date!)
                                    .difference(
                                        DateTime.parse(model!.start_date!))
                                    .inDays ==
                                14
                            ? Colors.blue[600]
                            : Colors.grey,
                        width: 315,
                        height: 60,
                        child: Center(
                            child: const Text(
                          "renew",
                          style: TextStyle(
                              color: Colors.white, fontWeight: FontWeight.bold),
                        ).tr()),
                      ),
                    ),
                  )
                ],
              )
            : ValueListenableBuilder(
                valueListenable: setting.listenable(),
                builder: (builder, box, child) {
                  final neworder = ref.watch(
                      getnewProvider(setting.get("apitoken"), id!, type!));
                  return Column(
                    children: [
                      Container(
                          color: Colors.white,
                          width: double.infinity,
                          height: MediaQuery.of(context).size.height - 170,
                          child: SingleChildScrollView(
                            child: SizedBox(
                              width: double.infinity,
                              height: MediaQuery.of(context).size.height,
                              child: neworder.when(
                                  data: (data) {
                                    return data.fold((l) {
                                      return const Text("contact").tr();
                                    }, (r) {
                                      order.value = r;

                                      return Stack(
                                        children: [
                                          context.locale.languageCode == "en"
                                              ? Positioned(
                                                  left: 20,
                                                  top: 30,
                                                  child: IconButton(
                                                      onPressed: () async {
                                                        await context.router.replaceAll([
                                                          HomeScreen()
                                                        ]).then((value) async =>
                                                            await ref.refresh(
                                                                GetorderProvider(
                                                                        apitoken)
                                                                    .future));
                                                      },
                                                      icon: const Icon(Icons
                                                          .arrow_back_ios_new)))
                                              : Positioned(
                                                  right: 20,
                                                  top: 30,
                                                  child: IconButton(
                                                      onPressed: () async {
                                                        await context.router.replaceAll([
                                                          HomeScreen()
                                                        ]).then((value) async =>
                                                            await ref.refresh(
                                                                GetorderProvider(
                                                                        apitoken)
                                                                    .future));
                                                      },
                                                      icon: const Icon(
                                                          FontAwesomeIcons
                                                              .arrowRight))),
                                          Positioned(
                                              left:
                                                  context.locale.languageCode ==
                                                          "ar"
                                                      ? 0
                                                      : 80,
                                              right:
                                                  context.locale.languageCode ==
                                                          "ar"
                                                      ? 80
                                                      : 0,
                                              top: 40,
                                              child: Text(
                                                "insuinfo".tr(),
                                                style: const TextStyle(
                                                    fontSize: 20,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              )),
                                          Positioned(
                                            top: 120,
                                            left: 40,
                                            right: 40,
                                            child: SizedBox(
                                                child: Row(
                                              children: [
                                                Container(
                                                  decoration:
                                                      const BoxDecoration(
                                                          color: carcontainer,
                                                          borderRadius:
                                                              BorderRadius.all(
                                                                  Radius
                                                                      .circular(
                                                                          12))),
                                                  height: 56,
                                                  width: 56,
                                                  child: Center(
                                                      child: SvgPicture.asset(
                                                          "assets/car.svg")),
                                                ),
                                                const SizedBox(
                                                  width: 10,
                                                ),
                                                Column(
                                                  children: [
                                                    Text(
                                                      order.value.car_make!,
                                                      style: const TextStyle(
                                                          fontSize: 10,
                                                          color: Colors.grey),
                                                    ),
                                                    Text(
                                                      order.value.car_model!,
                                                      style: const TextStyle(
                                                          fontSize: 15,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                    Text(
                                                      order.value.car_year!,
                                                      style: const TextStyle(
                                                          fontSize: 10,
                                                          color: Colors.grey),
                                                    ),
                                                  ],
                                                )
                                              ],
                                            )),
                                          ),
                                          Positioned(
                                            top: 200,
                                            left: 40,
                                            right: 40,
                                            child: const Text(
                                              "insuranceinfo",
                                              style: TextStyle(
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.bold),
                                            ).tr(),
                                          ),
                                          Positioned(
                                            top: 240,
                                            left: 40,
                                            right: 40,
                                            child: Column(
                                              children: [
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .center,
                                                      children: [
                                                        const Text("insname")
                                                            .tr(),
                                                        Text(order.value.name!,
                                                            style:
                                                                const TextStyle(
                                                                    fontSize:
                                                                        15,
                                                                    color: Colors
                                                                        .grey))
                                                      ],
                                                    ),
                                                    Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .center,
                                                      children: [
                                                        const Text("idnumber")
                                                            .tr(),
                                                        Text(
                                                            order.value.id
                                                                .toString(),
                                                            style:
                                                                const TextStyle(
                                                                    fontSize:
                                                                        15,
                                                                    color: Colors
                                                                        .grey)),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                                const SizedBox(
                                                  height: 10,
                                                ),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        const Text(
                                                                "insucompany")
                                                            .tr(),
                                                        Text(
                                                            context.locale
                                                                        .languageCode ==
                                                                    "ar"
                                                                ? order
                                                                    .value
                                                                    .company!
                                                                    .name_ar!
                                                                : order
                                                                    .value
                                                                    .company!
                                                                    .name!,
                                                            style:
                                                                const TextStyle(
                                                                    fontSize:
                                                                        15,
                                                                    color: Colors
                                                                        .grey))
                                                      ],
                                                    ),
                                                    Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .end,
                                                      children: [
                                                        GestureDetector(
                                                            onTap: () {
                                                              showDialog(
                                                                barrierDismissible:
                                                                    false,
                                                                context:
                                                                    context,
                                                                builder:
                                                                    (context) {
                                                                  return SimpleDialog(
                                                                    title: Row(
                                                                      mainAxisAlignment:
                                                                          MainAxisAlignment
                                                                              .spaceBetween,
                                                                      children: [
                                                                        Image
                                                                            .asset(
                                                                          "assets/logo.png",
                                                                          scale:
                                                                              1.5,
                                                                        ),
                                                                        const SizedBox(
                                                                          width:
                                                                              10,
                                                                        ),
                                                                        const Text(
                                                                          'orderdes',
                                                                        ).tr(),
                                                                      ],
                                                                    ),
                                                                    children: [
                                                                      Padding(
                                                                        padding: const EdgeInsets.only(
                                                                            left:
                                                                                40.0,
                                                                            right:
                                                                                40.0,
                                                                            bottom:
                                                                                0),
                                                                        child:
                                                                            GestureDetector(
                                                                          onTap:
                                                                              () async {},
                                                                          child:
                                                                              Container(
                                                                            color:
                                                                                Colors.blue[600],
                                                                            width:
                                                                                100,
                                                                            height:
                                                                                60,
                                                                            child: const Center(
                                                                                child: Text(
                                                                              "confirm",
                                                                              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                                                                            )),
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  );
                                                                },
                                                              );
                                                            },
                                                            child: const Text(
                                                                    "orderstatus")
                                                                .tr()),
                                                        GestureDetector(
                                                          onTap: () async {
                                                            order.value.status!
                                                                        .id ==
                                                                    4
                                                                ? await showDialog(
                                                                    barrierDismissible:
                                                                        false,
                                                                    context:
                                                                        context,
                                                                    builder:
                                                                        (context) {
                                                                      return SimpleDialog(
                                                                          title:
                                                                              Row(
                                                                            mainAxisAlignment:
                                                                                MainAxisAlignment.spaceBetween,
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
                                                                              child: const Text("approveorder").tr(),
                                                                            ),
                                                                            Padding(
                                                                              padding: const EdgeInsets.only(left: 40.0, right: 40.0),
                                                                              child: GestureDetector(
                                                                                onTap: () async {
                                                                                  context.router.replaceAll([
                                                                                    HomeScreen()
                                                                                  ]);
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
                                                                  )
                                                                : null;
                                                          },
                                                          child: Text(
                                                              order.value.status!
                                                                              .id ==
                                                                          4 &&
                                                                      context.locale
                                                                              .languageCode ==
                                                                          "ar"
                                                                  ? "(i) عرض سعر"
                                                                  : "# ${order.value.status!.name!}",
                                                              style: const TextStyle(
                                                                  fontSize: 10,
                                                                  color: Colors
                                                                      .red)),
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                                const SizedBox(
                                                  height: 10,
                                                ),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        order.value.status!
                                                                    .name !=
                                                                "Sent An Offer"
                                                            ? const Text(
                                                                    "price")
                                                                .tr()
                                                            : const Text(
                                                                    "newprice")
                                                                .tr(),
                                                        Text(
                                                            "${order.value.total.toString()} ${"jod".tr()}",
                                                            style:
                                                                const TextStyle(
                                                                    fontSize:
                                                                        15,
                                                                    color: Colors
                                                                        .grey))
                                                      ],
                                                    ),
                                                    Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .center,
                                                      children: [
                                                        const Text("addoncount")
                                                            .tr(),
                                                        Text(
                                                            order.value.addons!
                                                                .length
                                                                .toString(),
                                                            style:
                                                                const TextStyle(
                                                                    fontSize:
                                                                        15,
                                                                    color: Colors
                                                                        .grey))
                                                      ],
                                                    )
                                                  ],
                                                ),
                                                const SizedBox(
                                                  height: 10,
                                                ),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        const Text("startdate")
                                                            .tr(),
                                                        Text(
                                                            DateFormat(
                                                                    'dd/MM/yyyy')
                                                                .format(DateTime
                                                                    .parse(order
                                                                        .value
                                                                        .start_date!)),
                                                            style:
                                                                const TextStyle(
                                                                    fontSize:
                                                                        15,
                                                                    color: Colors
                                                                        .grey))
                                                      ],
                                                    ),
                                                    Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        const Text("enddate")
                                                            .tr(),
                                                        Text(
                                                            DateFormat(
                                                                    'dd/MM/yyyy')
                                                                .format(DateTime
                                                                    .parse(order
                                                                        .value
                                                                        .end_date!)),
                                                            style:
                                                                const TextStyle(
                                                                    fontSize:
                                                                        15,
                                                                    color: Colors
                                                                        .grey)),
                                                      ],
                                                    ),
                                                  ],
                                                )
                                              ],
                                            ),
                                          ),
                                          Positioned(
                                            top: 460,
                                            left: 40,
                                            right: 40,
                                            child: const Text(
                                              "cardes",
                                              style: TextStyle(
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.bold),
                                            ).tr(),
                                          ),
                                          Positioned(
                                            top: 500,
                                            left: 40,
                                            right: 40,
                                            child: Column(
                                              children: [
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .center,
                                                      children: [
                                                        const Text("carbrand")
                                                            .tr(),
                                                        Text(
                                                            order.value
                                                                .car_make!,
                                                            style:
                                                                const TextStyle(
                                                                    fontSize:
                                                                        15,
                                                                    color: Colors
                                                                        .grey))
                                                      ],
                                                    ),
                                                    Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .center,
                                                      children: [
                                                        const Text("carmodel")
                                                            .tr(),
                                                        Text(
                                                            order.value
                                                                .car_model!,
                                                            style:
                                                                const TextStyle(
                                                                    fontSize:
                                                                        15,
                                                                    color: Colors
                                                                        .grey)),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                                const SizedBox(
                                                  height: 10,
                                                ),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        const Text("value")
                                                            .tr(),
                                                        Text(
                                                            "${order.value.estimated_car_price!.toString()} ${"jod".tr()}",
                                                            style:
                                                                const TextStyle(
                                                                    fontSize:
                                                                        15,
                                                                    color: Colors
                                                                        .grey))
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      );
                                    });
                                  },
                                  error: (error, st) =>
                                      const Text("contact").tr(),
                                  loading: () => const SpinKitThreeInOut(
                                        color: Colors.blue,
                                      )),
                            ),
                          )),
                      order.value.status!.id == 4
                          ? Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                  GestureDetector(
                                    onTap: () async {
                                      ref
                                          .read(setstatusOrderProvider)
                                          .execute(SetStatusOrderUseCaseInput(
                                              token: apitoken,
                                              id: order.value.id.toString(),
                                              status: "accepted_by_client"))
                                          .then((value) => value.fold(
                                                  (l) => ScaffoldMessenger.of(
                                                          context)
                                                      .showSnackBar(SnackBar(
                                                          content: const Text(
                                                                  "contact")
                                                              .tr())),
                                                  (r) async {
                                                await showDialog(
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
                                                                    right:
                                                                        40.0),
                                                            child: const Text(
                                                                    "approveorder")
                                                                .tr(),
                                                          ),
                                                          Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                        .only(
                                                                    left: 40.0,
                                                                    right:
                                                                        40.0),
                                                            child:
                                                                GestureDetector(
                                                              onTap: () async {
                                                                await context
                                                                    .router
                                                                    .replaceAll([
                                                                  HomeScreen()
                                                                ]).then((value) async =>
                                                                        await ref
                                                                            .refresh(GetorderProvider(apitoken).future));
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
                                              }));
                                    },
                                    child: Container(
                                      color: Colors.green,
                                      width: 175,
                                      height: 60,
                                      child: Center(
                                          child: const Text(
                                        "approve",
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 13,
                                            fontWeight: FontWeight.bold),
                                      ).tr()),
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () async {
                                      ref
                                          .read(setstatusOrderProvider)
                                          .execute(SetStatusOrderUseCaseInput(
                                              token: apitoken,
                                              id: order.value.id.toString(),
                                              status: "rejected"))
                                          .then((value) => value.fold(
                                                  (l) => ScaffoldMessenger.of(
                                                          context)
                                                      .showSnackBar(SnackBar(
                                                          content: const Text(
                                                                  "contact")
                                                              .tr())),
                                                  (r) async {
                                                await showDialog(
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
                                                                    right:
                                                                        40.0),
                                                            child: const Text(
                                                                    "declineorder")
                                                                .tr(),
                                                          ),
                                                          Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                        .only(
                                                                    left: 40.0,
                                                                    right:
                                                                        40.0),
                                                            child:
                                                                GestureDetector(
                                                              onTap: () async {
                                                                await context
                                                                    .router
                                                                    .replaceAll([
                                                                  HomeScreen()
                                                                ]).then((value) async =>
                                                                        await ref
                                                                            .refresh(GetorderProvider(apitoken).future));
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
                                              }));
                                    },
                                    child: Container(
                                      color: Colors.red,
                                      width: 175,
                                      height: 60,
                                      child: Center(
                                          child: const Text(
                                        "decline",
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 13),
                                      ).tr()),
                                    ),
                                  )
                                ])
                          : const SizedBox.shrink(),
                      const SizedBox(
                        height: 20,
                      ),
                      Align(
                        alignment: Alignment.bottomCenter,
                        child: GestureDetector(
                          onTap: () {
                            if (DateTime.parse(order.value.end_date!)
                                    .difference(
                                        DateTime.parse(order.value.start_date!))
                                    .inDays !=
                                14) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                      content: const Text("renewdes").tr()));
                            } else {
                              ref
                                  .read(motorplaceOrderProvider)
                                  .execute(MotorPlaceOrderUseCaseInput(
                                      motorOrder: order.value,
                                      token: apitoken,
                                      addons: ""))
                                  .then((value) => value.fold((l) {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(SnackBar(
                                                content: const Text("contact")
                                                    .tr()));
                                      },
                                          (r) async => showDialog(
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
                                                          child: const Text(
                                                                  "orderconfirm")
                                                              .tr(),
                                                        ),
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                      .only(
                                                                  left: 40.0,
                                                                  right: 40.0),
                                                          child:
                                                              GestureDetector(
                                                            onTap: () async {
                                                              await context
                                                                  .router
                                                                  .replaceAll([
                                                                HomeScreen()
                                                              ]).then((value) async =>
                                                                      await ref.refresh(
                                                                          GetorderProvider(apitoken)
                                                                              .future));
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
                                              )));
                            }
                          },
                          child: Container(
                            color: DateTime.parse(order.value.end_date!)
                                        .difference(DateTime.parse(
                                            order.value.start_date!))
                                        .inDays ==
                                    14
                                ? Colors.blue[600]
                                : Colors.grey,
                            width: 315,
                            height: 60,
                            child: Center(
                                child: const Text(
                              "renew",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                            ).tr()),
                          ),
                        ),
                      )
                    ],
                  );
                },
              ),
      ),
    );
  }
}
