import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class DomesticIdContainer extends HookConsumerWidget {
  final VoidCallback? function0;
  final VoidCallback? function1;
  final VoidCallback? function2;

  final List<String>? images;
  final List<String>? images1;
  final List<String>? images2;

  final Function(int? value)? delete0;
  final Function(int? value)? delete1;
  final Function(int? value)? delete2;

  const DomesticIdContainer(
      {super.key,
      this.function0,
      this.function1,
      this.function2,
      this.delete0,
      this.delete1,
      this.delete2,
      this.images,
      this.images1,
      this.images2});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SizedBox(
      child: Stack(
        children: [
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
              bottom: 0,
              top: 0,
              child: SizedBox(
                height: MediaQuery.of(context).size.height / 2,
                child: const Text("kafeel").tr(),
              )),
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
                          "assets/id.png",
                          width: 120,
                          height: 120,
                          fit: BoxFit.fill,
                        ),
                      )
                    : SizedBox(
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: images!
                                  .asMap()
                                  .map((i, element) => MapEntry(
                                      i,
                                      Padding(
                                        padding: const EdgeInsets.all(20.0),
                                        child: Stack(
                                            clipBehavior: Clip.none,
                                            children: [
                                              Image.file(
                                                width: 150,
                                                height: 150,
                                                File(element),
                                                fit: BoxFit.cover,
                                              ),
                                              Positioned(
                                                top: -20,
                                                right: -20,
                                                child: IconButton(
                                                  onPressed: () {
                                                    delete0!(i);
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
                            images!.length != 2
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
                          ])),
              ),
            ),
          ),
          Positioned(
              left: 0,
              right: 0,
              bottom: -250,
              child: SizedBox(
                height: MediaQuery.of(context).size.height / 2,
                child: const Text("domkafeel").tr(),
              )),
          Positioned(
            left: 0,
            right: 0,
            bottom: -120,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                GestureDetector(
                  onTap: function1,
                  child: SizedBox(
                    height: MediaQuery.of(context).size.height / 2,
                    child: images1!.isEmpty
                        ? Container(
                            alignment: Alignment.center,
                            child: Image.asset(
                              "assets/passport.png",
                              width: 120,
                              height: 120,
                              fit: BoxFit.fill,
                            ),
                          )
                        : SizedBox(
                            child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: images1!
                                        .asMap()
                                        .map((i, element) => MapEntry(
                                            i,
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(10.0),
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
                                                          delete1!(i);
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
                                  images1!.length != 2
                                      ? GestureDetector(
                                          onTap: function1,
                                          child: Container(
                                            color: Colors.transparent,
                                            height: 80,
                                            width: 80,
                                            child:
                                                Image.asset("assets/more.png"),
                                          ),
                                        )
                                      : const SizedBox.shrink()
                                ]),
                          ),
                  ),
                ),
                GestureDetector(
                  onTap: function2,
                  child: SizedBox(
                    height: MediaQuery.of(context).size.height / 2,
                    child: images2!.isEmpty
                        ? Container(
                            alignment: Alignment.center,
                            child: Image.asset(
                              "assets/form.png",
                              width: 120,
                              height: 120,
                              fit: BoxFit.fill,
                            ),
                          )
                        : SizedBox(
                            child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: images2!
                                        .asMap()
                                        .map((i, element) => MapEntry(
                                            i,
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(10.0),
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
                                                          delete2!(i);
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
                                  images2!.length != 2
                                      ? GestureDetector(
                                          onTap: function2,
                                          child: Container(
                                            color: Colors.transparent,
                                            height: 80,
                                            width: 80,
                                            child:
                                                Image.asset("assets/more.png"),
                                          ),
                                        )
                                      : const SizedBox.shrink()
                                ]),
                          ),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
