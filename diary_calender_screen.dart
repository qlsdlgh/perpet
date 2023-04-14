import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:perpet/screens/diary_write_screen.dart';

class DiaryScreen extends StatefulWidget {
  const DiaryScreen({Key? key}) : super(key: key);

  @override
  State<DiaryScreen> createState() => _TableCalendarScreenState();
}

class _TableCalendarScreenState extends State<DiaryScreen> {
  DateTime selectedDay = DateTime(
    DateTime.now().year,
    DateTime.now().month,
    DateTime.now().day,
  );

  DateTime focusedDay = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.pink[100],
          title: const Text("Diary"),
          titleTextStyle: const TextStyle(color: Colors.white, fontSize: 25),
          toolbarHeight: 60,
          bottomOpacity: 20,
        ),
        body: SingleChildScrollView(
            child: Column(
          children: [
            ButtonBar(children: [
              IconButton(
                  onPressed: () {}, icon: const Icon(FontAwesomeIcons.home)),
              IconButton(
                  onPressed: () {}, icon: const Icon(FontAwesomeIcons.home)),
              IconButton(
                  onPressed: () {}, icon: const Icon(FontAwesomeIcons.home)),
            ]),
            Center(
              child: TableCalendar(
                firstDay: DateTime.utc(2021, 10, 16),
                lastDay: DateTime.utc(2030, 3, 14),
                focusedDay: focusedDay,
                headerStyle: HeaderStyle(
                  titleCentered: true,
                  titleTextFormatter: (date, locale) =>
                      DateFormat.yMMMM(locale).format(date),
                  formatButtonVisible: false,
                  titleTextStyle: const TextStyle(
                    fontSize: 20.0,
                    color: Colors.black87,
                  ),
                  headerPadding: const EdgeInsets.only(
                      //top: 20,
                      ),
                  headerMargin: const EdgeInsets.only(bottom: 20),
                  decoration: const BoxDecoration(
                      //color: Colors.white,
                      ),
                ),
                calendarStyle: const CalendarStyle(
                  //toDay
                  isTodayHighlighted: true,
                  todayTextStyle: TextStyle(
                    color: Colors.white,
                    fontSize: 16.0,
                  ),
                  todayDecoration: BoxDecoration(
                    color: Color(0xFFFCE4EC),
                    shape: BoxShape.circle,
                  ),

                  //selectDay
                  selectedTextStyle: TextStyle(
                    color: Colors.white,
                    fontSize: 16.0,
                  ),

                  selectedDecoration: BoxDecoration(
                    color: Color(0xFFF48FB1),
                    shape: BoxShape.circle,
                  ),
                ),
                onDaySelected: (DateTime selectedDay, DateTime focusedDay) {
                  // 선택된 날짜의 상태를 갱신합니다.
                  setState(() {
                    this.selectedDay = selectedDay;
                    this.focusedDay = focusedDay;

                    //일기 작성화면에 나타나는 일자
                    String formatDate =
                        DateFormat('yyyy. MM. dd.').format(focusedDay);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => WriteScreen(formatDate)),
                    );
                  });
                },
                selectedDayPredicate: (DateTime day) {
                  // selectedDay 와 동일한 날짜의 모양을 바꿔줍니다.
                  return isSameDay(selectedDay, day);
                },
              ),
            ),
            OutlinedButton(
              onPressed: () {
                setState(() {
                  selectedDay = DateTime.now();
                });
              },
              child: const Text('오늘'),
            )
          ],
        )));
  }
}
