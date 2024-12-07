import 'dart:async';
import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:lorien_chat_list/chat_list_controller.dart';
import 'package:lorien_chat_list/chat_list_item_properties.dart';
import 'package:lorien_chat_list/fade_in_widget.dart';

class ChatList<T> extends StatefulWidget {
  const ChatList({
    super.key,
    required ChatListController<T> controller,
    required Widget Function(T item, ChatListItemProperties itemProperties) itemBuilder,
    Widget? loadingMoreWidget,
    FutureOr<bool> Function()? onLoadMoreCallback,
    ScrollController? scrollController,
    ScrollPhysics? scrollPhysics,
    EdgeInsets? padding,
    double spacing = 0.0,
    bool useJumpTo = false,
    Duration animateToDuration = const Duration(milliseconds: 300),
    Duration fadeInDuration = const Duration(milliseconds: 300),
    Curve animateToCurve = Curves.easeInOut,
    Curve fadeInCurve = Curves.easeInOut,
    double bottomEdgeThreshold = 0.0,
  })  : _controller = controller,
        _itemBuilder = itemBuilder,
        _loadingMoreWidget = loadingMoreWidget,
        _onLoadMoreCallback = onLoadMoreCallback,
        _scrollController = scrollController,
        _scrollPhysics = scrollPhysics,
        _padding = padding,
        _spacing = spacing,
        _useJumpTo = useJumpTo,
        _animateToDuration = animateToDuration,
        _fadeInDuration = fadeInDuration,
        _animateToCurve = animateToCurve,
        _fadeInCurve = fadeInCurve,
        _bottomEdgeThreshold = bottomEdgeThreshold;

  final ChatListController<T> _controller;
  final Widget Function(T, ChatListItemProperties) _itemBuilder;
  final Widget? _loadingMoreWidget;
  final FutureOr<bool> Function()? _onLoadMoreCallback;
  final ScrollController? _scrollController;
  final ScrollPhysics? _scrollPhysics;
  final EdgeInsets? _padding;
  final double _spacing;
  final bool _useJumpTo;
  final Duration _animateToDuration;
  final Duration _fadeInDuration;
  final Curve _animateToCurve;
  final Curve _fadeInCurve;
  final double _bottomEdgeThreshold;

  @override
  State<ChatList> createState() => _ChatListState<T>();
}

class _ChatListState<T> extends State<ChatList<T>> {
  late final ScrollController _scrollController;
  final _centerKey = GlobalKey();
  final _animationQueue = Queue<bool>();
  final _animatedItemsIndexes = <int>{};

  bool _isLoadingMore = false;
  bool _isAnimationRunning = false;

  List<T> _oldItems = [];
  List<T> _newItems = [];

  bool get _isAtTop => _scrollController.position.pixels == _scrollController.position.maxScrollExtent;

  bool get _isAtBottom =>
      _scrollController.position.pixels <= _scrollController.position.minScrollExtent + widget._bottomEdgeThreshold;

