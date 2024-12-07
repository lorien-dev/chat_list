import 'dart:math';

import 'package:flutter/material.dart';
import 'package:lorien_chat_list/lorien_chat_list.dart';

void main() {
  runApp(const LorienChatListExample());
}

class LorienChatListExample extends StatefulWidget {
  const LorienChatListExample({super.key});

  @override
  State<LorienChatListExample> createState() => _LorienChatListExampleState();
}

class _LorienChatListExampleState extends State<LorienChatListExample> {
  late final ChatListController<_MessageModel> _chatController = ChatListController<_MessageModel>(
    initialItems: List<int>.generate(10, (index) => -index)
        .map(
          (number) => _MessageModel(
            number: number,
            isMyMessage: _random.nextBool(),
            text: _tolkienQuotes[number % _tolkienQuotes.length],
          ),
        )
        .toList(),
  );

  int _nextTopNumber = -10;
  int _nextBottomNumber = 1;

  final _random = Random();
  final _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.grey[200],
        appBar: AppBar(
          backgroundColor: Colors.black,
          title: const Text(
            'LORIEN.DEV Chat list',
            style: TextStyle(
              color: Colors.white,
            ),
          ),
          actions: [
            IconButton(
              tooltip: 'Add item to top',
              icon: const Icon(
                Icons.add_comment_outlined,
                color: Colors.white,
              ),
              onPressed: () => _chatController.addToTop(
                _MessageModel(
                  number: _nextTopNumber--,
                  isMyMessage: _random.nextBool(),
                  text: _tolkienQuotes[_nextTopNumber % _tolkienQuotes.length],
                ),
              ),
            ),
            IconButton(
              tooltip: 'Add item to bottom',
              icon: const Icon(
                Icons.add_comment,
                color: Colors.white,
              ),
              onPressed: () => _chatController.addToBottom(
                _MessageModel(
                  number: _nextBottomNumber++,
                  isMyMessage: _random.nextBool(),
                  text: _tolkienQuotes[_nextBottomNumber % _tolkienQuotes.length],
                ),
              ),
            ),
            IconButton(
              tooltip: 'Clear list',
              icon: const Icon(
                Icons.refresh,
                color: Colors.white,
              ),
              onPressed: () {
                _chatController.clearAll();
                _nextTopNumber = 0;
                _nextBottomNumber = 1;
              },
            ),
          ],
        ),
        body: ChatList(
          controller: _chatController,
          itemBuilder: (item, properties) => _MessageCard(
            type: item.isMyMessage ? _MessageType.outgoing : _MessageType.incoming,
            text: '${item.number}. ${item.text}',
          ),
          loadingMoreWidget: const Padding(
            padding: EdgeInsets.only(top: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(),
              ],
            ),
          ),
          onLoadMoreCallback: _loadMoreOldMessages,
          scrollController: _scrollController,
          scrollPhysics: const ClampingScrollPhysics(),
          useJumpTo: false,
          animateToDuration: const Duration(milliseconds: 300),
          fadeInDuration: const Duration(milliseconds: 300),
          animateToCurve: Curves.easeInOut,
          fadeInCurve: Curves.easeInOut,
          bottomEdgeThreshold: 20.0,
          padding: const EdgeInsets.all(16.0),
          spacing: 4.0,
        ),
      ),
    );
  }

  /// Simulates loading more old messages.
  /// Returns *true* if there are more old messages to load
  /// otherwise returns *false* if everything is loaded.
  Future<bool> _loadMoreOldMessages() async {
    /// Simulate a delay of 3 seconds
    await Future.delayed(const Duration(seconds: 3));

    /// Fetch 10 more old messages
    final newOldItems = List<int>.generate(10, (index) => _nextTopNumber--)
        .map(
          (number) => _MessageModel(
            number: number,
            isMyMessage: _random.nextBool(),
            text: _tolkienQuotes[number % _tolkienQuotes.length],
          ),
        )
        .toList();

    /// Add the new old messages to the top of the chat list
    _chatController.addRangeToTop(newOldItems);

    /// Return true if there are more old messages to load
    return _nextTopNumber > -30;
  }
}

class _MessageCard extends StatelessWidget {
  const _MessageCard({
    required _MessageType type,
    required String text,
  })  : _type = type,
        _text = text;

  final _MessageType _type;
  final String _text;

  @override
  Widget build(BuildContext context) {
    final isIncoming = _type == _MessageType.incoming;
    return Row(
      mainAxisAlignment: isIncoming ? MainAxisAlignment.start : MainAxisAlignment.end,
      children: [
        Flexible(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: MediaQuery.of(context).size.width * 0.7,
            ),
            child: Card(
              color: isIncoming ? Colors.white : Colors.black,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  _text,
                  style: TextStyle(
                    color: isIncoming ? Colors.black : Colors.white,
                  ),
                  textAlign: isIncoming ? TextAlign.left : TextAlign.right,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _MessageModel {
  const _MessageModel({
    required this.number,
    required this.isMyMessage,
    required this.text,
  });

  final int number;
  final bool isMyMessage;
  final String text;
}

enum _MessageType {
  incoming,
  outgoing,
}

const _tolkienQuotes = [
  "\"All we have to decide is what to do with the time that is given us.\" "
      "(The Fellowship of the Ring - J.R.R. Tolkien)",
  "\"Not all those who wander are lost.\" (The Fellowship of the Ring - J.R.R. Tolkien)",
  "\"Courage is found in unlikely places.\" (The Return of the King - J.R.R. Tolkien)",
  "\"Even the smallest person can change the course of the future.\" (The Fellowship of the Ring - J.R.R. Tolkien)",
  "\"It's a dangerous business, Frodo, going out your door. You step onto the road, and if you don't keep your feet, "
      "there's no knowing where you might be swept off to.\" (The Fellowship of the Ring - J.R.R. Tolkien)",
  "\"I will not say: do not weep; for not all tears are an evil.\" (The Return of the King - J.R.R. Tolkien)",
  "\"Far over the misty mountains cold, To dungeons deep and caverns old, We must away, ere break of day, To seek "
      "the pale enchanted gold.\" (The Hobbit - J.R.R. Tolkien)",
  "\"The world is indeed full of peril, and in it there are many dark places; but still there is much that is fair, "
      "and though in all lands love is now mingled with grief, it grows perhaps the greater.\" "
      "(The Fellowship of the Ring - J.R.R. Tolkien)",
  "\"War must be, while we defend our lives against a destroyer who would devour all; but I do not love the bright"
      " sword for its sharpness, nor the arrow for its swiftness, nor the warrior for his glory. I love only that"
      " which they defend.\" (The Two Towers - J.R.R. Tolkien)",
  "\"There are older and fouler things than Orcs in the deep places of the world.\" "
      "(The Fellowship of the Ring - J.R.R. Tolkien)"
];
