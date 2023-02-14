import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

//check marrital status
class MedicalUploadPage extends HookConsumerWidget {
  final VoidCallback? function0;
  final Function(int? value)? delete;

  final List<String>? images;

  const MedicalUploadPage({
    super.key,
    this.function0,
    this.delete,
    this.images,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SizedBox(
      child: Stack(
        children: [
          Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              top: 0,
              child: GestureDetector(
                onTap: function0,
                child: SizedBox(
                  height: MediaQuery.of(context).size.height / 2,
                  child: const Text("medicalreg").tr(),
                ),
              )),
          Positioned(
            child: Container(
              padding: const EdgeInsets.only(left: 20, right: 20),
              height: MediaQuery.of(context).size.height / 2,
              child: const Divider(
                thickness: 2,
                color: Colors.grey,
              ),
            ),
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 100,
            child: GestureDetector(
              onTap: function0,
              child: SizedBox(
                height: MediaQuery.of(context).size.height / 2,
                child: images!.isEmpty
                    ? Container(
                        alignment: Alignment.center,
                        child: Image.asset(
                          "assets/family.png",
                          width: 150,
                          height: 150,
                          fit: BoxFit.fill,
                        ),
                      )
                    : SizedBox(
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: images!
                                    .asMap()
                                    .map((i, element) => MapEntry(
                                        i,
                                        Padding(
                                          padding: const EdgeInsets.all(10.0),
                                          child: Stack(
                                              clipBehavior: Clip.none,
                                              children: [
                                                Image.file(
                                                  width: 80,
                                                  height: 80,
                                                  File(element),
                                                  fit: BoxFit.cover,
                                                ),
                                                Positioned(
                                                  top: -20,
                                                  right: -20,
                                                  child: IconButton(
                                                    onPressed: () {
                                                      delete!(i);
                                                    },
                                                    icon: const Icon(
                                                      FontAwesomeIcons
                                                          .circleXmark,
                                                      color: Colors.red,
                                                    ),
                                                  ),
                                                )
                                              ]),
                                        )))
                                    .values
                                    .toList(),
                              ),
                              images!.length != 4
                                  ? GestureDetector(
                                      onTap: function0,
                                      child: Container(
                                        color: Colors.transparent,
                                        height: 80,
                                        width: 80,
                                        child: Image.asset("assets/more.png"),
                                      ),
                                    )
                                  : const SizedBox.shrink()
                            ]),
                      ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