  @override
  void initState() {
    super.initState();

    _oldItems = widget._controller.oldItems;
    _newItems = widget._controller.newItems;

    widget._controller.addListener(_controllerListener);

    _scrollController = widget._scrollController ?? ScrollController();
    _scrollController.addListener(_scrollListener);

    WidgetsBinding.instance
        .addPostFrameCallback((_) => _scrollController.jumpTo(_scrollController.position.minScrollExtent));
  }

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      reverse: true,
      controller: _scrollController,
      physics: widget._scrollPhysics,
      center: _centerKey,
      slivers: [
        SliverPadding(
          padding: EdgeInsets.only(
            left: widget._padding?.left ?? 0.0,
            right: widget._padding?.right ?? 0.0,
            bottom: widget._padding?.bottom ?? 0.0,
          ),
          sliver: SliverList(
            delegate: SliverChildBuilderDelegate(
              childCount: _newItems.length,
              (_, index) {
                final shouldAnimate = !_animatedItemsIndexes.contains(index);
                if (shouldAnimate) {
                  Future.delayed(widget._fadeInDuration).then((_) {
                    if (context.mounted) {
                      _animatedItemsIndexes.add(index);
                    }
                  });
                }
                return Padding(
                  padding: EdgeInsets.only(
                    top: index == 0 ? 0.0 : widget._spacing,
                  ),
                  child: FadeInWidget(
                    shouldAnimate: shouldAnimate,
                    duration: widget._fadeInDuration,
                    curve: widget._fadeInCurve,
                    child: widget._itemBuilder(
                      _newItems[index],
                      ChatListItemProperties(
                        index: _newItems.length - index - 1,
                        localIndex: index,
                        isInNew: true,
                        isAtTopEdge: index == 0 && _oldItems.isEmpty,
                        isAtBottomEdge: index == _newItems.length - 1,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ),
        SliverPadding(
          key: _centerKey,
          padding: EdgeInsets.only(
            left: widget._padding?.left ?? 0.0,
            top: widget._padding?.top ?? 0.0,
            right: widget._padding?.right ?? 0.0,
          ),
          sliver: SliverList(
            delegate: SliverChildBuilderDelegate(
              childCount: _oldItems.length,
              (_, index) => Padding(
                padding: EdgeInsets.only(
                  bottom: _newItems.isEmpty && index == 0 ? 0 : widget._spacing,
                ),
                child: widget._itemBuilder(
                  _oldItems[index],
                  ChatListItemProperties(
                    index: _newItems.length + index,
                    localIndex: index,
                    isInNew: false,
                    isAtTopEdge: index == _oldItems.length - 1,
                    isAtBottomEdge: index == 0 && _newItems.isEmpty,
                  ),
                ),
              ),
            ),
          ),
        ),
        if (_isLoadingMore && !widget._controller.didLoadAll)
          SliverToBoxAdapter(
            child: widget._loadingMoreWidget ??
                const Padding(
                  padding: EdgeInsets.only(top: 16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircularProgressIndicator(),
                    ],
                  ),
                ),
          ),
      ],
    );
  }

  void _controllerListener() {
    setState(() {});

    if (widget._controller.lastAddedToBottom) {
      _queueNextAnimation();
      if (_isAtBottom) {
        _runAnimation();
      }
    }
  }

  void _scrollListener() {
    if (_isAtTop) {
      _loadMore();
    }
    if (_scrollController.position.userScrollDirection == ScrollDirection.reverse) {
      _clearQueue();
    }
  }

  void _loadMore() async {
    if (!_isLoadingMore && !widget._controller.didLoadAll) {
      setState(() => _isLoadingMore = true);
      _animateToMaxScrollExtent();

      final hasMoreMessages = await widget._onLoadMoreCallback?.call() ?? true;
      widget._controller.setDidLoadAll(!hasMoreMessages);

      setState(() => _isLoadingMore = false);
    }
  }

  void _animateToMaxScrollExtent() => WidgetsBinding.instance.addPostFrameCallback(
        (_) => _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 100),
          curve: Curves.easeOut,
        ),
      );

  void _queueNextAnimation() => _animationQueue.add(true);

  void _clearQueue() {
    if (_animationQueue.isNotEmpty) {
      _animationQueue.clear();
    }
  }

  void _runAnimation() {
    if (_isAnimationRunning) {
      return;
    }
    _isAnimationRunning = true;
    WidgetsBinding.instance.addPostFrameCallback(
      (_) async {
        while (_animationQueue.isNotEmpty) {
          if (widget._useJumpTo) {
            _scrollController.jumpTo(_scrollController.position.minScrollExtent);
          } else {
            _scrollController.animateTo(
              _scrollController.position.minScrollExtent,
              duration: widget._animateToDuration,
              curve: widget._animateToCurve,
            );
            await Future.delayed(widget._animateToDuration);
          }
          if (_animationQueue.isNotEmpty) {
            _animationQueue.removeFirst();
          }
        }
        _isAnimationRunning = false;
      },
    );
  }

  @override
  void dispose() {
    widget._controller.removeListener(_controllerListener);
    _scrollController.removeListener(_scrollListener);
    _scrollController.dispose();
    super.dispose();
  }
}
