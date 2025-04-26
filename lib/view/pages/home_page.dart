import 'dart:async';

import 'package:flutter/material.dart';
import 'package:live_musician/data/env/constant.dart';
import 'package:live_musician/data/exts/scaffold_messenger_state_ex.dart';
import 'package:live_musician/data/net/net_cache.dart';
import 'package:live_musician/data/net/net_ping.dart';
import 'package:live_musician/view/func/history_dialog_route.dart';
import 'package:live_musician/view/pages/sound_split_page.dart';
import 'package:live_musician/view/pages/tone_train_page.dart';
import 'package:live_musician/view/pages/video_maker_page.dart';
import 'package:live_musician/view/pages/voice_infer_page.dart';
import 'package:sidebarx/sidebarx.dart';

final _tabs = [
  (Icons.music_note, "音频分离", SoundSplitPage()),
  (Icons.queue_music, "音色训练", ToneTrainPage()),
  (Icons.record_voice_over, "音色推理", VoiceInferPage()),
  (Icons.music_video, "视频制作", VideoMakerPage()),
];

class HomePage extends StatelessWidget {
  HomePage({super.key});

  final _controller = SidebarXController(selectedIndex: 0, extended: true);
  final _key = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Live Musician',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: primaryColor,
        canvasColor: canvasColor,
        scaffoldBackgroundColor: scaffoldBackgroundColor,
        appBarTheme: AppBarTheme(
          backgroundColor: canvasColor,
          foregroundColor: Colors.white,
          titleTextStyle: const TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.w500,
          ),
        ),
        textTheme: const TextTheme(
          headlineSmall: TextStyle(
            color: Colors.white,
            fontSize: 46,
            fontWeight: FontWeight.w800,
          ),
          titleMedium: whiteTextStyle,
          titleLarge: whiteTextStyle,
          titleSmall: whiteTextStyle,
          labelLarge: whiteTextStyle,
          labelMedium: whiteTextStyle,
          labelSmall: whiteTextStyle,
          bodySmall: whiteTextStyle,
          bodyMedium: whiteTextStyle,
          bodyLarge: whiteTextStyle,
        ),
        listTileTheme: ListTileThemeData(textColor: Colors.white),
        dialogTheme: DialogTheme(
          backgroundColor: canvasColor,
          titleTextStyle: const TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.w500,
          ),
          contentTextStyle: whiteTextStyle,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: canvasColor,
            foregroundColor: Colors.white,
          ),
        ),
        iconButtonTheme: IconButtonThemeData(
          style: IconButton.styleFrom(foregroundColor: Colors.white),
        ),
        inputDecorationTheme: InputDecorationTheme(
          labelStyle: whiteTextStyle,
          hintStyle: TextStyle(color: Colors.white.withAlpha(178)),
        ),

        chipTheme: ChipThemeData(
          backgroundColor: scaffoldBackgroundColor,
          labelStyle: whiteTextStyle,
          selectedColor: primaryColor,
          checkmarkColor: Colors.white,
        ),
        floatingActionButtonTheme: FloatingActionButtonThemeData(
          backgroundColor: canvasColor,
          foregroundColor: Colors.white,
        ),
      ),
      home: Builder(
        builder: (context) {
          final isSmallScreen = MediaQuery.of(context).size.width < 600;
          return _buildScaffold(context, isSmallScreen);
        },
      ),
    );
  }

  Scaffold _buildScaffold(BuildContext context, bool isSmallScreen) {
    return Scaffold(
      key: _key,
      appBar:
          isSmallScreen
              ? AppBar(
                backgroundColor: canvasColor,
                title: Text("音乐盒"),
                leading: IconButton(
                  onPressed: () => _key.currentState?.openDrawer(),
                  icon: const Icon(Icons.menu),
                ),
              )
              : null,
      drawer: AppSidebarX(controller: _controller),
      body: Row(
        children: [
          if (!isSmallScreen) AppSidebarX(controller: _controller),
          Expanded(child: _ScreensPage(controller: _controller)),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          historyDialogRoute(context, _controller.selectedIndex);
        },
        child: const Icon(Icons.menu),
      ),
    );
  }
}

