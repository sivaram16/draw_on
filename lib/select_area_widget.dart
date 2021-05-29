part of 'draw_on_widget.dart';

class SelectAreaWidget extends StatefulWidget {
  /// Give the Correct answer coordinates to draw.
  final List<List<Offset>>? correctAnswerCoordinates;

  /// Widget that want to be appear
  final Widget? widget;

  /// Callback to get X - axis value
  final ValueChanged<double>? getXaxis;

  /// Callback to get Y - axis value
  final ValueChanged<double>? getYaxis;

  /// Give coordinate size X
  final double? coordinateSizeX;

  /// Give coordinate size Y
  final double? coordinateSizeY;

  /// Callback for OnTap
  final Function()? onTap;

  /// Is selectable
  final bool? isSelectable;

  /// Show pointer
  final bool? showPointer;

  /// Points Color
  final Color? pointsColor;

  /// Line Color
  final Color? lineColor;

  /// Select Area will give you the, whether the selected point is inside the given points.
  SelectAreaWidget({
    @required this.correctAnswerCoordinates,
    @required this.widget,
    @required this.getXaxis,
    @required this.getYaxis,
    @required this.coordinateSizeY,
    @required this.coordinateSizeX,
    @required this.onTap,
    this.isSelectable = true,
    this.showPointer = false,
    @required this.lineColor,
    @required this.pointsColor,
  });
  @override
  _SelectAreaWidgetState createState() => _SelectAreaWidgetState();
}

class _SelectAreaWidgetState extends State<SelectAreaWidget> {
  /// Selected Position X
  double? selectedPositionX;

  /// Selected Position Y
  double? selectedPositionY;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: widget.isSelectable!
          ? (TapDownDetails details) => onSelected(details)
          : null,
      onTap: widget.onTap,
      child: Stack(
        children: <Widget>[
          widget.widget!,
          if (selectedPositionX != null && widget.showPointer!)
            CustomPaint(
              painter: SelectionPoint(
                selectedPositionX!,
                selectedPositionY!,
                widget.coordinateSizeX!,
                widget.coordinateSizeY!,
                widget.pointsColor!,
              ),
            ),
          if (widget.correctAnswerCoordinates!.isNotEmpty)
            CustomPaint(
              painter: AnswerRegion(
                widget.correctAnswerCoordinates!,
                widget.coordinateSizeX!,
                widget.coordinateSizeY!,
                widget.lineColor!,
              ),
            )
        ],
      ),
    );
  }

  void onSelected(TapDownDetails details) {
    setState(() {
      selectedPositionX = details.localPosition.dx;
      selectedPositionY = details.localPosition.dy;
    });
    widget.getXaxis!(selectedPositionX!);
    widget.getYaxis!(selectedPositionY!);
  }
}
