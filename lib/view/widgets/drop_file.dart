import 'dart:typed_data';

import 'package:desktop_drop/desktop_drop.dart';
import 'package:dotted_decoration/dotted_decoration.dart';
import 'package:file_icon/file_icon.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:live_musician/data/exts/bool_ex.dart';
import 'package:live_musician/view/widgets/waiting_dialog.dart';

class DropFile extends StatefulWidget {
  const DropFile({
    super.key,
    required this.allowExtension,
    this.fileType = FileType.custom,
    this.onFile,
  });
  final FileType fileType;
  final List<String> allowExtension;
  final void Function(Uint8List data, String? fileName, String fileType)?
  onFile;

  @override
  State<DropFile> createState() => _DropFileState();
}

class _DropFileState extends State<DropFile> {
  DropItem? file1;
  PlatformFile? file2;

  bool get hasFile => file1 != null || file2 != null;
  String? get fileName => file1?.name ?? file2?.name;
  Future<Uint8List?> get fileData async =>
      await file1?.readAsBytes() ??
      (file2?.readStream != null
          ? Uint8List.fromList([await for (final d in file2!.readStream!) ...d])
          : null);

  void onFile() async {
    if (hasFile) {
      final value = await WaitingDialog(fileData).show(context);
      if (value != null) {
        final f = fileName!;
        var ld = f.lastIndexOf(".");
        ld = ld == -1 ? f.length : ld;

        widget.onFile?.call(value, f.substring(0, ld), f.substring(ld));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return DropTarget(
      onDragDone: (details) {
        if (details.files.isNotEmpty) {
          final f = details.files.first;
          if (widget.allowExtension.any((e) => f.name.endsWith(e))) {
            file1 = f;
            file2 = null;
            onFile();
            setState(() {});
          }
        }
      },
      child: InkWell(
        onTap: () async {
          final sms = ScaffoldMessenger.of(context);
          final f = await FilePicker.platform.pickFiles(
            type: widget.fileType,
            withReadStream: true,
            allowedExtensions: (widget.fileType == FileType.custom).ifTrue(
              widget.allowExtension,
            ),
          );
          if (f != null && f.files.isNotEmpty) {
            if (widget.allowExtension.any(
              (e) => f.files.first.name.endsWith(e),
            )) {
              file1 = null;
              file2 = f.files.first;
            } else {
              sms.showSnackBar(SnackBar(content: Text('不支持的文件类型')));
            }
          } else {
            file1 = null;
            file2 = null;
          }
          onFile();
          setState(() {});
        },
        child: Container(
          padding: EdgeInsets.all(16),
          decoration: DottedDecoration(
            color: Colors.white,
            shape: Shape.box,
            borderRadius: const BorderRadius.all(Radius.circular(24)),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (hasFile)
                FileIcon(fileName!, size: 56)
              else
                Icon(Icons.upload, size: 56, color: Colors.white),
              SizedBox(height: 8),

              Text(
                fileName ?? '打开文件(${widget.allowExtension.join("/")})',
                style: TextStyle(fontSize: 16, color: Colors.white),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
