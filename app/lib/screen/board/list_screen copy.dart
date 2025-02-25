// import 'dart:convert';
// import 'package:app/models/board.dart';
// import 'package:flutter/material.dart';

// import 'package:http/http.dart' as http;


// class ListScreen extends StatefulWidget {
//   const ListScreen({super.key});

//   @override
//   State<ListScreen> createState() => _ListScreenState();
// }

// class _ListScreenState extends State<ListScreen> {
//   List<Board> _boardList = [];

//   @override
//   void initState() {
//     super.initState();
//     getBoardList().then((result) {
//       setState(() {
//         _boardList = result;
//       });
//     });
//   }

//   // 🌞 게시글 목록 데이터 요청
//   Future<List<Board>> getBoardList() async {
//     var url = "http://localhost:8080/board";

//     List<Board> list = [];
//     try {
//       var response = await http.get(Uri.parse(url));
//       print("::::: response - body :::::");
//       print(response.body);
//       // UTF-8 디코딩
//       var utf8Decoded = utf8.decode(response.bodyBytes);
//       // JSON 디코딩
//       var boardList = jsonDecode(utf8Decoded);
      
//       for (var i = 0; i < boardList.length; i++) {
//         list.add(Board(
//           no: boardList[i]['no'],
//           title: boardList[i]['title'],
//           writer: boardList[i]['writer'],
//           content: boardList[i]['content'],
//         ));
//       }
//       print(list);
//     } catch (e) {
//       print(e);
//     }

//     return list;
//   }

