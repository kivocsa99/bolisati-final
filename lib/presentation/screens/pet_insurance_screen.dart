import 'package:auto_route/auto_route.dart';
import 'package:bolisati/domain/api/orders/petorders/petordermodel.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../application/auth/ali_api/use_cases/deletenotifications/delete_notification_use.case.dart';
import '../../application/auth/ali_api/use_cases/deletenotifications/delete_notification_use.case.input.dart';
import '../../application/provider/user.repository.provider.dart';
import '../../constants.dart';
import '../../domain/api/files/filesmodel.dart';
import '../../router/app_route.gr.dart';

class PetInsuranceScreen extends HookConsumerWidget {
  final PetOrderModel? model;
  final String? id;
  final String? type;
  const PetInsuranceScreen({super.key, this.model, this.id, this.type});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final Box setting = Hive.box("setting");
    final token = setting.get("apitoken");
    final neworder = ref.watch(getnewProvider(token, id ?? "", type ?? ""));
    return SafeArea(
      child: Scaffold(
        body: Container(
          color: Colors.white,
          width: double.infinity,
          height: MediaQuery.of(context).size.height,
          child: id == null
              ? SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  child: SizedBox(
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
                                              GetorderProvider(token).future));
                                    },
                                    icon: const Icon(Icons.arrow_back_ios_new)))
                            : Positioned(
                                right: 20,
                                top: 30,
                                child: IconButton(
                                    onPressed: () async {
                                      await context.router.replaceAll([
                                        HomeScreen()
                                      ]).then((value) async =>
                                          await ref.refresh(
                                              GetorderProvider(token).future));
                                    },
                                    icon: const Icon(
                                        FontAwesomeIcons.arrowRight))),
                        Positioned(
                            left: context.locale.languageCode == "ar" ? 0 : 80,
                            right: context.locale.languageCode == "ar" ? 80 : 0,
                            top: 40,
                            child: Text(
                              "insuinfo".tr(),
                              style: const TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold),
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
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(12))),
                                height: 56,
                                width: 56,
                                child: Center(
                                    child: SvgPicture.asset("assets/pet.svg")),
                              ),
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
                                fontSize: 20, fontWeight: FontWeight.bold),
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
                                              fontSize: 15, color: Colors.grey))
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
                                          context.locale.languageCode == "ar"
                                              ? model!.company!.name_ar!
                                              : model!.company!.name!,
                                          style: const TextStyle(
                                              fontSize: 15, color: Colors.grey))
                                    ],
                                  ),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      const Text("orderstatus").tr(),
                                      Text(model!.status!.name!,
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
                                      const Text("price").tr(),
                                      Text(
                                          "${model!.total.toString()} ${"jod".tr()}",
                                          style: const TextStyle(
                                              fontSize: 15, color: Colors.grey))
                                    ],
                                  ),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      const Text("addoncount").tr(),
                                      Text(model!.addons!.length.toString(),
                                          style: const TextStyle(
                                              fontSize: 15, color: Colors.grey))
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
                                      const Text("gender").tr(),
                                      Text(model!.gender!.name!,
                                          style: const TextStyle(
                                              fontSize: 15, color: Colors.grey))
                                    ],
                                  ),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Text("ptype").tr(),
                                      Text(
                                          context.locale.languageCode == "end"
                                              ? model!.type!.name!
                                              : model!.type!.name_ar!,
                                          style: const TextStyle(
                                              fontSize: 15, color: Colors.grey))
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
                                              fontSize: 15, color: Colors.grey))
                                    ],
                                  ),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Text("enddate").tr(),
                                      Text(
                                          DateFormat('dd/MM/yyyy').format(
                                              DateTime.parse(model!.end_date!)),
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
                                      const Text("paymentway").tr(),
                                      const Text("cop",
                                              style: TextStyle(
                                                  fontSize: 15,
                                                  color: Colors.grey))
                                          .tr(),
                                    ],
                                  ),
                                ],
                              ),
                              const Divider(
                                thickness: 2,
                                color: Colors.black,
                              ),
                              SizedBox(
                                width: double.infinity,
                                height: 300,
                                child: Builder(builder: (context) {
                                  final List<FilesModel> policy = model!.files!
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
                                                  .map((file) => ExpansionTile(
                                                        title:
                                                            const Text("policy")
                                                                .tr(),
                                                        children: [
                                                          GestureDetector(
                                                              onTap: () async {
                                                                if (await canLaunchUrl(
                                                                    Uri.parse(
                                                                        "https://system.bolisati.com/storage/${file.name}"))) {
                                                                  await launchUrl(
                                                                      Uri.parse(
                                                                          "https://system.bolisati.com/storage/${file.name}"),
                                                                      mode: LaunchMode
                                                                          .externalApplication);
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
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              : ValueListenableBuilder(
                  valueListenable: setting.listenable(),
                  builder: (context, box, child) {
                    return neworder.when(
                        data: (data) {
                          return data.fold((l) {
                            print(l);
                            return const Text("contact").tr();
                          }, (r) {
                            print("object");
                            PetOrderModel model = r;
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
                                                      GetorderProvider(token)
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
                                                      GetorderProvider(token)
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
                                                "assets/pet.svg")),
                                      ),
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
                                              Text(model.name!,
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
                                              Text(model.id.toString(),
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
                                                      ? model.company!.name_ar!
                                                      : model.company!.name!,
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
                                              Text(model.status!.name!,
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
                                              const Text("price").tr(),
                                              Text(
                                                  "${model.total.toString()} ${"jod".tr()}",
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
                                                  model.addons!.length
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
                                              const Text("gender").tr(),
                                              Text(model.gender!.name!,
                                                  style: const TextStyle(
                                                      fontSize: 15,
                                                      color: Colors.grey))
                                            ],
                                          ),
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              const Text("ptype").tr(),
                                              Text(
                                                  context.locale.languageCode ==
                                                          "end"
                                                      ? model.type!.name!
                                                      : model.type!.name_ar!,
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
                                                  DateFormat('dd/MM/yyyy')
                                                      .format(DateTime.parse(
                                                          model.start_date!)),
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
                                                  DateFormat('dd/MM/yyyy')
                                                      .format(DateTime.parse(
                                                          model.end_date!)),
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
                                              const Text("paymentway").tr(),
                                              const Text("cop",
                                                      style: TextStyle(
                                                          fontSize: 15,
                                                          color: Colors.grey))
                                                  .tr(),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                const Divider(
                                  thickness: 2,
                                  color: Colors.black,
                                ),
                                SizedBox(
                                  width: double.infinity,
                                  height: 300,
                                  child: Builder(builder: (context) {
                                    final List<FilesModel> policy = model.files!
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
                                                        (file) => ExpansionTile(
                                                              title: const Text(
                                                                      "policy")
                                                                  .tr(),
                                                              children: [
                                                                GestureDetector(
                                                                    onTap:
                                                                        () async {
                                                                      if (await canLaunchUrl(
                                                                          Uri.parse(
                                                                              "https://system.bolisati.com/storage/${file.name}"))) {
                                                                        await launchUrl(
                                                                            Uri.parse(
                                                                                "https://system.bolisati.com/storage/${file.name}"),
                                                                            mode:
                                                                                LaunchMode.externalApplication);
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
                                )
                              ],
                            );
                          });
                        },
                        error: (error, st) => const Text("contact").tr(),
                        loading: () => const SpinKitThreeInOut(
                              color: Colors.blue,
                            ));
                  }),
        ),
      ),
    );
  }
}
