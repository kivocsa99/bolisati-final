import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class AnimatedSignUpForm extends HookWidget {
  final double? width;
  final VoidCallback? function;
  final VoidCallback? function1;

  final List<Widget>? list;
  final int? index;
  final bool? isStarted;
  final bool? isdone;
  final bool? isgettingmain;
  final Color? backcolor;
  const AnimatedSignUpForm(
      {super.key,
      this.isgettingmain,
      this.isStarted,
      this.width,
      this.function1,
      this.backcolor,
      this.isdone,
      this.function,
      this.list,
      this.index});

  @override
  Widget build(BuildContext context) {
    return AnimatedPositioned(
      top: isgettingmain!
          ? 150
          : (isdone!
              ? MediaQuery.of(context).size.height -
                  MediaQuery.of(context).size.height / 6.5
              : (!isStarted! ? MediaQuery.of(context).size.height : 150)),
      duration: const Duration(seconds: 1),
      curve: Curves.easeIn,
      child: SizedBox(
        width: width,
        child: Form(
          child: Column(
            children: [
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 500),
                child: list![index!],
              ),
              index != 5 && index != 6
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        GestureDetector(
                          onTap: function,
                          child: Container(
                            color: Colors.blue[600],
                            width: 175,
                            height: 60,
                            child: Center(
                                child: const Text(
                              "confirm",
                              style: TextStyle(color: Colors.white),
                            ).tr()),
                          ),
                        ),
                        GestureDetector(
                          onTap: function1,
                          child: Container(
                            color: backcolor,
                            width: 175,
                            height: 60,
                            child: Center(
                                child: const Text(
                              "back",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                            ).tr()),
                          ),
                        )
                      ],
                    )
                  : const SizedBox.shrink(),
            ],
          ),
        ),
      ),
    );
  }
}
