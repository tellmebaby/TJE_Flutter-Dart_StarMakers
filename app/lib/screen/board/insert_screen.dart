import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

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

  Future<void> insert() async {
    if (_formKey.currentState!.validate()) {
      var url = "http://10.0.2.2:8080/starCard";
      try {
        var response = await http.post(
          Uri.parse(url),
          headers: {"Content-Type": "application/json"},
          body: jsonEncode({
            'title': _titleController.text,
            'writer': _writerController.text,
            'content': _contentController.text,
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
        title: const Text("게시글 작성"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
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
              TextFormField(
                controller: _writerController,
                decoration: const InputDecoration(labelText: '작성자'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return '작성자를 입력하세요';
                  }
                  return null;
                },
              ),
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
            ],
          ),
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
