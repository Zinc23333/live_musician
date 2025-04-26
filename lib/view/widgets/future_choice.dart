import 'package:flutter/material.dart';

class FutureChoice<T> extends StatelessWidget {
  const FutureChoice({
    super.key,
    required this.future,
    this.showNameFunc,
    this.showNameWidgetFunc,
    this.selected,
    required this.onSelected,
  }) : assert(showNameFunc != null || showNameWidgetFunc != null);
  final Future<List<T>> future;
  final String Function(T)? showNameFunc;
  final Widget Function(T)? showNameWidgetFunc;
  final T? selected;
  final void Function(T) onSelected;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: future,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return Wrap(
            spacing: 4,
            runSpacing: 4,
            children:
                snapshot.data!
                    .map(
                      (e) => ChoiceChip(
                        label:
                            showNameWidgetFunc != null
                                ? showNameWidgetFunc!(e)
                                : Text(showNameFunc!(e)),
                        selected: e == selected,
                        onSelected: (value) {
                          if (value) {
                            onSelected(e);
                          }
                        },
                      ),
                    )
                    .toList(),
            // snapshot.data!.map((e) {
            //   return Text(e.name);
            // }).toList(),
          );
        }
        if (snapshot.hasError) {
          return Text("加载失败: ${snapshot.error}");
        }
        return const Center(child: CircularProgressIndicator());
      },
    );
  }
}
