import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart'
    as picker;
import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:intl/intl.dart';

class InsertScreen extends StatefulWidget {
  const InsertScreen({super.key});

  @override
  State<InsertScreen> createState() => _InsertScreenState();
}

class _InsertScreenState extends State<InsertScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _writerController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();
  final TextEditingController _strdateController = TextEditingController();
  final TextEditingController _enddateController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();

  String _type = "무료홍보";

  // 달력 설정
  List<DateTime> _dateDefaultValue = [DateTime.now()];

  final config = CalendarDatePicker2Config(
    // 캘린더 타입 : single, multi, range
    calendarType: CalendarDatePicker2Type.range,
    selectedDayHighlightColor: Color.fromARGB(255, 255, 226, 98),
    weekdayLabels: ['일', '월', '화', '수', '목', '금', '토'],
    weekdayLabelTextStyle: const TextStyle(
      color: Colors.black87,
      fontWeight: FontWeight.bold,
    ),
    firstDayOfWeek: 0, // 시작 요일 : 0 (일), 1(월)
    controlsHeight: 50, // 높이 사이즈
    controlsTextStyle: const TextStyle(
      color: Colors.black,
      fontSize: 15,
      fontWeight: FontWeight.bold,
    ),
    dayTextStyle: const TextStyle(
      color: Colors.black,
      fontWeight: FontWeight.bold,
    ),
    disabledDayTextStyle: const TextStyle(
      color: Colors.grey,
    ),
    // 선택 가능한 날짜 설정
    selectableDayPredicate: (day) => !day // !를 붙여서 선택 불가능한 날짜 지정 가능
        .difference(DateTime.now().subtract(const Duration(days: 1)))
        .isNegative,
  );

  Future<void> insert() async {
    if (_formKey.currentState!.validate()) {
      var url = "http://10.0.2.2:8080/starCard";
      // var url = "http://localhost:8080/starCard";
      try {
        var response = await http.post(
          Uri.parse(url),
          headers: {"Content-Type": "application/json"},
          body: jsonEncode({
            'title': _titleController.text,
            'content': _contentController.text,
            'start_date': _strdateController.text,
            'user_no': "1",
            'writer': "test"
          }),
        );
        print("::::: response - body :::::");
        print(response.body);

        if (response.statusCode == 200 || response.statusCode == 201) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('게시글 등록 성공!'),
              backgroundColor: Colors.blueAccent,
            ),
          );
          Navigator.pushReplacementNamed(context, "/board/list");
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('게시글 등록 실패...'),
              backgroundColor: Colors.redAccent,
            ),
          );
        }
      } catch (e) {
        print(e);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('에러: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("홍보글 작성"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            // 홍보 타입
            Row(
              children: [
                Text("타입"),
                Radio(
                    value: "무료홍보",
                    groupValue: _type,
                    onChanged: (value) {
                      setState(() {
                        _type = value.toString();
                      });
                    }),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      _type = "무료홍보";
                    });
                  },
                  child: Text("무료홍보"),
                ),
                Radio(
                    value: "유료홍보",
                    groupValue: _type,
                    onChanged: (value) {
                      setState(() {
                        _type = value.toString();
                      });
                    }),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      _type = "유료홍보";
                    });
                  },
                  child: Text("유료홍보"),
                ),
                Radio(
                    value: "디자인 의뢰",
                    groupValue: _type,
                    onChanged: (value) {
                      setState(() {
                        _type = value.toString();
                      });
                    }),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      _type = "디자인 의뢰";
                    });
                  },
                  child: Text("디자인 의뢰"),
                )
              ],
            ),
            // 큰 달력
            // Column(
            //   children: [

            //     TextFormField(
            //         controller: _dateController,
            //         decoration: InputDecoration(labelText: "홍보 기간")),
            //     CalendarDatePicker2(
            //       config: config,
            //       value: _dateDefaultValue,
            //       onValueChanged: (dates) {
            //         print("선택된 날짜 : $dates ");
            //         setState(() {
            //           _dateDefaultValue = dates;
            //         });
            //       },
            //     ),
            //   ],
            // ),

            // 납작한 달력
            Column(
              children: [
                TextFormField(
                    controller: _strdateController,
                    readOnly: true,
                    decoration: InputDecoration(
                        labelText: "홍보 시작일",
                        suffixIcon: GestureDetector(
                          onTap: () {
                            print("홍보 시작일 입력");
                            picker.DatePicker.showDatePicker(context,
                                showTitleActions: true,
                                minTime: DateTime.now(),
                                maxTime: DateTime(2024, 12, 31),
                                theme: const picker.DatePickerTheme(
                                    headerColor:
                                        Color.fromARGB(255, 154, 184, 212),
                                    backgroundColor:
                                        Color.fromARGB(255, 255, 255, 255),
                                    itemStyle: TextStyle(
                                        color: Color.fromARGB(255, 46, 46, 46),
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18),
                                    doneStyle: TextStyle(
                                        color: Color.fromARGB(255, 97, 97, 97),
                                        fontSize: 16)), onChanged: (date) {
                              print('change $date in time zone ' +
                                  date.timeZoneOffset.inHours.toString());
                              print("홍보 시작일 : ${_strdateController.text}");
                              print(date);
                            }, onConfirm: (date) {
                              print('confirm $date');
                              print("date : $date");
                              // date : 2024-01-17 00:0:00.000
                              // ⬇ 변환
                              // text : 2024/01/17
                              var dateFormat =
                                  DateFormat('yyyy/MM/dd').format(date);

                              // "yyyy/MM/dd" 날짜 형식으로 지정
                              _strdateController.text = dateFormat;
                            },
                                currentTime: DateTime.now(),
                                locale: picker.LocaleType.ko);
                          },
                          child: Icon(Icons.calendar_month),
                        )),
                    // 홍보 시작일 유효성 검사
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "홍보 시작일을 입력하세요.";
                      }
                      return null;
                    }),
                TextFormField(
                    controller: _enddateController,
                    readOnly: true,
                    decoration: InputDecoration(
                        labelText: "홍보 종료일",
                        suffixIcon: GestureDetector(
                          onTap: () {
                            print("홍보 종료일 입력");
                            picker.DatePicker.showDatePicker(context,
                                showTitleActions: true,
                                minTime: DateTime.now(),
                                maxTime: DateTime(2024, 12, 31),
                                theme: const picker.DatePickerTheme(
                                    headerColor:
                                        Color.fromARGB(255, 154, 184, 212),
                                    backgroundColor:
                                        Color.fromARGB(255, 255, 255, 255),
                                    itemStyle: TextStyle(
                                        color: Color.fromARGB(255, 46, 46, 46),
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18),
                                    doneStyle: TextStyle(
                                        color: Color.fromARGB(255, 97, 97, 97),
                                        fontSize: 16)), onChanged: (date) {
                              print('change $date in time zone ' +
                                  date.timeZoneOffset.inHours.toString());
                              print("홍보 종료일 : ${_enddateController.text}");
                              print(date);
                            }, onConfirm: (date) {
                              print('confirm $date');
                              print("date : $date");
                              // date : 2024-01-17 00:0:00.000
                              // ⬇ 변환
                              // text : 2024/01/17
                              var dateFormat =
                                  DateFormat('yyyy/MM/dd').format(date);

                              // "yyyy/MM/dd" 날짜 형식으로 지정
                              _enddateController.text = dateFormat;
                            },
                                currentTime: DateTime.now(),
                                locale: picker.LocaleType.ko);
                          },
                          child: Icon(Icons.calendar_month),
                        )),
                    // 홍보 시작일 유효성 검사
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "홍보 종료일을 입력하세요.";
                      }
                      return null;
                    }),
                // 제목
                TextFormField(
                  controller: _titleController,
                  decoration: const InputDecoration(labelText: '제목'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return '제목을 입력하세요';
                    }
                    return null;
                  },
                ),
                // 작성자
                // TextFormField(
                //   controller: _writerController,
                //   decoration: const InputDecoration(labelText: '작성자'),
                //   validator: (value) {
                //     if (value == null || value.isEmpty) {
                //       return '작성자를 입력하세요';
                //     }
                //     return null;
                //   },
                // ),
                // 내용
                TextFormField(
                  controller: _contentController,
                  decoration: const InputDecoration(labelText: '내용'),
                  maxLines: 5,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return '내용을 입력하세요';
                    }
                    return null;
                  },
                ),
                const SizedBox(
                  height: 20.0,
                ),
              ],
            ),
          ]),
        ),
      ),
      bottomSheet: Container(
        height: 60,
        color: Colors.white,
        child: Center(
          child: ElevatedButton(
            onPressed: () {
              insert();
            },
            style: ElevatedButton.styleFrom(
              minimumSize: const Size(double.infinity, 50), // 가로 100% 버튼
              backgroundColor: Colors.blueAccent,
              foregroundColor: Colors.white,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.zero, // 테두리를 둥글지 않게 설정
              ),
            ),
            child: const Text('등록하기'),
          ),
        ),
      ),
    );
  }
}


