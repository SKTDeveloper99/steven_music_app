import 'package:audioplayers/audioplayers.dart';
import 'package:audioplayers_example/components/btn.dart';
import 'package:audioplayers_example/components/tab_wrapper.dart';
import 'package:audioplayers_example/components/tgl.dart';
import 'package:audioplayers_example/utils.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';

const _asset1 = 'anne_marie_2002.mp3';
const _asset2 = 'chainsmokers_closer.mp3';
const _asset3 = 'dive_back_in_time.mp3';
const _asset4 = 'JeremyZucker_comethru.mp3';
const _asset5 = 'Maroon_5_Memories.mp3';

class SourcesTab extends StatefulWidget {
  final AudioPlayer player;

  const SourcesTab({Key? key, required this.player}) : super(key: key);

  @override
  State<SourcesTab> createState() => _SourcesTabState();
}

enum InitMode {
  setSource,
  play,
}

class _SourcesTabState extends State<SourcesTab>
    with AutomaticKeepAliveClientMixin<SourcesTab> {
  Future<void> setSource(Source source) async {
    if (initMode == InitMode.setSource) {
      await widget.player.setSource(source);
      toast(
        'Completed setting source.',
        textKey: const Key('toast-source-set'),
      );
    } else {
      await widget.player.stop();
      await widget.player.play(source);
    }
  }

  InitMode initMode = InitMode.setSource;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return TabWrapper(
      children: [
        EnumTgl(
          options: {for (var e in InitMode.values) 'initMode-${e.name}': e},
          selected: initMode,
          onChange: (InitMode m) => setState(() {
            initMode = m;
          }),
        ),
        Btn(
          key: const Key('setSource-asset-wav'),
          txt: '2002 Anne Marie',
          onPressed: () => setSource(AssetSource(_asset1)),
        ),
        Btn(
          key: const Key('setSource-asset-mp3'),
          txt: 'Closer Chainsmokers',
          onPressed: () => setSource(AssetSource(_asset2)),
        ),
        Btn(
          key: const Key('setSource-asset-wav'),
          txt: 'Dive Back in Time',
          onPressed: () => setSource(AssetSource(_asset3)),
        ),
        Btn(
          key: const Key('setSource-asset-mp3'),
          txt: 'Comethru Jeremy Zucker',
          onPressed: () => setSource(AssetSource(_asset4)),
        ),
        Btn(
          key: const Key('setSource-asset-wav'),
          txt: 'Memories Maroon 5',
          onPressed: () => setSource(AssetSource(_asset5)),
        ),
        Btn(
          key: const Key('setSource-url-local'),
          txt: 'Pick local file',
          onPressed: () async {
            final result = await FilePicker.platform.pickFiles();
            final path = result?.files.single.path;
            if (path != null) {
              setSource(DeviceFileSource(path));
            }
          },
        ),
      ],
    );
  }

  @override
  bool get wantKeepAlive => true;
}
