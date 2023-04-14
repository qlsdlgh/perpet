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
  var count = 0;

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
              //사용자가 입력한 동물이 여러마리일 때
              //캘린더에서 각 동물을 분리하여 보고 싶을 때 사용하는 버튼
              //나중에 사용될 땐 토글 버튼으로 바꾸어야함
              //테스터에선 일단 3개로 두었다.
              IconButton(
                  onPressed: () {
                    //나중에 누르면 해당 버튼에 할당 된 동물의 정보만
                    //캘린더에 띄울 수 있도록 해야한다.
                  },
                  icon: const Icon(FontAwesomeIcons.home)),
              IconButton(
                  onPressed: () {
                    //나중에 누르면 해당 버튼에 할당 된 동물의 정보만
                    //캘린더에 띄울 수 있도록 해야한다.
                  },
                  icon: const Icon(FontAwesomeIcons.home)),
              IconButton(
                  onPressed: () {
                    //나중에 누르면 해당 버튼에 할당 된 동물의 정보만
                    //캘린더에 띄울 수 있도록 해야한다.
                  },
                  icon: const Icon(FontAwesomeIcons.home)),
            ]),
            Center(
              //캘린더
              child: TableCalendar(
                firstDay: DateTime.utc(2021, 10, 16),
                lastDay: DateTime.now(),
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
                    //일자를 표기하는 형식을 바꾸고 싶을 땐,
                    //DateFormat의 ()안을 변경하면 됨
                    String formatDate =
                        DateFormat('yyyy. MM. dd.').format(focusedDay);
                    if (count == 1) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => WriteScreen(formatDate)),
                      );
                      count--;
                    } else {
                      count++;
                    }
                  });
                },
                selectedDayPredicate: (DateTime day) {
                  // selectedDay 와 동일한 날짜의 모양을 바꿔줍니다.
                  return isSameDay(selectedDay, day);
                },
              ),
            ),
            OutlinedButton(
              //오늘 버튼
              onPressed: () {
                //버튼을 눌렀을 때 오늘 날짜가 존재하는 달로 이동한다.
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
