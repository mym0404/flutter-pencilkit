import 'package:flutter/material.dart';

class PencilKit extends StatelessWidget {
  const PencilKit({super.key});

  @override
  Widget build(BuildContext context) {
    if (Theme.of(context).platform == TargetPlatform.iOS) {
      return const _PencilKit();
    } else {
      return Container(
        color: Colors.red,
        child: const Center(
          child: Text('You cannot render PencilKit widget except iOS platform'),
        ),
      );
    }
  }
}

class _PencilKit extends StatelessWidget {
  const _PencilKit({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return UiKitView(
      viewType: '',
    );
  }
}
