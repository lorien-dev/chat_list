import 'package:flutter_test/flutter_test.dart';

import 'package:lorien_chat_list/lorien_chat_list.dart';

void main() {
  late List<int> initialItems;
  late ChatListController<int> controller;

  setUp(() {
    initialItems = List<int>.generate(10, (index) => index);
    controller = ChatListController(initialItems: initialItems);
  });

  group('ChatListController test', () {
    test('Initial values test', () {
      expect(controller.oldItems, initialItems);
      expect(controller.newItems, []);
      expect(controller.didLoadAll, false);
      expect(controller.lastAddedToBottom, false);
    });

    test('Set did load all test', () {
      controller.setDidLoadAll(true);
      expect(controller.didLoadAll, true);

      controller.setDidLoadAll(false);
      expect(controller.didLoadAll, false);
    });

    test('Add to bottom test', () {
      controller.addToBottom(100);

      expect(controller.oldItems, initialItems);
      expect(controller.newItems, [100]);
      expect(controller.didLoadAll, false);
      expect(controller.lastAddedToBottom, true);
    });

    test('Add range to bottom test', () {
      controller.addRangeToBottom([100, 200]);

      expect(controller.oldItems, initialItems);
      expect(controller.newItems, [100, 200]);
      expect(controller.didLoadAll, false);
      expect(controller.lastAddedToBottom, true);
    });

    test('Add to top test', () {
      controller.addToTop(-100);

      expect(controller.oldItems, [...initialItems, -100]);
      expect(controller.newItems, []);
      expect(controller.didLoadAll, false);
      expect(controller.lastAddedToBottom, false);
    });

    test('Add range to top test', () {
      controller.addRangeToTop([-100, -200]);

      expect(controller.oldItems, [...initialItems, -100, -200]);
      expect(controller.newItems, []);
      expect(controller.didLoadAll, false);
      expect(controller.lastAddedToBottom, false);
    });

    test('Clear all test', () {
      controller.addToTop(100);
      controller.addRangeToTop([200, 300]);
      controller.addToBottom(-100);
      controller.addRangeToBottom([-200, -300]);
      controller.setDidLoadAll(true);
      controller.clearAll();

      expect(controller.oldItems, []);
      expect(controller.newItems, []);
      expect(controller.didLoadAll, false);
      expect(controller.lastAddedToBottom, false);
    });

    test('Check newest', () {
      controller.clearAll();
      expect(controller.newest, null);

      controller.addToTop(0);
      expect(controller.newest, 0);

      controller.addToTop(-1);
      expect(controller.newest, 0);

      controller.addToBottom(1);
      expect(controller.newest, 1);

      controller.addToBottom(2);
      expect(controller.newest, 2);
    });

    test('Check oldest', () {
      controller.clearAll();
      expect(controller.oldest, null);

      controller.addToBottom(0);
      expect(controller.oldest, 0);

      controller.addToBottom(1);
      expect(controller.oldest, 0);

      controller.addToTop(-1);
      expect(controller.oldest, -1);

      controller.addToTop(-2);
      expect(controller.oldest, -2);
    });
  });
}