class AppSidebarX extends StatelessWidget {
  const AppSidebarX({super.key, required SidebarXController controller})
    : _controller = controller;

  final SidebarXController _controller;

  @override
  Widget build(BuildContext context) {
    return SidebarX(
      controller: _controller,
      theme: SidebarXTheme(
        margin: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: canvasColor,
          borderRadius: BorderRadius.circular(20),
        ),
        hoverColor: scaffoldBackgroundColor,
        textStyle: TextStyle(color: Colors.white.withAlpha(178)),
        selectedTextStyle: whiteTextStyle,
        hoverTextStyle: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w500,
        ),
        itemTextPadding: const EdgeInsets.only(left: 30),
        selectedItemTextPadding: const EdgeInsets.only(left: 30),
        itemDecoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: canvasColor),
        ),
        selectedItemDecoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: actionColor.withAlpha(94)),
          gradient: const LinearGradient(
            colors: [accentCanvasColor, canvasColor],
          ),
          boxShadow: [
            BoxShadow(color: Colors.black.withAlpha(71), blurRadius: 30),
          ],
        ),
        iconTheme: IconThemeData(color: Colors.white.withAlpha(178), size: 20),
        selectedIconTheme: const IconThemeData(color: Colors.white, size: 20),
      ),
      extendedTheme: const SidebarXTheme(
        width: 200,
        decoration: BoxDecoration(color: canvasColor),
      ),
      // footerDivider: divider,
      footerBuilder: _buildPingBox,
      items:
          _tabs
              .map(
                (e) => SidebarXItem(
                  icon: e.$1,
                  label: e.$2,
                  onTap: () {
                    Scaffold.maybeOf(context)?.closeDrawer();
                  },
                ),
              )
              .toList(),
    );
  }

  Widget _buildPingBox(context, extended) {
    return _PingBox(key: UniqueKey(), extended: extended);
  }
}

class _PingBox extends StatefulWidget {
  const _PingBox({super.key, required this.extended});

  final bool extended;

  @override
  State<_PingBox> createState() => _PingBoxState();
}

class _PingBoxState extends State<_PingBox> {
  Duration? _ping;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    final p = NetPing.instance;
    _ping = p.lastPingDuration;

    _timer = Timer.periodic(Duration(seconds: 1), (_) async {
      _ping = p.lastPingDuration;
      if (mounted) setState(() {});
    });
  }

  @override
  void dispose() {
    super.dispose();
    _timer?.cancel();
  }

  @override
  Widget build(BuildContext context) {
    final fc = _ping == null ? Colors.red : Colors.green;
    final txt =
        _ping == null
            ? "offline"
            : widget.extended
            ? "${_ping!.inMilliseconds} ms"
            : "online";
    final de =
        widget.extended
            ? BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: Colors.white.withAlpha(77)),
            )
            : BoxDecoration(
              border: Border(
                top: BorderSide(color: Colors.white.withAlpha(77)),
              ),
            );
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: InkWell(
        onTap: () {
          NetCache.fetchDomain(forceRefresh: true).then((v) {
            if (context.mounted) {
              ScaffoldMessenger.of(context).show("创新获取域名成功: $v");
            }
          });
        },
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 8),
          decoration: de,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.circle, color: fc, size: 8),
              SizedBox(width: 4),
              Text(txt, style: TextStyle(color: fc)),
            ],
          ),
        ),
      ),
    );
  }
}

class _ScreensPage extends StatelessWidget {
  const _ScreensPage({required this.controller});

  final SidebarXController controller;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: AnimatedBuilder(
          animation: controller,
          builder: (context, child_) => _tabs[controller.selectedIndex].$3,
        ),
      ),
    );
  }
}
