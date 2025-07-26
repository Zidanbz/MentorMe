import 'package:flutter/material.dart';

class OptimizedListView<T> extends StatefulWidget {
  final List<T> items;
  final Widget Function(BuildContext context, T item, int index) itemBuilder;
  final Future<List<T>> Function()? onLoadMore;
  final Widget? loadingWidget;
  final Widget? emptyWidget;
  final EdgeInsets? padding;
  final ScrollController? controller;
  final bool shrinkWrap;
  final ScrollPhysics? physics;
  final int itemsPerPage;

  const OptimizedListView({
    super.key,
    required this.items,
    required this.itemBuilder,
    this.onLoadMore,
    this.loadingWidget,
    this.emptyWidget,
    this.padding,
    this.controller,
    this.shrinkWrap = false,
    this.physics,
    this.itemsPerPage = 20,
  });

  @override
  State<OptimizedListView<T>> createState() => _OptimizedListViewState<T>();
}

class _OptimizedListViewState<T> extends State<OptimizedListView<T>> {
  late ScrollController _scrollController;
  bool _isLoadingMore = false;
  List<T> _displayedItems = [];

  @override
  void initState() {
    super.initState();
    _scrollController = widget.controller ?? ScrollController();
    _scrollController.addListener(_onScroll);
    _initializeItems();
  }

  @override
  void dispose() {
    if (widget.controller == null) {
      _scrollController.dispose();
    } else {
      _scrollController.removeListener(_onScroll);
    }
    super.dispose();
  }

  void _initializeItems() {
    _displayedItems = widget.items.take(widget.itemsPerPage).toList();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
            _scrollController.position.maxScrollExtent - 200 &&
        !_isLoadingMore &&
        widget.onLoadMore != null &&
        _displayedItems.length < widget.items.length) {
      _loadMoreItems();
    }
  }

  Future<void> _loadMoreItems() async {
    if (_isLoadingMore) return;

    setState(() => _isLoadingMore = true);

    try {
      // Load more items from the original list
      final nextBatch = widget.items
          .skip(_displayedItems.length)
          .take(widget.itemsPerPage)
          .toList();

      if (nextBatch.isNotEmpty) {
        setState(() {
          _displayedItems.addAll(nextBatch);
        });
      }

      // If we need to fetch more data from API
      if (widget.onLoadMore != null &&
          _displayedItems.length >= widget.items.length) {
        final newItems = await widget.onLoadMore!();
        if (newItems.isNotEmpty && mounted) {
          setState(() {
            _displayedItems.addAll(newItems.take(widget.itemsPerPage));
          });
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error loading more items: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoadingMore = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_displayedItems.isEmpty) {
      return widget.emptyWidget ??
          const Center(child: Text('No items available'));
    }

    return ListView.builder(
      controller: _scrollController,
      padding: widget.padding,
      shrinkWrap: widget.shrinkWrap,
      physics: widget.physics,
      itemCount: _displayedItems.length + (_isLoadingMore ? 1 : 0),
      itemBuilder: (context, index) {
        if (index >= _displayedItems.length) {
          return widget.loadingWidget ??
              const Center(
                child: Padding(
                  padding: EdgeInsets.all(16.0),
                  child: CircularProgressIndicator(),
                ),
              );
        }

        return widget.itemBuilder(context, _displayedItems[index], index);
      },
    );
  }
}

// Optimized Grid View
class OptimizedGridView<T> extends StatefulWidget {
  final List<T> items;
  final Widget Function(BuildContext context, T item, int index) itemBuilder;
  final Future<List<T>> Function()? onLoadMore;
  final Widget? loadingWidget;
  final Widget? emptyWidget;
  final EdgeInsets? padding;
  final ScrollController? controller;
  final bool shrinkWrap;
  final ScrollPhysics? physics;
  final int crossAxisCount;
  final double crossAxisSpacing;
  final double mainAxisSpacing;
  final double childAspectRatio;
  final int itemsPerPage;

  const OptimizedGridView({
    super.key,
    required this.items,
    required this.itemBuilder,
    this.onLoadMore,
    this.loadingWidget,
    this.emptyWidget,
    this.padding,
    this.controller,
    this.shrinkWrap = false,
    this.physics,
    this.crossAxisCount = 2,
    this.crossAxisSpacing = 8.0,
    this.mainAxisSpacing = 8.0,
    this.childAspectRatio = 1.0,
    this.itemsPerPage = 20,
  });

  @override
  State<OptimizedGridView<T>> createState() => _OptimizedGridViewState<T>();
}

class _OptimizedGridViewState<T> extends State<OptimizedGridView<T>> {
  late ScrollController _scrollController;
  bool _isLoadingMore = false;
  List<T> _displayedItems = [];

  @override
  void initState() {
    super.initState();
    _scrollController = widget.controller ?? ScrollController();
    _scrollController.addListener(_onScroll);
    _initializeItems();
  }

  @override
  void dispose() {
    if (widget.controller == null) {
      _scrollController.dispose();
    } else {
      _scrollController.removeListener(_onScroll);
    }
    super.dispose();
  }

  void _initializeItems() {
    _displayedItems = widget.items.take(widget.itemsPerPage).toList();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
            _scrollController.position.maxScrollExtent - 200 &&
        !_isLoadingMore &&
        widget.onLoadMore != null &&
        _displayedItems.length < widget.items.length) {
      _loadMoreItems();
    }
  }

  Future<void> _loadMoreItems() async {
    if (_isLoadingMore) return;

    setState(() => _isLoadingMore = true);

    try {
      final nextBatch = widget.items
          .skip(_displayedItems.length)
          .take(widget.itemsPerPage)
          .toList();

      if (nextBatch.isNotEmpty) {
        setState(() {
          _displayedItems.addAll(nextBatch);
        });
      }

      if (widget.onLoadMore != null &&
          _displayedItems.length >= widget.items.length) {
        final newItems = await widget.onLoadMore!();
        if (newItems.isNotEmpty && mounted) {
          setState(() {
            _displayedItems.addAll(newItems.take(widget.itemsPerPage));
          });
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error loading more items: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoadingMore = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_displayedItems.isEmpty) {
      return widget.emptyWidget ??
          const Center(child: Text('No items available'));
    }

    return GridView.builder(
      controller: _scrollController,
      padding: widget.padding,
      shrinkWrap: widget.shrinkWrap,
      physics: widget.physics,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: widget.crossAxisCount,
        crossAxisSpacing: widget.crossAxisSpacing,
        mainAxisSpacing: widget.mainAxisSpacing,
        childAspectRatio: widget.childAspectRatio,
      ),
      itemCount: _displayedItems.length + (_isLoadingMore ? 1 : 0),
      itemBuilder: (context, index) {
        if (index >= _displayedItems.length) {
          return widget.loadingWidget ??
              const Center(child: CircularProgressIndicator());
        }

        return widget.itemBuilder(context, _displayedItems[index], index);
      },
    );
  }
}
