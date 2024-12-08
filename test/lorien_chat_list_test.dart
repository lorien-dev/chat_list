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
  });
}
