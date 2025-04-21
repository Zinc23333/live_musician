import 'package:flutter/material.dart';

class WaitingDialog<T> extends StatelessWidget {
  const WaitingDialog(this.future, {super.key});

  final Future<T> future;

  Future<T?> show(BuildContext context) =>
      showDialog<T>(context: context, builder: (context) => this);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("加载中..."),
      content: FutureBuilder(
        future: future,
        builder: (context, snapshot) {
          // debugPrint("message: ${snapshot.data}");
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasError) {
              debugPrint(snapshot.error.toString());
              debugPrintStack(stackTrace: snapshot.stackTrace);
            }
            back(context, snapshot.data);
          }

          return SizedBox(
            height: 64,
            child: Center(child: CircularProgressIndicator()),
          );
        },
      ),
    );
  }

  void back(BuildContext context, [T? data]) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Navigator.pop(context, data);
    });
  }
}
