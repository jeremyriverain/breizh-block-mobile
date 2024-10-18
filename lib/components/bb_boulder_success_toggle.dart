import 'package:breizh_blok_mobile/blocs/vibrator_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BbBoulderSuccessToggle extends StatefulWidget {
  const BbBoulderSuccessToggle({
    this.size = 35,
    super.key,
  })  : borderSideWidth = size / 20,
        iconSize = size / 2;

  final double size;
  final double borderSideWidth;
  final double iconSize;

  @override
  State<BbBoulderSuccessToggle> createState() => _BbBoulderSuccessToggleState();
}

class _BbBoulderSuccessToggleState extends State<BbBoulderSuccessToggle> {
  bool isSelected = false;
  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        SizedBox(
          height: widget.size,
          width: widget.size,
          child: IconButton(
            iconSize: widget.size,
            style: IconButton.styleFrom(
              side: BorderSide(
                color: isSelected ? Colors.white : Colors.grey,
                width: widget.borderSideWidth,
              ),
              backgroundColor: isSelected ? Colors.black : Colors.grey.shade800,
            ),
            padding: EdgeInsets.zero,
            isSelected: isSelected,
            icon: Icon(
              Icons.emoji_events_outlined,
              color: isSelected ? Colors.white : Colors.grey,
              size: widget.iconSize,
            ),
            onPressed: () {
              setState(() {
                isSelected = !isSelected;
                if (isSelected) {
                  context.read<VibratorBloc>().add(VibrateEvent());
                }
              });
            },
          ),
        ),
        if (isSelected)
          Positioned(
            top: -2,
            right: -1,
            child: Badge.count(
              backgroundColor: isSelected
                  ? Theme.of(context).colorScheme.primary
                  : Color.lerp(
                      Theme.of(context).colorScheme.primary,
                      Colors.grey,
                      0.5,
                    ),
              count: 1,
            ),
          ),
      ],
    );
  }
}
