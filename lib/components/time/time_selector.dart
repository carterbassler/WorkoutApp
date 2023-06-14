import 'package:flutter/material.dart';
import 'package:workout_app/components/time/am_pm.dart';
import 'package:workout_app/components/time/hours.dart';
import 'package:workout_app/components/time/minutes.dart';

class TimeSelect extends StatefulWidget {
  final ValueChanged<String> onTimeChanged;
  TimeSelect({Key? key, required this.onTimeChanged}) : super(key: key);

  @override
  _TimeSelectState createState() => _TimeSelectState();
}

class _TimeSelectState extends State<TimeSelect> {
  int _selectedHoursIndex = 0;
  int _selectedMinsIndex = 0;
  int _selectedAmPmIndex = 0;

  void _onSelectedItemChanged() {
  final selectedTime = '$_selectedHoursIndex:${_selectedMinsIndex.toString().padLeft(2, '0')} ${_selectedAmPmIndex == 0 ? 'AM' : 'PM'}';
  widget.onTimeChanged(selectedTime); // send selected time back to parent widget
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
              onSelectedItemChanged: (value) {
                setState(() {
                  _selectedHoursIndex = value;
                });
                _onSelectedItemChanged();
              },
              itemExtent: 50,
              perspective: 0.005,
              diameterRatio: 1.2,
              physics: FixedExtentScrollPhysics(),
              childDelegate: ListWheelChildBuilderDelegate(
                childCount: 13,
                builder: (context, index) {
                  index = index;
                  return MyHours(
                    hours: index,
                    isSelected: index == _selectedHoursIndex,
                  );
                },
              ),
            ),
          ),
          SizedBox(width: 10),
          Container(
            width: 70,
            child: ListWheelScrollView.useDelegate(
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