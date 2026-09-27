import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:thaheen_task/core/design_system/theme/thaheen_colors.dart';
import 'package:thaheen_task/core/design_system/theme/thaheen_theme.dart';
import 'package:thaheen_task/features/player/presentation/bloc/player_cubit.dart';
import 'package:thaheen_task/features/player/presentation/bloc/player_seek_cubit.dart';
import 'package:thaheen_task/l10n/app_localizations.dart';
import 'package:thaheen_task/utils/duration_formatter.dart';

/// Overlay controls pinned to the bottom of the video: play/pause, time,
/// fullscreen, and a seek bar. Always dark, over a translucent scrim.
class VideoControls extends StatelessWidget {
  const VideoControls({required this.player, super.key});

  final PlayerCubit player;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<ThaheenColors>()!;
    return BlocBuilder<PlayerCubit, PlayerState>(
      bloc: player,
      builder: (context, state) => LayoutBuilder(
        builder: (context, constraints) => Align(
          alignment: Alignment.bottomCenter,
          child: ConstrainedBox(
            constraints: BoxConstraints(maxHeight: constraints.maxHeight),
            child: SingleChildScrollView(
              child: ColoredBox(
                color: colors.videoOverlayScrim,
                child: Theme(
                  data: ThaheenTheme.dark,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      _ButtonRow(
                        player: player,
                        state: state,
                        textColor: colors.videoOverlayText,
                      ),
                      _SeekBar(player: player, state: state),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _ButtonRow extends StatelessWidget {
  const _ButtonRow({
    required this.player,
    required this.state,
    required this.textColor,
  });

  final PlayerCubit player;
  final PlayerState state;
  final Color textColor;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final chewie = ChewieController.of(context);
    return Wrap(
      crossAxisAlignment: WrapCrossAlignment.center,
      alignment: WrapAlignment.center,
      children: [
        IconButton(
          tooltip: state.playing ? l.pause : l.play,
          onPressed: player.togglePlayback,
          icon: Icon(state.playing ? Icons.pause : Icons.play_arrow),
        ),
        Text(
          l.playbackTime(
            formatDuration(state.position),
            formatDuration(state.duration),
          ),
          style: TextStyle(color: textColor),
          textDirection: TextDirection.ltr,
        ),
        IconButton(
          tooltip: chewie.isFullScreen ? l.exitFullscreen : l.fullscreen,
          onPressed: chewie.toggleFullScreen,
          icon: Icon(
            chewie.isFullScreen ? Icons.fullscreen_exit : Icons.fullscreen,
          ),
        ),
      ],
    );
  }
}

/// Seek slider. While dragging it shows the drag position instead of the live
/// playback position, and seeks once on release.
class _SeekBar extends StatefulWidget {
  const _SeekBar({required this.player, required this.state});

  final PlayerCubit player;
  final PlayerState state;

  @override
  State<_SeekBar> createState() => _SeekBarState();
}

class _SeekBarState extends State<_SeekBar> {
  final _seek = PlayerSeekCubit();

  @override
  void dispose() {
    _seek.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = widget.state;
    final max = state.duration.inMilliseconds > 0
        ? state.duration.inMilliseconds.toDouble()
        : 1.0;
    return Directionality(
      textDirection: TextDirection.ltr,
      child: BlocBuilder<PlayerSeekCubit, double?>(
        bloc: _seek,
        builder: (context, dragPosition) => Slider(
          semanticFormatterCallback: (v) =>
              formatDuration(Duration(milliseconds: v.round())),
          value: (dragPosition ?? state.position.inMilliseconds.toDouble())
              .clamp(0, max),
          max: max,
          onChanged: _seek.preview,
          onChangeEnd: (v) => _seek.commit(v, widget.player.seek),
        ),
      ),
    );
  }
}
