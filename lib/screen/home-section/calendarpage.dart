import 'package:flutter/material.dart';
import 'package:mithran/repositories/weatherprovider.dart';
import 'package:table_calendar/table_calendar.dart';

class CalendarPage extends StatefulWidget {
  final WeatherProvider provider;
  const CalendarPage({super.key, required this.provider});
  _CalendarPageState createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime currentDate = DateTime.now();
  DateTime? _selectedDay;

  @override
  void initState() {
    super.initState();
    _selectedDay = DateTime.now();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            icon: const Icon(Icons.chevron_left, size: 40),
            onPressed: () {
              Navigator.pop(context);
            }),
        title: const Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              "Daily Forecast",
              style:
                  TextStyle(fontFamily: "Poppins", fontWeight: FontWeight.w600),
            ),
          ],
        ),
        elevation: 2,
        backgroundColor: Colors.white,
        shadowColor: Colors.black,
        titleSpacing: 0,
      ),
      backgroundColor: const Color.fromRGBO(247, 247, 247, 1),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 20.0),
          Container(
            padding: EdgeInsets.only(left: 20.0, right: 20.0),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(
                  color: const Color(0xffD2D5DA),
                  width: 2.0,
                ),
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: TableCalendar(
                firstDay: DateTime.utc(2020, 1, 1),
                lastDay: DateTime.utc(2030, 12, 31),
                rowHeight: 82.0, // Adjusted rowHeight
                focusedDay: _focusedDay,
                calendarFormat: _calendarFormat,
                selectedDayPredicate: (day) {
                  return isSameDay(_selectedDay, day);
                },
                onDaySelected: (selectedDay, focusedDay) {
                  setState(() {
                    _selectedDay = selectedDay;
                    _focusedDay = focusedDay;
                  });
                },
                onFormatChanged: (format) {
                  setState(() {
                    _calendarFormat = format;
                  });
                },
                onPageChanged: (focusedDay) {
                  _focusedDay = focusedDay;
                },
                availableCalendarFormats: const {
                  CalendarFormat.month: 'Month',
                },
                headerStyle: HeaderStyle(
                  formatButtonVisible: false,
                  leftChevronVisible: true,
                  rightChevronMargin: EdgeInsets.zero,
                  titleCentered: true,
                  titleTextStyle: TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                calendarBuilders: CalendarBuilders(
                  defaultBuilder: (context, day, focusedDay) {
                    DateTime today = DateTime.now();
                    int index = day.difference(today).inDays;

                    // Only show icons for today and future dates within the range of the icon list
                    if (index >= 0 &&
                        index < widget.provider.dailyForecastListIcons.length) {
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            _selectedDay = day;
                            _focusedDay = day;
                          });
                        },
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            const SizedBox(height: 10.0),
                            Text(
                              '${day.day}',
                              style: TextStyle(
                                color: Colors.black,
                                fontFamily: "Poppins",
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            const SizedBox(height: 3.0),
                            Image.asset(
                              'assets/weathericons/${widget.provider.dailyForecastListIcons[index]}.png',
                              height: 40,
                              width: 40,
                            ),
                          ],
                        ),
                      );
                    } else {
                      // Placeholder if no icon available
                      return Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          const SizedBox(height: 10.0),
                          Text(
                            '${day.day}',
                            style: TextStyle(
                              color: Colors.black,
                              fontFamily: "Poppins",
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(
                            height: 40,
                            width: 40,
                          ),
                        ],
                      );
                    }
                  },
                  selectedBuilder: (context, day, focusedDay) {
                    DateTime today = DateTime.now();
                    int index = day.difference(today).inDays;

                    // Only show selected icons for today and future dates within the range of the icon list
                    if (index >= 0 &&
                        index < widget.provider.dailyForecastListIcons.length) {
                      return Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Color(0xFFE3F3FF), // #E3F3FF
                              Color(0xFF90CFFF), // #90CFFF
                            ],
                            stops: [0.0, 1.0],
                          ),
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        padding: EdgeInsets.all(8.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            const SizedBox(height: 2.0),
                            Text(
                              '${day.day}',
                              style: TextStyle(
                                color: isSameDay(day, today)
                                    ? Colors.orange
                                    : Colors.black,
                                fontFamily: "Poppins",
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            const SizedBox(height: 3.0),
                            Image.asset(
                              'assets/weathericons/${widget.provider.dailyForecastListIcons[index]}.png',
                              height: 40,
                              width: 40,
                            ),
                          ],
                        ),
                      );
                    } else {
                      return Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Color(0xFFE3F3FF), // #E3F3FF
                              Color(0xFF90CFFF), // #90CFFF
                            ],
                            stops: [0.0, 1.0],
                          ),
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        padding: EdgeInsets.all(8.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              '${day.day}',
                              style: TextStyle(
                                color: Colors.black,
                                fontFamily: "Poppins",
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            const SizedBox(height: 40, width: 40),
                          ],
                        ),
                      );
                    }
                  },
                  todayBuilder: (context, day, focusedDay) {
                    DateTime today = DateTime.now();
                    int index = day.difference(today).inDays;

                    // Only show today's icon within the range of the icon list
                    if (index >= 0 &&
                        index < widget.provider.dailyForecastListIcons.length) {
                      return Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8.0),
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Color(0xFFE3F3FF), // #E3F3FF
                              Color(0xFF90CFFF), // #90CFFF
                            ],
                            stops: [0.0, 1.0],
                          ),
                        ),
                        padding: EdgeInsets.all(8.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              'Today',
                              style: TextStyle(
                                color: Colors.orange,
                                fontFamily: "Poppins",
                                fontWeight: FontWeight.bold,
                                fontSize: 10.0,
                              ),
                            ),
                            const SizedBox(height: 10.0),
                            Image.asset(
                              'assets/weathericons/${widget.provider.dailyForecastListIcons[index]}.png',
                              height: 40,
                              width: 40,
                            ),
                          ],
                        ),
                      );
                    } else {
                      return Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8.0),
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Color(0xFFE3F3FF), // #E3F3FF
                              Color(0xFF90CFFF), // #90CFFF
                            ],
                            stops: [0.0, 1.0],
                          ),
                        ),
                        padding: EdgeInsets.all(8.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              'Today',
                              style: TextStyle(
                                color: Colors.orange,
                                fontFamily: "Poppins",
                                fontWeight: FontWeight.bold,
                                fontSize: 10.0,
                              ),
                            ),
                            const SizedBox(height: 40, width: 40),
                          ],
                        ),
                      );
                    }
                  },
                ),
              ),
            ),
          ),
          SizedBox(
            height: 30,
          ),
          if(_selectedDay!.difference(currentDate).inDays >= 0 && _selectedDay!.difference(currentDate).inDays < widget.provider.dailyForecastList.length)
          Padding(
              padding:
                  const EdgeInsets.only(left: 20.0, right: 20.0, bottom: 15.0),
              child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: const Color(0xffD2D5DA),
                      width: 2.0,
                    ),
                    borderRadius: BorderRadius.circular(10.0),
                    color: const Color(0xffFFFFFF),
                  ),
                  child: !widget.provider.isLoading
                      ? Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                              Padding(
                                  padding:
                                      EdgeInsets.only(left: 20.0, top: 20.0),
                                  child: Text(
                                    "Weather Report (${_selectedDay.toString().split(" ")[0]})",
                                    style: TextStyle(
                                        fontFamily: "Poppins",
                                        fontWeight: FontWeight.w700,
                                        fontSize: 18.0),
                                  )),
                              SizedBox(
                                height: 20,
                              ),
                              Row(
                                children: [
                                  const Spacer(),
                                  Row(children: [
                                    Image.asset('assets/homepage/rain.png',
                                        height: 40, width: 40),
                                    const SizedBox(width: 15.0),
                                    SizedBox(
                                      width: 100.0,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                              "${(widget.provider.dailyForecastList[_selectedDay!.difference(currentDate).inDays]['rainPossibility']).toInt()}% chance",
                                              style: TextStyle(
                                                  fontFamily: "Poppins",
                                                  fontWeight: FontWeight.w600,
                                                  fontSize: 14.0)),
                                          Text(
                                              "${widget.provider.dailyForecastList[_selectedDay!.difference(currentDate).inDays]['rainMeasure']}mm rain",
                                              style: TextStyle(
                                                  fontFamily: "Poppins",
                                                  color: Color(0xff848484),
                                                  fontWeight: FontWeight.w500,
                                                  fontSize: 12.0)),
                                        ],
                                      ),
                                    ),
                                  ]),
                                  const Spacer(),
                                  Row(children: [
                                    Image.asset('assets/homepage/humidity.png',
                                        height: 40, width: 40),
                                    const SizedBox(width: 15.0),
                                    SizedBox(
                                      width: 100.0,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                              "${widget.provider.dailyForecastList[_selectedDay!.difference(currentDate).inDays]['humidity']}%",
                                              style: TextStyle(
                                                  fontFamily: "Poppins",
                                                  fontWeight: FontWeight.w600,
                                                  fontSize: 14.0)),
                                          Text("Humidity",
                                              style: TextStyle(
                                                  fontFamily: "Poppins",
                                                  color: Color(0xff848484),
                                                  fontWeight: FontWeight.w500,
                                                  fontSize: 12.0)),
                                        ],
                                      ),
                                    ),
                                  ]),
                                  const Spacer(),
                                ],
                              ),
                              const SizedBox(height: 20.0),
                              Row(
                                children: [
                                  const Spacer(),
                                  Row(children: [
                                    Image.asset('assets/homepage/temp.png',
                                        height: 40, width: 40),
                                    const SizedBox(width: 15.0),
                                    SizedBox(
                                      width: 100.0,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                              "${(widget.provider.dailyForecastList[_selectedDay!.difference(currentDate).inDays]['temperature']).toStringAsFixed(2)} C°",
                                              style: TextStyle(
                                                  fontFamily: "Poppins",
                                                  fontWeight: FontWeight.w600,
                                                  fontSize: 14.0)),
                                          Text(
                                              "Min ${(widget.provider.dailyForecastList[_selectedDay!.difference(currentDate).inDays]['minTemperature']).toStringAsFixed(2)} C°",
                                              style: TextStyle(
                                                  fontFamily: "Poppins",
                                                  color: Color(0xff848484),
                                                  fontWeight: FontWeight.w500,
                                                  fontSize: 12.0)),
                                        ],
                                      ),
                                    ),
                                  ]),
                                  const Spacer(),
                                  Row(children: [
                                    Image.asset('assets/homepage/wind.png',
                                        height: 40, width: 40),
                                    const SizedBox(width: 15.0),
                                    SizedBox(
                                      width: 100.0,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                              "${widget.provider.dailyForecastList[_selectedDay!.difference(currentDate).inDays]['speed']} km/h",
                                              style: TextStyle(
                                                  fontFamily: "Poppins",
                                                  fontWeight: FontWeight.w600,
                                                  fontSize: 14.0)),
                                          Text("Wind",
                                              style: TextStyle(
                                                  fontFamily: "Poppins",
                                                  color: Color(0xff848484),
                                                  fontWeight: FontWeight.w500,
                                                  fontSize: 12.0)),
                                        ],
                                      ),
                                    ),
                                  ]),
                                  const Spacer(),
                                ],
                              ),
                              SizedBox(
                                height: 20,
                              )
                            ])
                      : SizedBox(height: 0)))
        ],
      ),
    );
  }
}
