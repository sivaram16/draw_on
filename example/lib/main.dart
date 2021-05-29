import 'package:draw_on/draw_on.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

void main() {
  runApp(DrawOnExample());
}

class DrawOnExample extends StatefulWidget {
  @override
  _DrawOnExampleState createState() => _DrawOnExampleState();
}

class _DrawOnExampleState extends State<DrawOnExample> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Draw On'),
        ),
        body: Center(
          child: SingleChildScrollView(
            child: Wrap(
              runSpacing: 50.0,
              spacing: 80.0,
              children: [
                _DrawAreaExample(),
                _SelectAreaExample(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _DrawOnImageWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Image.asset(
      "assets/heart.png",
      width: 400,
      height: 400,
      fit: BoxFit.fill,
    );
  }
}

class _SelectAreaExample extends StatefulWidget {
  @override
  __SelectAreaExampleState createState() => __SelectAreaExampleState();
}

class __SelectAreaExampleState extends State<_SelectAreaExample> {
  double? selectedPositionX;
  double? selectedPositionY;
  double coordinateSizeX = 1;
  double coordinateSizeY = 1;
  List<Offset> polygonPoints = [];
  final List<List<Offset>> coordinates = [
    [
      Offset(170.7, 116.0),
      Offset(131.7, 154.0),
      Offset(162.7, 170.0),
      Offset(219.7, 106.0),
      Offset(183.7, 110.0),
      Offset(170.7, 116.0)
    ],
    [
      Offset(194.7, 208.0),
      Offset(175.7, 258.0),
      Offset(230.7, 252.0),
      Offset(235.7, 198.0),
      Offset(206.7, 201.0),
      Offset(194.7, 208.0)
    ]
  ];
  bool isSelectable = true;
  List<List<Offset>> correctAnswerCoordinates = [];
  bool isInside = false;
  String answer = "";
  bool showPointer = true;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          'Select anywhere on the image',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 24),
        ),
        SizedBox(height: 10),
        SelectAreaWidget(
          correctAnswerCoordinates: correctAnswerCoordinates,
          widget: _DrawOnImageWidget(),
          isSelectable: isSelectable,
          getXaxis: (xAxis) {
            setState(() {
              selectedPositionX = xAxis;
            });
          },
          showPointer: showPointer,
          getYaxis: (yAxis) {
            setState(() {
              selectedPositionY = yAxis;
            });
          },
          coordinateSizeX: coordinateSizeX,
          coordinateSizeY: coordinateSizeY,
          onTap: () {
            setState(() {
              showPointer = true;
              coordinateSizeX = 1.0;
              coordinateSizeY = 1.0;
            });
          },
          pointsColor: Colors.red,
          lineColor: Colors.green,
        ),
        const SizedBox(
          height: 20,
        ),
        Container(
          height: 50,
          width: 200,
          margin: EdgeInsets.symmetric(horizontal: 24),
          child: Row(
            children: [
              ElevatedButton(
                onPressed: () {
                  for (final List<Offset> offset in coordinates) {
                    for (int i = 0; i < offset.length; i++) {
                      polygonPoints.add(offset[i]);
                    }
                  }
                  Polygon polygon = Polygon(polygonPoints);
                  setState(() {
                    isInside = polygon.isPointInside(
                        Offset(selectedPositionX!, selectedPositionY!));
                    answer = isInside
                        ? 'Point is inside the polygon'
                        : 'Point is outside the polygon';
                    isSelectable = false;
                    correctAnswerCoordinates = coordinates;
                  });
                },
                child: Text('Submit'),
              ),
              const SizedBox(
                width: 30,
              ),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 24),
                child: ElevatedButton(
                  onPressed: () {
                    setState(() {
                      answer = '';
                      isSelectable = true;
                      correctAnswerCoordinates = [];
                      showPointer = false;
                    });
                  },
                  child: Text('Reset'),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(
          height: 20,
        ),
        Text(
          answer,
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 16),
        ),
      ],
    );
  }
}

class _DrawAreaExample extends StatefulWidget {
  @override
  __DrawAreaExampleState createState() => __DrawAreaExampleState();
}

class __DrawAreaExampleState extends State<_DrawAreaExample> {
  List<List<Offset>> selectedPositions = [[]];
  bool isSelectable = true;
  bool? isInside;
  double coordinateSizeX = 1;
  double coordinateSizeY = 1;
  double? selectedX;
  double? selectedY;
  bool showPointer = true;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          'Draw anywhere on the image',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 24),
        ),
        SizedBox(height: 10),
        DrawOnWidget(
          widget: _DrawOnImageWidget(),
          correctAnswerCoordinates: selectedPositions,
          getXaxis: (xAxis) {
            setState(() {
              selectedX = xAxis;
            });
          },
          getYaxis: (yAxis) {
            setState(() {
              selectedY = yAxis;
            });
          },
          showPointer: showPointer,
          coordinateSizeX: coordinateSizeX,
          coordinateSizeY: coordinateSizeY,
          onTap: () {
            setState(() {
              showPointer = true;
              if (selectedPositions.last.length > 3 &&
                  selectedPositions.last.first == selectedPositions.last.last) {
                selectedPositions.add([]);
              }
              coordinateSizeX = 1.0;
              coordinateSizeY = 1.0;
              Offset? nearestValue = Polygon.getNearestPoint(
                  selectedPositions.last, Offset(selectedX!, selectedY!));
              selectedPositions.last.add(Offset(selectedX!, selectedY!));
              if (nearestValue != null) {
                selectedPositions.last.add(nearestValue);
              }
              selectedX = null;
              selectedY = null;
            });
            print(selectedPositions);
          },
          pointsColor: Colors.green,
          lineColor: Colors.green,
        ),
        SizedBox(height: 15),
        Container(
          margin: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          height: 50,
          width: 200,
          child: Row(
            children: [
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    isSelectable = true;
                    selectedPositions.clear();
                    selectedPositions = [[]];
                    showPointer = false;
                  });
                },
                child: Text('Reset'),
              ),
              const SizedBox(
                width: 30,
              ),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    showPointer = false;
                    if (selectedPositions.isNotEmpty) {
                      if (selectedPositions.last.isNotEmpty)
                        selectedPositions.last.removeLast();
                      if (selectedPositions.last.isEmpty) {
                        selectedPositions.removeLast();
                      }
                    }
                  });
                },
                child: Text('Undo'),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
