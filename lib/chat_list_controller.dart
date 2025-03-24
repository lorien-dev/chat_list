import 'package:flutter/material.dart';

/// A controller for a [ChatList] widget.
/// It is used to manage the items of the list and to notify the list when changes occur.
///
/// {@tool snippet}
///
/// The following example demonstrates how to create a [ChatListController] and initialize it with a list of integers.
///
/// ```dart
/// late final ChatListController<int> _chatListController = ChatListController<int>(
///   initialItems: List<int>.generate(10, (index) => index),
/// );
/// ```
/// {@end-tool}
class ChatListController<T> extends ChangeNotifier {
  ChatListController({
    required List<T> initialItems,
  })  : _oldItems = List.of(initialItems),
        _newItems = [];

  List<T> get oldItems => _oldItems;

  List<T> get newItems => _newItems;

  bool get lastAddedToBottom => _lastAddedToBottom;

  bool get didLoadAll => _didLoadAll;

  bool get shouldScrollToBottom => _shouldScrollToBottom;

  bool get shouldJumpToBottom => _shouldJumpToBottom;

  int get itemsCount => _oldItems.length + _newItems.length;

  final List<T> _oldItems;
  final List<T> _newItems;

  bool _lastAddedToBottom = false;
  bool _didLoadAll = false;
  bool _shouldScrollToBottom = false;
  bool _shouldJumpToBottom = false;

  /// Adds an item to the bottom of the list.
  void addToBottom(T item) {
    _newItems.add(item);
    _lastAddedToBottom = true;
    notifyListeners();
  }

  /// Adds a range of items to the bottom of the list.
  void addRangeToBottom(List<T> items) {
    _newItems.addAll(items);
    _lastAddedToBottom = true;
    notifyListeners();
  }

  /// Adds an item to the top of the list.
  void addToTop(T item) {
    _oldItems.add(item);
    _lastAddedToBottom = false;
    notifyListeners();
  }

  /// Adds a range of items to the top of the list.
  void addRangeToTop(List<T> items) {
    _oldItems.addAll(items);
    _lastAddedToBottom = false;
    notifyListeners();
  }

  /// Sets the value of [_didLoadAll]. If set to *true*, the load more callback will not be called anymore.
  /// This is used automatically and should not be called manually unless for specific use cases.
  void setDidLoadAll(bool value) => _didLoadAll = value;

  /// Scrolls to the bottom of the list. (Experimental feature - no smooth animation)
  void scrollToBottom() {
    _shouldScrollToBottom = true;
    notifyListeners();
    _shouldScrollToBottom = false;
  }

  /// Jumps to the bottom of the list. (Experimental feature - not in a single jump)
  void jumpToBottom() {
    _shouldJumpToBottom = true;
    notifyListeners();
    _shouldJumpToBottom = false;
  }

  /// Clears all items and resets the controller to its initial state.
  void clearAll() {
    _lastAddedToBottom = false;
    _didLoadAll = false;
    _oldItems.clear();
    _newItems.clear();
    notifyListeners();
  }
}
