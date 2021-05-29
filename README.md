# Draw On

A flutter plugin to draw the coordinates on the widget and as well as to find the given point is inside a list of coordinates or not.


## For Draw on widget 

```
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
    onTap: () {
    setState(() {
        showPointer = true;
        if (selectedPositions.last.length > 3 &&
            selectedPositions.last.first == selectedPositions.last.last) {
        selectedPositions.add([]);
        }
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
```

## For Select Area Widget

```
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
    onTap: () {
    setState(() {
        showPointer = true;
    });
    },
    pointsColor: Colors.red,
    lineColor: Colors.green,
),
```


## To find nearest point

```
Polygon.getNearestPoint(points, currentPoints);
```





## To find whether the given point is inside the coordinates

```
Polygon polygon = Polygon(polygonPoints);
isInside = polygon.isPointInside(Offset(xAxis, yAxis));
```



## Demo

<img src="assets/demo.gif" alt="example">