# lorien_chat_list

**lorien_chat_list** is a package to help build chat pages like *Messenger* or *WhatsUp*. The main difference with other packages is the scrolling part - it will scroll automatically on a new message or preserve the current scroll position if the user scrolled up in the list (you can set the treshold for that).

![lorien_dev_chat_list_demo_short](https://github.com/user-attachments/assets/4b5e9dd8-f6a6-4293-8053-288a0e989940)

## Getting Started

Add the dependency in `pubspec.yaml`:

```yaml
dependencies:
  ...
  lorien_chat_list:: ^0.0.1
```

## Basic Usage

### Import
```dart
import 'package:lorien_chat_list/lorien_chat_list.dart';
```

### Controller
```dart
final ChatListController<int> _controller = ChatListController(initialItems: List<int>.generate(10, (index) => index));
```

Adding an item to the bottom of the list.
```dart
_controller.addToBottom(100);
```

Adding a range of items to the bottom of the list.
```dart
_controller.addRangeToBottom([100, 200]);
```

Adding an item to the top of the list.
```dart
_controller.addToTop(-100);
```

Adding a range of items to the top of the list.
```dart
_controller.addRangeToTop([-100, -200]);
```

Clearing all items and resetting the controller to its initial state.
```dart
_controller.clearAll();
```

### Widget
```dart
ChatList(
  controller: _controller,
  itemBuilder: (item, properties) => Text(
    '${item.toString()} - ${properties.toString()}',
  ),
),
```

For a more complex usage please see the [example](https://github.com/lorien-dev/chat_list/tree/master/example).

## Customization (optional)

### ChatList
- `loadingMoreWidget` - widget that is visible at the top of the list while loading more old items (*onLoadMoreCallback*)
- `onLoadMoreCallback` - function called to load more old items. Triggered while reached top edge of the list. Should return bool - *true* if there are more old messages to load, otherwise *false* if everything is loaded.
- `scrollController` - scroll controller
- `scrollPhysics` - scroll physics
- `padding` - list padding
- `spacing` - vertical spacing between items
- `useJumpTo` - whether to use jumpTo instead of animateTo in automatic scrolling
- `animateToDuration` - animateTo duration, defaults to 300 milliseconds
- `fadeInDuration` - fade in duration, defaults to 300 milliseconds
- `animateToCurve` - animateTo curve, defaults to *Curves.easeInOut*
- `fadeInCurve` - fade in curve, defaults to *Curves.easeInOut*
- `bottomEdgeThreshold` - threshold for automatic scrolling to a new bottom items, defaults to 0

## Contributing

Pull requests are welcome. For major changes, please open an issue first
to discuss what you would like to change.

Please make sure to update tests as appropriate.

## Author

- [Michał Lot LORIEN.DEV](https://github.com/lorien-dev)

## License

I would say it's [Beerware license](https://en.wikipedia.org/wiki/Beerware) - if you find the package useful, you can buy me a beer or 
a coffee 🍺... but unfortunately it says on the pub.dev that *No license was recognized* so let's
say it is [MIT License](https://en.wikipedia.org/wiki/MIT_License) 🥸.

[!["Buy Me A Coffee"](https://www.buymeacoffee.com/assets/img/custom_images/orange_img.png)](https://buymeacoffee.com/lorien.dev)