// import 'dart:convert'; // 추가된 부분
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;

// class InsertScreen extends StatefulWidget {
//   const InsertScreen({super.key});

//   @override
//   State<InsertScreen> createState() => _InsertScreenState();
// }

// class _InsertScreenState extends State<InsertScreen> {
//   final TextEditingController _titleController = TextEditingController();
//   final TextEditingController _writerController = TextEditingController();
//   final TextEditingController _contentController = TextEditingController();

//   Future<void> _insertBoard() async {
//     var url = "http://localhost:8080/board"; // 서버 URL 수정
//     var response = await http.post(
//       Uri.parse(url),
//       headers: <String, String>{
//         'Content-Type': 'application/json; charset=UTF-8',
//       },
//       body: jsonEncode(<String, String>{
//         'title': _titleController.text,
//         'writer': _writerController.text,
//         'content': _contentController.text,
//       }),
//     );

//     if (response.statusCode == 201) {
//       // 성공적으로 게시글을 삽입한 경우
//       Navigator.pop(context, true); // 이전 화면으로 돌아가기
//     } else {
//       // 오류 처리
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Failed to insert board')),
//       );
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("게시글 작성"),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           children: [
//             TextField(
//               controller: _titleController,
//               decoration: InputDecoration(labelText: '제목'),
//             ),
//             TextField(
//               controller: _writerController,
//               decoration: InputDecoration(labelText: '작성자'),
//             ),
//             TextField(
//               controller: _contentController,
//               decoration: InputDecoration(labelText: '내용'),
//               maxLines: 5,
//             ),
//             SizedBox(height: 20),
//             ElevatedButton(
//               onPressed: _insertBoard,
//               child: Text('게시글 등록'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
