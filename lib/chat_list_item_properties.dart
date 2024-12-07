/// A class that contains properties of a chat list item.
/// It is used in the `itemBuilder` of the `ChatList` widget.
class ChatListItemProperties {
  const ChatListItemProperties({
    required this.index,
    required this.localIndex,
    required this.isInNew,
    required this.isAtTopEdge,
    required this.isAtBottomEdge,
  });

  /// The index of the item in the list. If index equals to 0, it is the first item from the bottom in the list.
  final int index;

  /// The local index of the item in new or old items range.
  /// The old items are the items that are initially loaded in the list and loaded from the load more callback.
  /// The new items are the items that are added to the bottom of the list.
  final int localIndex;

  /// Determines if the item is in the new items range.
  final bool isInNew;

  /// Determines if the item is at the top edge of the list.
  final bool isAtTopEdge;

  /// Determines if the item is at the bottom edge of the list.
  final bool isAtBottomEdge;

  /// Determines if the item is at the edge of the list.
  bool get isAtEdge => isAtTopEdge || isAtBottomEdge;

  @override
  String toString() => 'ChatListItemProperties\n'
      'index: $index,\n'
      'localIndex: $localIndex,\n'
      'isInNew: $isInNew,\n'
      'isAtTopEdge: $isAtTopEdge,\n'
      'isAtBottomEdge: $isAtBottomEdge';
}
