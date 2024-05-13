import 'package:flutter/material.dart';

class NewPageScreen extends StatelessWidget {
  final Widget Function() pageBuilder;

  NewPageScreen(this.pageBuilder);

  @override
  Widget build(BuildContext context) {
    return pageBuilder();
  }
}
