import 'package:coinkeeper/screens/layout/mobile_app_template.dart';
import 'package:coinkeeper/screens/layout/web_app_template.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class ResponsiveLayout extends StatefulWidget {
  const ResponsiveLayout({super.key});

  @override
  State<ResponsiveLayout> createState() => _ResponsiveLayoutState();
}

class _ResponsiveLayoutState extends State<ResponsiveLayout> {
  @override
  Widget build(BuildContext context) {
    return (kIsWeb) ? const WebAppTemplate() : const MobileAppTemplate();
  }
}
