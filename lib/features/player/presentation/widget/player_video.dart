import 'package:flutter/material.dart';

import 'package:thaheen_task/core/design_system/theme/thaheen_colors.dart';
import 'package:thaheen_task/features/player/presentation/bloc/player_cubit.dart';
import 'package:thaheen_task/features/player/presentation/widget/video_controls.dart';

/// The lesson video in its own aspect ratio, with Thaheen's [VideoControls].
class PlayerVideo extends StatelessWidget {
  const PlayerVideo({required this.player, super.key});

  final PlayerCubit player;

  static const _fallbackAspectRatio = 16 / 9;

  @override
  Widget build(BuildContext context) {
    final video = player.video;
    return AspectRatio(
      aspectRatio: video?.aspectRatio ?? _fallbackAspectRatio,
      child: ColoredBox(
        color: Theme.of(context).extension<ThaheenColors>()!.videoBackground,
        child: video?.buildView(controls: VideoControls(player: player)),
      ),
    );
  }
}