//   final List<PopupMenuEntry<String>> _popupMenuItems = [
//     const PopupMenuItem<String>(
//       value: 'update',
//       child: Row(
//         children: [
//           Icon(Icons.edit, color: Colors.black), // 아이콘
//           SizedBox(width: 8), // 아이콘과 텍스트 사이에 간격 추가
//           Text('수정하기'), // 텍스트
//         ],
//       ),
//     ),
//     const PopupMenuItem<String>(
//       value: 'delete',
//       child: Row(
//         children: [
//           Icon(Icons.delete, color: Colors.black), // 아이콘
//           SizedBox(width: 8), // 아이콘과 텍스트 사이에 간격 추가
//           Text('삭제하기'), // 텍스트
//         ],
//       ),
//     ),
//   ];

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text("게시글 목록")),
//       body: Container(
//         padding: const EdgeInsets.fromLTRB(5, 0, 5, 10),
//         child: ListView.builder(
//           itemCount: _boardList.length,
//           itemBuilder: (context, index) {
//             return GestureDetector(
//               child: Card(
//                 child: ListTile(
//                   leading: Text(_boardList[index].no.toString() ?? '0'),
//                   title: Text(_boardList[index].title ?? "제목없음"),
//                   subtitle: Text(_boardList[index].writer ?? '-'),
//                   trailing: PopupMenuButton<String>(
//                     itemBuilder: (BuildContext context) {
//                       return _popupMenuItems;
//                     },
//                     onSelected: (String value) async {
//                       if (value == 'update') {
//                         Navigator.pushNamed(
//                           context,
//                           "/board/update",
//                           arguments: _boardList[index].no,
//                         );
//                       } else if (value == 'delete') {
//                         bool check = await _showDeleteConfirmDialog();
//                         if (check) {
//                           deleteBoard(_boardList[index].no).then((result) {
//                             if (result) {
//                               setState(() {
//                                 _boardList.removeAt(index);
//                               });
//                             }
//                           });
//                         }
//                       }
//                     },
//                   ),
//                 ),
//               ),
//               onTap: () {
//                 Navigator.pushNamed(
//                   context,
//                   "/board/read",
//                   arguments: _boardList[index].no,
//                 );
//               },
//             );
//           },
//         ),
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: () {
//           Navigator.pushReplacementNamed(context, "/board/insert");
//         },
//         child: const Icon(Icons.create),
//       ),
//     );
//   }

//   /// 게시글 삭제 요청
//   Future<bool> deleteBoard(int? no) async {
//     var url = "http://localhost:8080/board/$no";
//     try {
//       var response = await http.delete(Uri.parse(url));
//       print("::::: response - statusCode :::::");
//       print(response.statusCode);
      
//       if (response.statusCode == 200 || response.statusCode == 204) {
//         // 성공적으로 삭제됨
//         print("게시글 삭제 성공");
//         return true;
//       } else {
//         // 실패 시 오류 메시지
//         throw Exception('Failed to delete board. Status code: ${response.statusCode}');
//       }
//     } catch (e) {
//       print(e);
//       return false;
//     }
//   }

//   /// 삭제 확인 다이얼로그 표시
//   Future<bool> _showDeleteConfirmDialog() async {
//     bool result = false;
//     await showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           title: const Text('삭제 확인'),
//           content: const Text('정말로 이 게시글을 삭제하시겠습니까?'),
//           actions: [
//             TextButton(
//               onPressed: () {
//                 Navigator.of(context).pop(false); // 취소를 클릭하면 false 반환
//               },
//               child: const Text('취소'),
//             ),
//             TextButton(
//               onPressed: () {
//                 Navigator.of(context).pop(true); // 삭제를 클릭하면 true 반환
//               },
//               child: const Text('삭제'),
//             ),
//           ],
//         );
//       },
//     ).then((value) {
//       result = value ?? false;
//     });
//     return result;
//   }
// }



// // import 'dart:convert';

// // import 'package:flutter/material.dart';
// // import 'package:http_app/models/board.dart';
// // import 'package:http/http.dart' as http;

// // class ListScreen extends StatefulWidget {
// //   const ListScreen({super.key});

// //   @override
// //   State<ListScreen> createState() => _ListScreenState();
// // }

// // class _ListScreenState extends State<ListScreen> {
// //   List<Board> _boardList = [];
// //   bool _isLoading = true;

// //   @override
// //   void initState() {
// //     super.initState();
// //     _loadBoardList();
// //   }

// //   Future<void> _loadBoardList() async {
// //     setState(() {
// //       _isLoading = true;
// //     });
// //     List<Board> result = await getBoardList();
// //     setState(() {
// //       _boardList = result;
// //       _isLoading = false;
// //     });
// //   }

// //   Future<List<Board>> getBoardList() async {
// //     var url = "http://localhost:8080/board";
// //     var response = await http.get(Uri.parse(url));

// //     var utf8Decoded = utf8.decode(response.bodyBytes);
// //     var boardList = jsonDecode(utf8Decoded);
// //     List<Board> list = [];

// //     for (var board in boardList) {
// //       list.add(Board(
// //         no: board['no'],
// //         title: board['title'],
// //         writer: board['writer'],
// //         content: board['content'],
// //       ));
// //     }

// //     return list;
// //   }

// //   Future<void> _deleteBoard(int? no) async {
// //     if (no == null) return;

// //     var url = "http://localhost:8080/board/$no";
// //     var response = await http.delete(Uri.parse(url));

// //     if (response.statusCode == 200) {
// //       setState(() {
// //         _boardList.removeWhere((board) => board.no == no);
// //       });
// //       ScaffoldMessenger.of(context).showSnackBar(
// //         SnackBar(content: Text('게시글이 삭제되었습니다.')),
// //       );
// //     } else {
// //       ScaffoldMessenger.of(context).showSnackBar(
// //         SnackBar(content: Text('게시글 삭제에 실패했습니다.')),
// //       );
// //     }
// //   }

// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       appBar: AppBar(
// //         title: Text("게시글 목록"),
// //       ),
// //       body: _isLoading
// //           ? Center(child: CircularProgressIndicator())
// //           : Container(
// //               padding: const EdgeInsets.fromLTRB(5, 0, 5, 10),
// //               child: ListView.builder(
// //                 itemCount: _boardList.length,
// //                 itemBuilder: (context, index) {
// //                   final board = _boardList[index];
// //                   return Dismissible(
// //                     key: Key(board.no.toString()),
// //                     direction: DismissDirection.endToStart,
// //                     background: Container(
// //                       color: Colors.red,
// //                       alignment: Alignment.centerRight,
// //                       padding: EdgeInsets.symmetric(horizontal: 20),
// //                       child: Icon(
// //                         Icons.delete,
// //                         color: Colors.white,
// //                         size: 36,
// //                       ),
// //                     ),
// //                     confirmDismiss: (direction) async {
// //                       final bool res = await showDialog(
// //                         context: context,
// //                         builder: (BuildContext context) {
// //                           return AlertDialog(
// //                             title: Text("게시글 삭제"),
// //                             content: Text("이 게시글을 삭제하시겠습니까?"),
// //                             actions: <Widget>[
// //                               TextButton(
// //                                 onPressed: () => Navigator.of(context).pop(false),
// //                                 child: Text("취소"),
// //                               ),
// //                               TextButton(
// //                                 onPressed: () => Navigator.of(context).pop(true),
// //                                 child: Text("삭제"),
// //                               ),
// //                             ],
// //                           );
// //                         },
// //                       );
// //                       return res;
// //                     },
// //                     onDismissed: (direction) {
// //                       if (board.no != null) {
// //                         _deleteBoard(board.no);
// //                       }
// //                     },
// //                     child: GestureDetector(
// //                       onTap: () async {
// //                         setState(() {
// //                           _isLoading = true;
// //                         });
// //                         final result = await Navigator.pushNamed(
// //                           context,
// //                           "/board/read",
// //                           arguments: board,
// //                         );
// //                         if (result == true) {
// //                           _loadBoardList(); // 데이터 갱신
// //                         } else {
// //                           setState(() {
// //                             _isLoading = false;
// //                           });
// //                         }
// //                       },
// //                       child: Card(
// //                         child: ListTile(
// //                           leading: Text(board.no.toString()),
// //                           title: Text(board.title ?? "제목없음"),
// //                           subtitle: Text(board.writer ?? '-'),
// //                           trailing: Icon(Icons.more_vert),
// //                         ),
// //                       ),
// //                     ),
// //                   );
// //                 },
// //               ),
// //             ),
// //       floatingActionButton: FloatingActionButton(
// //         onPressed: () async {
// //           final result = await Navigator.pushNamed(context, "/board/insert");
// //           if (result == true) {
// //             _loadBoardList(); // 데이터 갱신
// //           }
// //         },
// //         child: const Icon(Icons.create),
// //       ),
// //     );
// //   }
// // }