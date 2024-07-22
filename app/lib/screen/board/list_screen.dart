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
  final PageController _pageController = PageController();

  @override
  void initState() {
    super.initState();
    getBoardList().then((result) {
      setState(() {
        _boardList = result;
      });
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
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
      appBar: AppBar(
  title: Container(
    color: Colors.black,
    padding: const EdgeInsets.all(8.0),
    child: Image.asset(
      'assets/images/logo.png',
      fit: BoxFit.contain,
      height: kToolbarHeight - 16, // Adjust height as needed
    ),
  ),
  centerTitle: true, // Center the title
),
      body: PageView.builder(
        controller: _pageController,
        scrollDirection: Axis.vertical,
        physics: const CustomPageViewScrollPhysics(),
        itemCount: _boardList.length,
        itemBuilder: (context, index) {
          return Stack(
            children: [
              Positioned.fill(
                child: Image.network(
                  "http://localhost:8080/file/img/${_boardList[index].imgNo}",
                  fit: BoxFit.cover,
                  height: MediaQuery.of(context).size.height * 0.7,
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  height: MediaQuery.of(context).size.height * 0.3,
                  width: double.infinity,
                  color: Colors.black.withOpacity(0.7),
                  padding: const EdgeInsets.all(30),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _boardList[index].title,
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '작성자: ${_boardList[index].writer}',
                        style: const TextStyle(
                          fontSize: 18,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class CustomPageViewScrollPhysics extends ScrollPhysics {
  const CustomPageViewScrollPhysics({ScrollPhysics? parent}) : super(parent: parent);

  @override
  CustomPageViewScrollPhysics applyTo(ScrollPhysics? ancestor) {
    return CustomPageViewScrollPhysics(parent: buildParent(ancestor)!);
  }

  @override
  Simulation? createBallisticSimulation(ScrollMetrics position, double velocity) {
    final Tolerance tolerance = this.tolerance;
    if (velocity.abs() < tolerance.velocity && position.outOfRange) {
      return ScrollSpringSimulation(spring, position.pixels, position.minScrollExtent, 0.0, tolerance: tolerance);
    }
    return super.createBallisticSimulation(position, velocity);
  }

  @override
  double get minFlingVelocity => 50.0;

  @override
  double get maxFlingVelocity => 2000.0;
  
  @override
  SpringDescription get spring => const SpringDescription(
    mass: 80.0,
    stiffness: 100.0,
    damping: 1.0,
  );
}
