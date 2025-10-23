import 'package:booking_app/features/screen/chat/chat_screen.dart';
import 'package:flutter/material.dart';
import 'package:booking_app/utils/constants/colors.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;

class RecentChat extends StatelessWidget {
  const RecentChat({super.key});

  List<types.TextMessage> get chats => [
        types.TextMessage(
          id: '1',
          author: const types.User(
            id: '1',
            firstName: 'Trống Đồng',
            lastName: 'Palace',
            imageUrl: 'assets/images/avatar1.png',
          ),
          text:
              'Chào bạn! Trống Đồng Palace có sảnh tiệc cưới rộng 500 khách. Bạn muốn xem không?',
          createdAt: DateTime.now()
              .subtract(const Duration(hours: 1))
              .millisecondsSinceEpoch,
        ),
        types.TextMessage(
          id: '2',
          author: const types.User(
            id: '2',
            firstName: 'Long Vĩ',
            lastName: 'Palace',
            imageUrl: 'assets/images/avatar2.png',
          ),
          text: 'Long Vĩ Palace có ưu đãi đặc biệt cho tiệc cưới tháng này!',
          createdAt: DateTime.now()
              .subtract(const Duration(hours: 2))
              .millisecondsSinceEpoch,
        ),
        types.TextMessage(
          id: '3',
          author: const types.User(
            id: '3',
            firstName: 'The One',
            lastName: 'Event Center',
            imageUrl: 'assets/images/avatar3.png',
          ),
          text: 'The One có menu buffet cao cấp và dịch vụ trang trí miễn phí',
          createdAt: DateTime.now()
              .subtract(const Duration(hours: 3))
              .millisecondsSinceEpoch,
        ),
        types.TextMessage(
          id: '4',
          author: const types.User(
            id: '4',
            firstName: 'Trung Tâm Hội Nghị',
            lastName: 'Quốc Gia',
            imageUrl: 'assets/images/avatar4.png',
          ),
          text:
              'Trung Tâm Hội Nghị Quốc Gia - Địa điểm sang trọng cho đám cưới của bạn',
          createdAt: DateTime.now()
              .subtract(const Duration(hours: 4))
              .millisecondsSinceEpoch,
        ),
      ];

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        decoration: const BoxDecoration(
          color: WColors.lightGrey,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(30.0),
            topRight: Radius.circular(30.0),
          ),
        ),
        child: ClipRRect(
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(30.0),
            topRight: Radius.circular(30.0),
          ),
          child: ListView.builder(
            itemCount: chats.length,
            itemBuilder: (BuildContext context, int index) {
              final types.TextMessage chat = chats[index];
              final DateTime messageTime =
                  DateTime.fromMillisecondsSinceEpoch(chat.createdAt!);
              final bool isRecent =
                  DateTime.now().difference(messageTime).inHours < 3;

              return GestureDetector(
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => ChatScreen(
                      user: chat.author,
                    ),
                  ),
                ),
                child: Container(
                  margin:
                      const EdgeInsets.only(top: 5.0, bottom: 5.0, right: 20.0),
                  padding: const EdgeInsets.symmetric(
                      horizontal: 20.0, vertical: 10.0),
                  decoration: BoxDecoration(
                    color: isRecent ? const Color(0xFFFFEFEE) : Colors.white,
                    borderRadius: const BorderRadius.only(
                      topRight: Radius.circular(20.0),
                      bottomRight: Radius.circular(20.0),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          CircleAvatar(
                            radius: 35.0,
                            backgroundImage: chat.author.imageUrl != null
                                ? AssetImage(chat.author.imageUrl!)
                                : null,
                            child: chat.author.imageUrl == null
                                ? Text(
                                    chat.author.firstName?[0].toUpperCase() ??
                                        'U',
                                    style: const TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  )
                                : null,
                          ),
                          const SizedBox(width: 10.0),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                '${chat.author.firstName ?? ''} ${chat.author.lastName ?? ''}',
                                style: const TextStyle(
                                  color: Colors.grey,
                                  fontSize: 15.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 5.0),
                              SizedBox(
                                width: MediaQuery.of(context).size.width * 0.45,
                                child: Text(
                                  chat.text,
                                  style: const TextStyle(
                                    color: Colors.blueGrey,
                                    fontSize: 15.0,
                                    fontWeight: FontWeight.w600,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      Column(
                        children: <Widget>[
                          Text(
                            '${messageTime.hour}:${messageTime.minute.toString().padLeft(2, '0')}',
                            style: const TextStyle(
                              color: Colors.grey,
                              fontSize: 12.0,
                            ),
                          ),
                          const SizedBox(height: 5.0),
                          isRecent
                              ? Container(
                                  width: 40.0,
                                  height: 20.0,
                                  decoration: BoxDecoration(
                                    color: Theme.of(context).primaryColor,
                                    borderRadius: BorderRadius.circular(30.0),
                                  ),
                                  alignment: Alignment.center,
                                  child: const Text(
                                    'NEW',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 12.0,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                )
                              : const SizedBox.shrink(),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
