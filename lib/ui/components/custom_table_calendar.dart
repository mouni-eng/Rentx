import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:rentx/size_config.dart';
import 'package:rentx/ui/base_widget.dart';
import 'package:table_calendar/table_calendar.dart';

class CalendarEvent {}

class CustomTableCalendar extends StatelessWidget {
  const CustomTableCalendar(
      {Key? key,
      this.selectedDay,
      this.startDay,
      this.endDay,
      this.focusedDay,
      required this.onChangeFormat,
      required this.onChangeRange,
      required this.onChangeDay,
      required this.rangeSelectionMode,
      required this.calendarFormat})
      : super(key: key);

  final DateTime? selectedDay, startDay, endDay, focusedDay;
  final Function(CalendarFormat) onChangeFormat;
  final Function(DateTime?, DateTime?, DateTime) onChangeRange;
  final Function(DateTime, DateTime) onChangeDay;
  final RangeSelectionMode rangeSelectionMode;
  final CalendarFormat calendarFormat;

  @override
  Widget build(BuildContext context) {
    return RentXWidget(
      builder: (rentxcontext) => TableCalendar<CalendarEvent>(
        firstDay: DateTime.now(),
        lastDay: DateTime(2900, 9, 10),
        shouldFillViewport: true,
        calendarStyle: CalendarStyle(
          todayTextStyle: TextStyle(
            fontSize: width(14),
            color: rentxcontext.theme.customTheme.onPrimary,
          ),
          todayDecoration: BoxDecoration(
            color: rentxcontext.theme.customTheme.headline3,
            shape: BoxShape.circle,
          ),
          selectedTextStyle: TextStyle(
            fontSize: width(14),
            color: rentxcontext.theme.customTheme.headdline,
          ),
          selectedDecoration: BoxDecoration(
            color: rentxcontext.theme.customTheme.primary,
            shape: BoxShape.circle,
          ),
          rangeStartDecoration: BoxDecoration(
            color: rentxcontext.theme.customTheme.primary,
            shape: BoxShape.circle,
          ),
          rangeEndDecoration: BoxDecoration(
            color: rentxcontext.theme.customTheme.primary,
            shape: BoxShape.circle,
          ),
          rangeStartTextStyle: TextStyle(
            fontSize: width(14),
            color: rentxcontext.theme.customTheme.onPrimary,
          ),
          withinRangeTextStyle: TextStyle(
            fontSize: width(14),
            color: rentxcontext.theme.customTheme.onPrimary,
          ),
          rangeEndTextStyle: TextStyle(
            fontSize: width(14),
            color: rentxcontext.theme.customTheme.onPrimary,
          ),
          rangeHighlightColor: rentxcontext.theme.customTheme.primary,
        ),
        headerStyle: HeaderStyle(
          titleCentered: true,
          formatButtonShowsNext: false,
          formatButtonVisible: false,
          titleTextStyle: TextStyle(
            fontSize: width(16),
            color: rentxcontext.theme.customTheme.headdline,
            fontWeight: FontWeight.w600,
          ),
          rightChevronMargin: EdgeInsets.zero,
          leftChevronMargin: EdgeInsets.zero,
          rightChevronIcon: Icon(
            Icons.chevron_right,
            color: rentxcontext.theme.customTheme.primary,
          ),
          leftChevronIcon: Icon(
            Icons.chevron_left,
            color: rentxcontext.theme.customTheme.primary,
          ),
        ),
        daysOfWeekStyle: DaysOfWeekStyle(
            weekdayStyle: TextStyle(
              color: rentxcontext.theme.customTheme.primary,
              fontSize: width(14),
            ),
            weekendStyle: TextStyle(
              color: rentxcontext.theme.customTheme.primary,
              fontSize: width(14),
            ),
            dowTextFormatter: (date, locale) =>
                DateFormat.E(locale).format(date)[0]),
        focusedDay: focusedDay!,
        selectedDayPredicate: (day) => isSameDay(selectedDay, day),
        rangeStartDay: startDay,
        rangeEndDay: endDay,
        calendarFormat: calendarFormat,
        rangeSelectionMode: rangeSelectionMode,
        onDaySelected: (selectedDay, focusedDay) {
          /*if (!isSameDay(cubit.selectedDay, selectedDay)) {
            cubit.chooseDate(selectedDay, focusedDay);
          }*/
          onChangeDay(selectedDay, focusedDay);
        },
        enabledDayPredicate: (DateTime time) =>
            isSameDay(time, DateTime.now()) || time.isAfter(DateTime.now()),
        onRangeSelected: (start, end, focusedDay) {
          onChangeRange(start, end, focusedDay);
        },
        onFormatChanged: (format) {
          onChangeFormat(format);
        },
      ),
    );
  }
}
