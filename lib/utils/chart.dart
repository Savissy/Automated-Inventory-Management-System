import 'dart:async';
import 'dart:math';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class BarChartSample1 extends StatefulWidget {
  BarChartSample1(
      {super.key,
      required this.clients_value,
      required this.assets_value,
      required this.categories_value,
      required this.user_value,
      required this.financial_analysis_value});
  final int clients_value;
  final int assets_value;
  final int categories_value;
  final int user_value;
  final int financial_analysis_value;

  List<Color> get availableColors => const <Color>[
        Colors.purple,
        Colors.yellow,
        Colors.blue,
        Colors.orange,
        Colors.pink,
        Colors.red,
      ];

  final Color barBackgroundColor = Color.fromARGB(255, 255, 255, 255);
  final Color barColor = Color.fromARGB(255, 247, 222, 2);
  final Color touchedBarColor = const Color.fromARGB(255, 0, 185, 6);

  @override
  State<StatefulWidget> createState() => BarChartSample1State(
      categories_value: categories_value,
      clients_value: clients_value,
      financial_analysis_value: financial_analysis_value,
      assets_value: assets_value,
      user_value: user_value);
}

class BarChartSample1State extends State<BarChartSample1> {
  BarChartSample1State(
      {required this.clients_value,
      required this.assets_value,
      required this.categories_value,
      required this.user_value,
      required this.financial_analysis_value});
  final Duration animDuration = Duration(milliseconds: 250);
  final int clients_value;
  final int assets_value;
  final int categories_value;
  final int user_value;
  final int financial_analysis_value;

  int touchedIndex = -1;
  bool isPlaying = false;

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1,
      child: Stack(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Center(
                  child: const Text(
                    'Khan Sons Textile & Spinning Mill',
                    style: TextStyle(
                      color: Color.fromARGB(255, 255, 255, 255),
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 4),
                const SizedBox(height: 38),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 14),
                    child: BarChart(
                      isPlaying ? randomData() : mainBarData(),
                      swapAnimationDuration: animDuration,
                    ),
                  ),
                ),
                const SizedBox(height: 12),
              ],
            ),
          ),
        ],
      ),
    );
  }

  BarChartGroupData makeGroupData(
    int x,
    double y, {
    bool isTouched = false,
    Color? barColor,
    double width = 33,
    List<int> showTooltips = const [],
  }) {
    barColor ??= widget.barColor;
    return BarChartGroupData(
      x: x,
      barRods: [
        BarChartRodData(
          toY: isTouched ? y + 1 : y,
          color: isTouched ? widget.touchedBarColor : barColor,
          width: width,
          borderSide: isTouched
              ? BorderSide(color: Color.fromARGB(255, 110, 155, 6))
              : const BorderSide(color: Color.fromARGB(255, 126, 37, 37), width: 0),
          backDrawRodData: BackgroundBarChartRodData(
            show: true,
            toY: 100,
            color: widget.barBackgroundColor,
          ),
        ),
      ],
      showingTooltipIndicators: showTooltips,
    );
  }

  List<BarChartGroupData> showingGroups() => List.generate(5, (i) {
        switch (i) {
          case 0:
            return makeGroupData(0, assets_value.toDouble(),
                isTouched: i == touchedIndex);
          case 1:
            return makeGroupData(1, clients_value.toDouble(),
                isTouched: i == touchedIndex);
          case 2:
            return makeGroupData(2, categories_value.toDouble(),
                isTouched: i == touchedIndex);
          case 3:
            return makeGroupData(3, user_value.toDouble(),
                isTouched: i == touchedIndex);
          case 4:
            return makeGroupData(4, financial_analysis_value.toDouble(),
                isTouched: i == touchedIndex);
          default:
            return throw Error();
        }
      });

  BarChartData mainBarData() {
    return BarChartData(
      barTouchData: BarTouchData(
        touchTooltipData: BarTouchTooltipData(
          tooltipBgColor: Colors.blueGrey,
          tooltipHorizontalAlignment: FLHorizontalAlignment.right,
          tooltipMargin: -10,
          getTooltipItem: (group, groupIndex, rod, rodIndex) {
            String weekDay;
            switch (group.x) {
              case 0:
                weekDay = 'Assets';
                break;
              case 1:
                weekDay = 'Clients';
                break;
              case 2:
                weekDay = 'Category';
                break;
              case 3:
                weekDay = 'User';
                break;
              case 4:
                weekDay = 'Financial Analysis';
                break;
              default:
                throw Error();
            }
            return BarTooltipItem(
              '$weekDay\n',
              const TextStyle(
                color: Color.fromARGB(255, 15, 3, 3),
                fontWeight: FontWeight.bold,
                fontSize: 15,
              ),
              children: <TextSpan>[
                TextSpan(
                  text: (rod.toY - 1).toString(),
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            );
          },
        ),
        touchCallback: (FlTouchEvent event, barTouchResponse) {
          setState(() {
            if (!event.isInterestedForInteractions ||
                barTouchResponse == null ||
                barTouchResponse.spot == null) {
              touchedIndex = -1;
              return;
            }
            touchedIndex = barTouchResponse.spot!.touchedBarGroupIndex;
          });
        },
      ),
      titlesData: FlTitlesData(
        show: true,
        rightTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        topTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            getTitlesWidget: getTitles,
            reservedSize: 38,
          ),
        ),
        leftTitles: const AxisTitles(
          sideTitles: SideTitles(
            showTitles: false,
          ),
        ),
      ),
      borderData: FlBorderData(show: false),
      barGroups: showingGroups(),
      gridData: const FlGridData(show: false),
    );
  }

  Widget getTitles(double value, TitleMeta meta) {
    const style = TextStyle(
      color: Color.fromARGB(255, 243, 243, 243),
      fontWeight: FontWeight.bold,
      fontSize: 12,
    );
    Widget text;
    switch (value.toInt()) {
      case 0:
        text = const Text('Assets', style: style);
        break;
      case 1:
        text = const Text('Clients', style: style);
        break;
      case 2:
        text = const Text('Categories', style: style);
        break;
      case 3:
        text = const Text('User', style: style);
        break;
      case 4:
        text = const Text('Financial Analysis', style: style);
        break;
      default:
        text = const Text('', style: style);
        break;
    }
    return SideTitleWidget(
      axisSide: meta.axisSide,
      space: 16,
      child: text,
    );
  }

  BarChartData randomData() {
    return BarChartData(
      barTouchData: BarTouchData(enabled: false),
      titlesData: FlTitlesData(
        show: true,
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            getTitlesWidget: getTitles,
            reservedSize: 38,
          ),
        ),
        leftTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        topTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        rightTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
      ),
      borderData: FlBorderData(show: false),
      barGroups: List.generate(5, (i) {
        return makeGroupData(
          i,
          Random().nextInt(15).toDouble() + 6,
          barColor: widget.availableColors[
              Random().nextInt(widget.availableColors.length)],
        );
      }),
      gridData: const FlGridData(show: false),
    );
  }

  Future<dynamic> refreshState() async {
    setState(() {});
    await Future<dynamic>.delayed(
      animDuration + const Duration(milliseconds: 50),
    );
    if (isPlaying) {
      await refreshState();
    }
  }
}
