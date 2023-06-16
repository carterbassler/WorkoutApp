import 'package:flutter/material.dart';
import 'package:workout_app/components/time/am_pm.dart';
import 'package:workout_app/components/time/hours.dart';
import 'package:workout_app/components/time/minutes.dart';

class TimeSelect extends StatefulWidget {
  final ValueChanged<String> onTimeChanged;
  final String time;
  TimeSelect({Key? key, required this.onTimeChanged, required this.time})
      : super(key: key);
  @override
  _TimeSelectState createState() => _TimeSelectState();
}

class _TimeSelectState extends State<TimeSelect> {
  int _selectedHoursIndex = 1;
  int _selectedMinsIndex = 0;
  int _selectedAmPmIndex = 0;
  FixedExtentScrollController? _hoursController;
  FixedExtentScrollController? _minsController;
  FixedExtentScrollController? _amPmController;

  @override
  void initState() {
    super.initState();
    String timeStr = widget.time;

    RegExp regExp = new RegExp(r"(\d+):(\d+) (AM|PM)");

    Match? match = regExp.firstMatch(timeStr);

    if (match != null) {
      String hourStr = match.group(1)!;
      String minuteStr = match.group(2)!;
      String periodStr = match.group(3)!;
      int hour = int.parse(hourStr);
      int min = int.parse(minuteStr);
      int period = periodStr == "AM" ? 0 : 1;
      _selectedHoursIndex = hour;
      _selectedMinsIndex = min;
      _selectedAmPmIndex = period;
      _hoursController = FixedExtentScrollController(initialItem: hour - 1);
      _minsController = FixedExtentScrollController(initialItem: min);
      _amPmController = FixedExtentScrollController(initialItem: period);
    }
  }

  void _onSelectedItemChanged() {
    final selectedTime =
        '${_selectedHoursIndex == 0 ? 12 : _selectedHoursIndex}:${_selectedMinsIndex.toString().padLeft(2, '0')} ${_selectedAmPmIndex == 0 ? 'AM' : 'PM'}';
    widget.onTimeChanged(
        selectedTime); // send selected time back to parent widget
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      color: Color(0xFF2E2C3A),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 70,
            child: ListWheelScrollView.useDelegate(
              controller : _hoursController,
              onSelectedItemChanged: (value) {
                setState(() {
                  _selectedHoursIndex =
                      value + 1; // add 1 to the selected hour index
                });
                _onSelectedItemChanged();
              },
              itemExtent: 50,
              perspective: 0.005,
              diameterRatio: 1.2,
              physics: FixedExtentScrollPhysics(),
              childDelegate: ListWheelChildBuilderDelegate(
                childCount: 12, // reduce childCount to 12
                builder: (context, index) {
                  return MyHours(
                    hours: index + 1, // add 1 to the hours index
                    isSelected: index + 1 ==
                        _selectedHoursIndex, // compare with index + 1
                  );
                },
              ),
            ),
          ),
          SizedBox(width: 10),
          Container(
            width: 70,
            child: ListWheelScrollView.useDelegate(
              controller : _minsController,
              onSelectedItemChanged: (value) {
                setState(() {
                  _selectedMinsIndex = value;
                });
                _onSelectedItemChanged();
              },
              itemExtent: 50,
              perspective: 0.005,
              diameterRatio: 1.2,
              physics: FixedExtentScrollPhysics(),
              childDelegate: ListWheelChildBuilderDelegate(
                childCount: 60,
                builder: (context, index) {
                  return MyMinutes(
                    mins: index,
                    isSelected: index == _selectedMinsIndex,
                  );
                },
              ),
            ),
          ),
          SizedBox(width: 10),
          Container(
            width: 70,
            child: ListWheelScrollView.useDelegate(
              controller: _amPmController,
              onSelectedItemChanged: (value) {
                setState(() {
                  _selectedAmPmIndex = value;
                });
                _onSelectedItemChanged();
              },
              itemExtent: 50,
              perspective: 0.005,
              diameterRatio: 1.2,
              physics: FixedExtentScrollPhysics(),
              childDelegate: ListWheelChildBuilderDelegate(
                childCount: 2,
                builder: (context, index) {
                  return AmPm(
                    isItAm: index == 0,
                    isSelected: index == _selectedAmPmIndex,
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
