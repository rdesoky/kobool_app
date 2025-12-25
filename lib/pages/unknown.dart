import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class UnknownPage extends HookWidget {
  final String pageName;
  const UnknownPage({super.key, required this.pageName});

  @override
  Widget build(BuildContext context) {
    // Your implementation here

    return Scaffold(
      appBar: AppBar(centerTitle: false),
      body: Center(child: Text('Unknown Page $pageName')),
    );
  }
}
