import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Board {
  final int no;
  final String title;
  final String writer;
  final String content;
  final String regDate;
  final String updDate;
  final int views;
  final int userNo;
  final int payNo;
  final int likes;
  final String status;
  final String card;
  final String category1;
  final String category2;
  final String type;
  final String startDate;
  final String endDate;
  final int imgNo;

  Board({
    required this.no,
    required this.title,
    required this.writer,
    required this.content,
    required this.regDate,
    required this.updDate,
    required this.views,
    required this.userNo,
    required this.payNo,
    required this.likes,
    required this.status,
    required this.card,
    required this.category1,
    required this.category2,
    required this.type,
    required this.startDate,
    required this.endDate,
    required this.imgNo,
  });

  factory Board.fromJson(Map<String, dynamic> json) {
    return Board(
      no: json['starNo'] ?? 0,
      title: json['title'] ?? '',
      writer: json['writer'] ?? '',
      content: json['content'] ?? '',
      regDate: json['regDate'] ?? '',
      updDate: json['updDate'] ?? '',
      views: json['views'] ?? 0,
      userNo: json['userNo'] ?? 0,
      payNo: json['payNo'] ?? 0,
      likes: json['likes'] ?? 0,
      status: json['status'] ?? '',
      card: json['card'] ?? '',
      category1: json['category1'] ?? '',
      category2: json['category2'] ?? '',
      type: json['type'] ?? '',
      startDate: json['startDate'] ?? '',
      endDate: json['endDate'] ?? '',
      imgNo: json['imgNo'] ?? 0,
    );
  }
}

class ListScreen extends StatefulWidget {
  const ListScreen({super.key});

  @override
  State<ListScreen> createState() => _ListScreenState();
}

class _ListScreenState extends State<ListScreen> {
  List<Board> _boardList = [];

  @override
  void initState() {
    super.initState();
    getBoardList().then((result) {
      setState(() {
        _boardList = result;
      });
    });
  }

  // 게시글 목록 데이터 요청
  Future<List<Board>> getBoardList() async {
    // var url = "http://localhost:8080/starCard/List";
    var url = "http://10.0.2.2:8080/starCard/List";

    List<Board> list = [];
    try {
      var response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        print("::::: response - body :::::");
        print(response.body);
        // UTF-8 디코딩
        var utf8Decoded = utf8.decode(response.bodyBytes);
        // JSON 디코딩
        var jsonResponse = jsonDecode(utf8Decoded);

        // JSON 데이터에서 "starList" 배열 추출
        var boardList = jsonResponse['starList'];

        // Null 및 타입 체크
        if (boardList is List) {
          for (var item in boardList) {
            if (item != null && item is Map<String, dynamic>) {
              list.add(Board.fromJson(item));
            }
          }
        }
        print(list);
      } else {
        print('Failed to load data: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
    }

    return list;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("게시글 목록")),
      body: Container(
        padding: const EdgeInsets.fromLTRB(5, 0, 5, 10),
        child: ListView.builder(
          itemCount: _boardList.length,
          itemBuilder: (context, index) {
            return Card(
              child: Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: NetworkImage(
                        "http://10.0.2.2:8080/file/img/${_boardList[index].imgNo}"),
                    // "http://localhost:8080/file/img/${_boardList[index].imgNo}"),
                    fit: BoxFit.cover,
                  ),
                ),
                child: ListTile(
                  title: Text(
                    _boardList[index].title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '작성자: ${_boardList[index].writer}',
                        style: const TextStyle(color: Colors.white),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        '내용: ${_boardList[index].content}',
                        style: const TextStyle(color: Colors.white),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        '등록일: ${_boardList[index].regDate}',
                        style: const TextStyle(color: Colors.white),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        '수정일: ${_boardList[index].updDate}',
                        style: const TextStyle(color: Colors.white),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        '조회수: ${_boardList[index].views}',
                        style: const TextStyle(color: Colors.white),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        '유저 번호: ${_boardList[index].userNo}',
                        style: const TextStyle(color: Colors.white),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        '결제 번호: ${_boardList[index].payNo}',
                        style: const TextStyle(color: Colors.white),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        '좋아요: ${_boardList[index].likes}',
                        style: const TextStyle(color: Colors.white),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        '상태: ${_boardList[index].status}',
                        style: const TextStyle(color: Colors.white),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        '카드: ${_boardList[index].card}',
                        style: const TextStyle(color: Colors.white),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        '카테고리1: ${_boardList[index].category1}',
                        style: const TextStyle(color: Colors.white),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        '카테고리2: ${_boardList[index].category2}',
                        style: const TextStyle(color: Colors.white),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        '타입: ${_boardList[index].type}',
                        style: const TextStyle(color: Colors.white),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        '시작일: ${_boardList[index].startDate}',
                        style: const TextStyle(color: Colors.white),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        '종료일: ${_boardList[index].endDate}',
                        style: const TextStyle(color: Colors.white),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
