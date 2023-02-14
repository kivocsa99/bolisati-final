import 'package:auto_route/auto_route.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../router/app_route.gr.dart';

class AnimatedButtons extends HookWidget {
  final bool? isgettingui;
  const AnimatedButtons({super.key, this.isgettingui});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      right: 10,
      top: 80,
      child: AnimatedOpacity(
          duration: const Duration(milliseconds: 1000),
          opacity: !isgettingui! ? 0 : 1,
          child: context.locale.languageCode == "ar"
              ? Row(
                  children: [
                    IconButton(
                        onPressed: () =>
                            context.router.push(const ProfileScreen()),
                        icon: Image.asset('assets/profile.png')),
                    IconButton(
                        onPressed: () =>
                            context.router.push(const NotificationsScreen()),
                        icon: Image.asset('assets/bell.png')),
                  ],
                )
              : Row(
                  children: [
                    IconButton(
                        onPressed: () =>
                            context.router.push(const NotificationsScreen()),
                        icon: Image.asset('assets/bell.png')),
                    IconButton(
                        onPressed: () =>
                            context.router.push(const ProfileScreen()),
                        icon: Image.asset('assets/profile.png')),
                  ],
                )),
    );
  }
}
