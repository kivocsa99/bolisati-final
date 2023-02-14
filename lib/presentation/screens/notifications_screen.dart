import 'package:auto_route/auto_route.dart';
import 'package:bolisati/application/provider/user.repository.provider.dart';
import 'package:bolisati/domain/api/notifications/model/notificationsmodel.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../../application/auth/ali_api/use_cases/deletenotifications/delete_notification_use.case.dart';
import '../../application/auth/ali_api/use_cases/deletenotifications/delete_notification_use.case.input.dart';
import '../../constants.dart';
import '../../router/app_route.gr.dart';
import '../widgets/horizantal_user_insurance_container.dart';

class NotificationsScreen extends HookConsumerWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final Box setting = Hive.box("setting");
    final token = setting.get("apitoken");
    final notifications = ref.watch(GetnotificationsProvider(token));
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
                  child: Text(
                    "notifications".tr(),
                    style: const TextStyle(
                        fontSize: 20, fontWeight: FontWeight.bold),
                  )),
              notifications.when(
                  data: (data) {
                    return data.fold(
                        (l) => Positioned(
                              top: 100,
                              left: 20,
                              right: 20,
                              child: SizedBox(
                                height: MediaQuery.of(context).size.height,
                                child: ListView(
                                  children: [const Text("contact").tr()],
                                ),
                              ),
                            ), (notifications) {
                      print(notifications);
                      List<NotificationsModel> data = notifications;
                      return Positioned(
                        top: 100,
                        left: 10,
                        right: 10,
                        child: SizedBox(
                          height: ((90 * data.length).toDouble()) + 1000,
                          child: ListView(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            children: data.map((e) {
                              String? id;
                              String input = e.related_data!;
                              int startIndex = input.lastIndexOf("\\") + 1;
                              int endIndex = input.indexOf(",");
                              String type =
                                  input.substring(startIndex, endIndex);
                              DateTime date = DateTime.parse(e.created_at!);
                              String formattedDate =
                                  DateFormat("dd/MM/yyy").format(date);
                              RegExp regExp = RegExp(r'ID:(\d+)');
                              RegExpMatch? match = regExp.firstMatch(input);
                              if (match != null) {
                                id = match.group(1)!;
                              }
                              print(id); // 34

                              return Column(
                                children: [
                                  HorizantalUesrInsuranceContainer(
                                    insuranceName: type,
                                    insuranceDescreption: e.data2,
                                    containercolor: carcontainer,
                                    price: formattedDate,
                                    iconcolor: carcolor,
                                    function: () async {
                                      if (type == "MedicalOrder") {
                                        context.mounted
                                            ? ref
                                                .read(
                                                    deleteNotificationsUseCaseProvider)
                                                .execute(
                                                    DeleteNotificationsInput(
                                                        token: token,
                                                        id: e.id.toString()))
                                                .then((value) => value.fold(
                                                    (l) => null,
                                                    (r) => context.router.push(
                                                        MedicalInsuranceScreen(
                                                            id: id,
                                                            type:
                                                                "App\\\\Models\\\\MedicalOrder"))))
                                            : null;
                                      } else if (type == "PetOrder") {
                                        context.mounted
                                            ? ref
                                                .read(
                                                    deleteNotificationsUseCaseProvider)
                                                .execute(
                                                    DeleteNotificationsInput(
                                                        token: token,
                                                        id: e.id.toString()))
                                                .then((value) => value.fold(
                                                    (l) => null,
                                                    (r) => context.router.push(
                                                        PetInsuranceScreen(
                                                            id: id,
                                                            type:
                                                                "App\\\\Models\\\\PetOrder"))))
                                            : null;
                                      } else if (type == "MotorOrder") {
                                        context.mounted
                                            ? ref
                                                .read(
                                                    deleteNotificationsUseCaseProvider)
                                                .execute(
                                                    DeleteNotificationsInput(
                                                        token: token,
                                                        id: e.id.toString()))
                                                .then((value) => value.fold(
                                                    (l) => null,
                                                    (r) => context.router.push(
                                                        MotorInsuranceScreen(
                                                            id: id,
                                                            type:
                                                                "App\\\\Models\\\\MotorOrder"))))
                                            : null;
                                      } else if (type ==
                                          "PersonalAccidentOrder") {
                                        context.mounted
                                            ? ref
                                                .read(
                                                    deleteNotificationsUseCaseProvider)
                                                .execute(
                                                    DeleteNotificationsInput(
                                                        token: token,
                                                        id: e.id.toString()))
                                                .then((value) => value.fold(
                                                    (l) => null,
                                                    (r) => context.router.push(
                                                        PersonalInsuranceScreen(
                                                            id: id,
                                                            type:
                                                                "App\\\\Models\\\\PersonalAccidentOrder"))))
                                            : null;
                                      } else if (type == "TravelOrder") {
                                        context.mounted
                                            ? ref
                                                .read(
                                                    deleteNotificationsUseCaseProvider)
                                                .execute(
                                                    DeleteNotificationsInput(
                                                        token: token,
                                                        id: e.id.toString()))
                                                .then((value) => value.fold(
                                                    (l) => null,
                                                    (r) => context.router.push(
                                                        TravelInsuranceScreen(
                                                            id: id,
                                                            type:
                                                                "App\\\\Models\\\\TravelOrder"))))
                                            : null;
                                      } else if (type == "EducationalOrder") {
                                        context.mounted
                                            ? ref
                                                .read(
                                                    deleteNotificationsUseCaseProvider)
                                                .execute(
                                                    DeleteNotificationsInput(
                                                        token: token,
                                                        id: e.id.toString()))
                                                .then((value) => value.fold(
                                                    (l) => null,
                                                    (r) => context.router.push(
                                                        EducationalInsuranceScreen(
                                                            id: id,
                                                            type:
                                                                "App\\\\Models\\\\EducationalOrder"))))
                                            : null;
                                      } else if (type ==
                                          "DomesticWorkerOrder") {
                                        context.mounted
                                            ? ref
                                                .read(
                                                    deleteNotificationsUseCaseProvider)
                                                .execute(
                                                    DeleteNotificationsInput(
                                                        token: token,
                                                        id: e.id.toString()))
                                                .then((value) => value.fold(
                                                    (l) => null,
                                                    (r) => context.router.push(
                                                        DomesticInsuranceScreen(
                                                            id: id,
                                                            type:
                                                                "App\\\\Models\\\\DomesticWorkerOrder"))))
                                            : null;
                                      } else if (type == "RetirementOrder") {
                                        context.mounted
                                            ? ref
                                                .read(
                                                    deleteNotificationsUseCaseProvider)
                                                .execute(
                                                    DeleteNotificationsInput(
                                                        token: token,
                                                        id: e.id.toString()))
                                                .then((value) => value.fold(
                                                    (l) => null,
                                                    (r) => context.router.push(
                                                        RetirementInsuranceScreen(
                                                            id: id,
                                                            type:
                                                                "App\\\\Models\\\\RetirementOrder"))))
                                            : null;
                                      }
                                    },
                                    icon: type == "MedicalOrder"
                                        ? "assets/medical.svg"
                                        : type == "PetOrder"
                                            ? "assets/pet.svg"
                                            : type == "MotorOrder"
                                                ? "assets/car.svg"
                                                : type ==
                                                        "PersonalAccidentOrder"
                                                    ? "assets/personal.svg"
                                                    : type == "TravelOrder"
                                                        ? "assets/travel.svg"
                                                        : type ==
                                                                "EducationalOrder"
                                                            ? "assets/educational.svg"
                                                            : type ==
                                                                    "DomesticWorkerOrder"
                                                                ? "assets/domestic.svg"
                                                                : "assets/ret.svg",
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  )
                                ],
                              );
                            }).toList(),
                          ),
                        ),
                      );
                    });
                  },
                  error: (error, stacktrace) => Text(error.toString()),
                  loading: () => const SpinKitThreeInOut(
                        color: Colors.blue,
                      )),
            ],
          ),
        ),
      ),
    );
  }
}
