import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_location_todo/model/task_model.dart';
import 'package:photo_view/photo_view.dart';
import 'package:positioned_tap_detector/positioned_tap_detector.dart';

class LocationImage extends StatefulWidget {
  List<Task> tasks;

  LocationImage(this.tasks);

  @override
  _LocationImageState createState() => _LocationImageState();
}

class _LocationImageState extends State<LocationImage> {
  double a = 100;
  double b = 100;
  PhotoViewController pController ;
  int touchedIndex;

  Color greyColor = Colors.grey;

  List<int> selectedSpots = [];

  int lastPanStartOnIndex = -1;

  @override
  void initState() {
    super.initState();
    pController = PhotoViewController();
  }

  @override
  void dispose() {
    super.dispose();
    pController.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      // 향후 PhotoView활용하여 확대 축소 Pan 기능 구현 필요
      child: AspectRatio(
        aspectRatio: 421 / 297,
        child: ClipRect(
          child: Card(
            child: Stack(
              children: [
                PhotoView.customChild(
                  controller: pController,
                  initialScale: 1.0,
                  minScale: 1.0,
                  maxScale: 5.0,
                  backgroundDecoration: BoxDecoration(color: Colors.white),
                  child: Stack(
                    children: [
                      Image.asset('asset/Plan2.png'),
                      StreamBuilder<PhotoViewControllerValue>(
                          stream: pController.outputStateStream,
                          builder: (BuildContext context, AsyncSnapshot<PhotoViewControllerValue> snapshot) {
                            if (!snapshot.hasData)
                              return Container();
                            return Stack( children: widget.tasks.where((e) => e.x != null).map((e) {
                              return Positioned(
                                left: e.x,
                                top: e.y,
                                child: Opacity(
                                  opacity: 0.8,
                                  child: Transform.scale(
                                    scale: (1/snapshot.data.scale)*2,
                                    //Task class favorite을 활용한 위치확인 기능 구현
                                    child: e.favorite == true
                                        ? Icon(
                                      Icons.pin_drop,
                                      color: Colors.red,
                                    )
                                        : Icon(Icons.pin_drop),
                                  ),
                                ),
                              );
                            }).toList());
                          }
                      ),
                      AspectRatio(
                        aspectRatio: 421/297,
                        child: ScatterChart(
                          ScatterChartData(
                            scatterSpots: [
                              ScatterSpot(
                                14,
                                14,
                                color: selectedSpots.contains(0) ? Colors.green : greyColor,
                              ),
                              ScatterSpot(
                                22,
                                25,
                                color: selectedSpots.contains(1) ? Colors.yellow : greyColor,
                                radius: 12,
                              ),
                              ScatterSpot(
                                34,
                                35,
                                color: selectedSpots.contains(2) ? Colors.purpleAccent : greyColor,
                                radius: 8,
                              ),
                              ScatterSpot(
                                48,
                                46,
                                color: selectedSpots.contains(3) ? Colors.orange : greyColor,
                                radius: 20,
                              ),
                              ScatterSpot(
                                55,
                                57,
                                color: selectedSpots.contains(4) ? Colors.brown : greyColor,
                                radius: 14,
                              ),
                              ScatterSpot(
                                67,
                                62,
                                color: selectedSpots.contains(5) ? Colors.lightGreenAccent : greyColor,
                                radius: 18,
                              ),
                              ScatterSpot(
                                73,
                                72,
                                color: selectedSpots.contains(6) ? Colors.red : greyColor,
                                radius: 36,
                              ),
                              ScatterSpot(
                                82,
                                88,
                                color: selectedSpots.contains(7) ? Colors.tealAccent : greyColor,
                                radius: 22,
                              ),
                            ],
                            minX: 0,
                            minY: 0,
                            maxX: 421,
                            maxY: 297,
                            borderData: FlBorderData(
                              show: true
                            ),
                            gridData: FlGridData(
                              show: true,
                              drawHorizontalLine: true,
                              checkToShowHorizontalLine: (value) => true,
                              getDrawingHorizontalLine: (value) => FlLine(color: Colors.white.withOpacity(0.1)),
                              drawVerticalLine: true,
                              checkToShowVerticalLine: (value) => true,
                              getDrawingVerticalLine: (value) => FlLine(color: Colors.white.withOpacity(0.1)),
                            ),
                            titlesData: FlTitlesData(
                              show: false,
                            ),
                            showingTooltipIndicators: selectedSpots,
                            scatterTouchData: ScatterTouchData(
                              enabled: true,
                              handleBuiltInTouches: false,
                              touchTooltipData: ScatterTouchTooltipData(
                                tooltipBgColor: Colors.black,
                              ),
                              touchCallback: (ScatterTouchResponse touchResponse) {
                                if (touchResponse.touchInput is FlPanStart) {
                                  lastPanStartOnIndex = touchResponse.touchedSpotIndex;
                                } else if (touchResponse.touchInput is FlPanEnd) {
                                  final FlPanEnd flPanEnd = touchResponse.touchInput;

                                  if (flPanEnd.velocity.pixelsPerSecond <= const Offset(4, 4)) {
                                    // Tap happened
                                    setState(() {
                                      if (selectedSpots.contains(lastPanStartOnIndex)) {
                                        selectedSpots.remove(lastPanStartOnIndex);
                                      } else {
                                        selectedSpots.add(lastPanStartOnIndex);
                                      }
                                    });
                                  }
                                }
                              },
                          ),
                        ),
                      ),
                      )],
                  ),
                ),
                
              ],
            ),
          ),
        ),
      ),
    );
  }
}
