import 'package:flutter/material.dart';
import 'package:mithran/screen/home-section/calendarpage.dart';
import '../../repositories/weatherprovider.dart';
import '../../widgets/charts/constructbarchart.dart';

class WeatherPage extends StatefulWidget {
  final WeatherProvider provider;
  WeatherPage({super.key, required this.provider});
  _WeatherPageState createState() => _WeatherPageState();
}

class _WeatherPageState extends State<WeatherPage> {
  // CalendarFormat _calendarFormat = CalendarFormat.month;
  // DateTime _focusedDay = DateTime.now();
  // DateTime? _selectedDay;
  List<String> timeArr = [];
  List<double> temperatureArr = [];

  @override
  void initState() {
    super.initState();
    for (int i = 0; i < widget.provider.foreCastList.length; i++) {
      timeArr.add(widget.provider.foreCastList[i].time);
    }
    for (int i = 0; i < widget.provider.foreCastList.length; i++) {
      temperatureArr.add(widget.provider.foreCastList[i].temperature);
    }
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
              "Weather Forecast",
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
      resizeToAvoidBottomInset: false,
      backgroundColor: const Color.fromRGBO(247, 247, 247, 1),
      body: Container(
        child: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20.0),
                Padding(
                  padding: const EdgeInsets.only(
                      left: 25.0, right: 25.0, bottom: 15.0),
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
                              const Padding(
                                  padding:
                                      EdgeInsets.only(left: 20.0, top: 20.0),
                                  child: Text(
                                    "Hows the Weather",
                                    style: TextStyle(
                                        fontFamily: "Poppins",
                                        fontWeight: FontWeight.w700,
                                        fontSize: 18.0),
                                  )),
                              const Padding(
                                  padding:
                                      EdgeInsets.only(left: 20.0, bottom: 20.0),
                                  child: Text("looking?🤔",
                                      style: TextStyle(
                                          fontFamily: "Poppins",
                                          fontWeight: FontWeight.w700,
                                          fontSize: 18.0))),
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
                                              "${(widget.provider.weatherData['rainPossibility'] * 100).toInt()}% chance",
                                              style: TextStyle(
                                                  fontFamily: "Poppins",
                                                  fontWeight: FontWeight.w600,
                                                  fontSize: 14.0)),
                                          Text(
                                              "${widget.provider.weatherData['rainMeasure']}mm rain",
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
                                              "${widget.provider.weatherData['humidity']}%",
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
                                              "${(widget.provider.weatherData['temperature']).toStringAsFixed(2)} C°",
                                              style: TextStyle(
                                                  fontFamily: "Poppins",
                                                  fontWeight: FontWeight.w600,
                                                  fontSize: 14.0)),
                                          Text(
                                              "Min ${(widget.provider.weatherData['minTemperature']).toStringAsFixed(2)} C°",
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
                                              "${widget.provider.weatherData['speed']} km/h",
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
                              const Padding(
                                  padding: EdgeInsets.only(
                                      left: 20.0, top: 40.0, bottom: 10.0),
                                  child: Text(
                                    "Hourly Forecast",
                                    style: TextStyle(
                                        fontFamily: "Poppins",
                                        fontWeight: FontWeight.w700,
                                        fontSize: 20.0),
                                  )),
                              Container(
                                height: 115.0,
                                child: ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  itemCount:
                                      widget.provider.foreCastList.length,
                                  itemBuilder: (context, index) {
                                    return Container(
                                      width: 60.0,
                                      padding: const EdgeInsets.only(
                                          top: 5.0, left: 8.0, right: 8.0),
                                      decoration: BoxDecoration(
                                        border: Border(
                                          right: BorderSide(
                                              color: Color(0xff39C0FF),
                                              width: 0.5),
                                        ),
                                        gradient: LinearGradient(
                                          begin: Alignment.topCenter,
                                          end: Alignment.bottomCenter,
                                          colors: [
                                            Color(0xFFE3F3FF), // #E3F3FF
                                            Color(0xFF90CFFF), // #90CFFF
                                          ],
                                          stops: [
                                            0.0,
                                            1.0
                                          ], // Corresponding to 0% and 100%
                                        ),
                                      ),
                                      child: Column(
                                        children: [
                                          const SizedBox(height: 15.0),
                                          Text(
                                              "${widget.provider.foreCastList[index].time}",
                                              style: const TextStyle(
                                                  fontFamily: "Poppins",
                                                  fontWeight: FontWeight.w500,
                                                  color: Color(0xff6B6B6B))),
                                          const SizedBox(height: 15.0),
                                          Container(
                                            child: Image.asset(
                                              'assets/weathericons/${widget.provider.foreCastList[index].icon}.png',
                                            ),
                                          ),
                                          const SizedBox(height: 15.0),
                                        ],
                                      ),
                                    );
                                  },
                                ),
                              ),
                              const SizedBox(height: 10.0),
                              const Padding(
                                padding:
                                    EdgeInsets.only(left: 25.0, bottom: 10.0),
                                child: Text("Temperature",
                                    style: TextStyle(
                                        fontFamily: "Poppins",
                                        fontWeight: FontWeight.w700,
                                        fontSize: 16.0)),
                              ),
                              ConstructBarChart(
                                  timeArr: timeArr,
                                  temperatureArr: temperatureArr),
                              const SizedBox(height: 14.0),
                              Padding(
                                  padding: EdgeInsets.only(
                                      left: 25.0, right: 10.0, bottom: 12.0),
                                  child: Text(widget.provider.dailySummary,
                                      style: TextStyle(
                                        fontFamily: "Poppins",
                                        fontWeight: FontWeight.w500,
                                        fontSize: 14.0,
                                        color: Color(0xff616161),
                                      ))),
                            ],
                          )
                        : Center(child: CircularProgressIndicator()),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 25.0, right: 25.0),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  CalendarPage(provider: widget.provider)));
                    },
                    child: Container(
                      padding: const EdgeInsets.only(top: 10.0, bottom: 10.0),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: const Color(0xffD2D5DA),
                          width: 2.0,
                        ),
                        borderRadius: BorderRadius.circular(12.0),
                        color: Colors.white,
                      ),
                      child: Row(children: [
                        const SizedBox(width: 10.0),
                        Image.asset('assets/homepage/calendar.png',
                            height: 60.0, width: 60.0),
                        const Spacer(),
                        const SizedBox(
                            width: 220.0,
                            child: Text(
                              "Check the weather forecast for the next 30 days.",
                              style: TextStyle(
                                fontFamily: "Poppins",
                                fontWeight: FontWeight.w600,
                                fontSize: 14.0,
                              ),
                            )),
                        const Spacer(),
                        const Icon(Icons.keyboard_arrow_right,
                            color: Color(0xff4F9EFF), size: 30.0),
                        const SizedBox(width: 10.0)
                      ]),
                    ),
                  ),
                ),
                const SizedBox(height: 20.0),
                // Container(
                //   padding: EdgeInsets.only(left: 25.0, right: 25.0),
                //   child: Container(
                //     decoration: BoxDecoration(
                //       color: Colors.white,
                //       borderRadius: BorderRadius.circular(10.0),
                //     ),
                //     child: TableCalendar(
                //       firstDay: DateTime.utc(2020, 1, 1),
                //       lastDay: DateTime.utc(2030, 12, 31),
                //       rowHeight: 100.0, // Adjusted rowHeight
                //       focusedDay: _focusedDay,
                //       calendarFormat: _calendarFormat,
                //       selectedDayPredicate: (day) {
                //         return isSameDay(_selectedDay, day);
                //       },
                //       onDaySelected: (selectedDay, focusedDay) {
                //         setState(() {
                //           _selectedDay = selectedDay;
                //           _focusedDay = focusedDay;
                //         });
                //       },
                //       onFormatChanged: (format) {
                //         setState(() {
                //           _calendarFormat = format;
                //         });
                //       },
                //       onPageChanged: (focusedDay) {
                //         _focusedDay = focusedDay;
                //       },
                //       availableCalendarFormats: const {
                //         CalendarFormat.month: 'Month',
                //       },
                //       headerStyle: HeaderStyle(
                //         formatButtonVisible: false,
                //         leftChevronVisible: true,
                //         rightChevronMargin: EdgeInsets.zero,
                //         titleCentered: true,
                //         titleTextStyle: TextStyle(
                //           fontSize: 20.0,
                //           fontWeight: FontWeight.bold,
                //         ),
                //       ),
                //       calendarBuilders: CalendarBuilders(
                //         defaultBuilder: (context, day, focusedDay) {
                //           DateTime today = DateTime.now();
                //           int index = day.difference(today).inDays;

                //           // Only show icons for today and future dates within the range of the icon list
                //           if (index >= 0 &&
                //               index <
                //                   widget
                //                       .provider.dailyForecastListIcons.length) {
                //             return GestureDetector(
                //               onTap: () {
                //                 setState(() {
                //                   _selectedDay = day;
                //                   _focusedDay = day;
                //                 });
                //               },
                //               child: Column(
                //                 mainAxisAlignment: MainAxisAlignment.start,
                //                 children: [
                //                   const SizedBox(height: 10.0),
                //                   Text(
                //                     '${day.day}',
                //                     style: TextStyle(
                //                       color: Colors.black,
                //                       fontFamily: "Poppins",
                //                       fontWeight: FontWeight.w700,
                //                     ),
                //                   ),
                //                   Image.asset(
                //                     'assets/weathericons/${widget.provider.dailyForecastListIcons[index]}.png',
                //                     height: 40,
                //                     width: 40,
                //                   ),
                //                 ],
                //               ),
                //             );
                //           } else {
                //             // Placeholder if no icon available
                //             return Column(
                //               mainAxisAlignment: MainAxisAlignment.start,
                //               children: [
                //                 const SizedBox(height: 10.0),
                //                 Text(
                //                   '${day.day}',
                //                   style: TextStyle(
                //                     color: Colors.black,
                //                     fontFamily: "Poppins",
                //                     fontWeight: FontWeight.w700,
                //                   ),
                //                 ),
                //                 const SizedBox(
                //                   height: 40,
                //                   width: 40,
                //                 ),
                //               ],
                //             );
                //           }
                //         },
                //         selectedBuilder: (context, day, focusedDay) {
                //           DateTime today = DateTime.now();
                //           int index = day.difference(today).inDays;

                //           // Only show selected icons for today and future dates within the range of the icon list
                //           if (index >= 0 &&
                //               index <
                //                   widget
                //                       .provider.dailyForecastListIcons.length) {
                //             return Container(
                //               decoration: BoxDecoration(
                //                 gradient: LinearGradient(
                //                   begin: Alignment.topCenter,
                //                   end: Alignment.bottomCenter,
                //                   colors: [
                //                     Color(0xFFE3F3FF), // #E3F3FF
                //                     Color(0xFF90CFFF), // #90CFFF
                //                   ],
                //                   stops: [0.0, 1.0],
                //                 ),
                //                 borderRadius: BorderRadius.circular(8.0),
                //               ),
                //               padding: EdgeInsets.all(8.0),
                //               child: Column(
                //                 mainAxisAlignment: MainAxisAlignment.start,
                //                 children: [
                //                   Text(
                //                     '${day.day}',
                //                     style: TextStyle(
                //                       color: Colors.black,
                //                       fontFamily: "Poppins",
                //                       fontWeight: FontWeight.w700,
                //                     ),
                //                   ),
                //                   const SizedBox(height: 5.0),
                //                   Image.asset(
                //                     'assets/weathericons/${widget.provider.dailyForecastListIcons[index]}.png',
                //                     height: 40,
                //                     width: 40,
                //                   ),
                //                 ],
                //               ),
                //             );
                //           } else {
                //             return Container(
                //               decoration: BoxDecoration(
                //                 gradient: LinearGradient(
                //                   begin: Alignment.topCenter,
                //                   end: Alignment.bottomCenter,
                //                   colors: [
                //                     Color(0xFFE3F3FF), // #E3F3FF
                //                     Color(0xFF90CFFF), // #90CFFF
                //                   ],
                //                   stops: [0.0, 1.0],
                //                 ),
                //                 borderRadius: BorderRadius.circular(8.0),
                //               ),
                //               padding: EdgeInsets.all(8.0),
                //               child: Column(
                //                 mainAxisAlignment: MainAxisAlignment.start,
                //                 children: [
                //                   Text(
                //                     '${day.day}',
                //                     style: TextStyle(
                //                       color: Colors.black,
                //                       fontFamily: "Poppins",
                //                       fontWeight: FontWeight.w700,
                //                     ),
                //                   ),
                //                   const SizedBox(height: 40, width: 40),
                //                 ],
                //               ),
                //             );
                //           }
                //         },
                //         todayBuilder: (context, day, focusedDay) {
                //           DateTime today = DateTime.now();
                //           int index = day.difference(today).inDays;

                //           // Only show today's icon within the range of the icon list
                //           if (index >= 0 &&
                //               index <
                //                   widget
                //                       .provider.dailyForecastListIcons.length) {
                //             return Container(
                //               decoration: BoxDecoration(
                //                 borderRadius: BorderRadius.circular(8.0),
                //                 gradient: LinearGradient(
                //                   begin: Alignment.topCenter,
                //                   end: Alignment.bottomCenter,
                //                   colors: [
                //                     Color(0xFFE3F3FF), // #E3F3FF
                //                     Color(0xFF90CFFF), // #90CFFF
                //                   ],
                //                   stops: [0.0, 1.0],
                //                 ),
                //               ),
                //               padding: EdgeInsets.all(8.0),
                //               child: Column(
                //                 mainAxisAlignment: MainAxisAlignment.start,
                //                 children: [
                //                   Text(
                //                     'Today',
                //                     style: TextStyle(
                //                       color: Colors.orange,
                //                       fontFamily: "Poppins",
                //                       fontWeight: FontWeight.bold,
                //                       fontSize: 10.0,
                //                     ),
                //                   ),
                //                   const SizedBox(height: 10.0),
                //                   Image.asset(
                //                     'assets/weathericons/${widget.provider.dailyForecastListIcons[index]}.png',
                //                     height: 40,
                //                     width: 40,
                //                   ),
                //                 ],
                //               ),
                //             );
                //           } else {
                //             return Container(
                //               decoration: BoxDecoration(
                //                 borderRadius: BorderRadius.circular(8.0),
                //                 gradient: LinearGradient(
                //                   begin: Alignment.topCenter,
                //                   end: Alignment.bottomCenter,
                //                   colors: [
                //                     Color(0xFFE3F3FF), // #E3F3FF
                //                     Color(0xFF90CFFF), // #90CFFF
                //                   ],
                //                   stops: [0.0, 1.0],
                //                 ),
                //               ),
                //               padding: EdgeInsets.all(8.0),
                //               child: Column(
                //                 mainAxisAlignment: MainAxisAlignment.start,
                //                 children: [
                //                   Text(
                //                     'Today',
                //                     style: TextStyle(
                //                       color: Colors.orange,
                //                       fontFamily: "Poppins",
                //                       fontWeight: FontWeight.bold,
                //                       fontSize: 10.0,
                //                     ),
                //                   ),
                //                   const SizedBox(height: 40, width: 40),
                //                 ],
                //               ),
                //             );
                //           }
                //         },
                //       ),
                //     ),
                //   ),
                // ),
                const SizedBox(height: 20.0),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
