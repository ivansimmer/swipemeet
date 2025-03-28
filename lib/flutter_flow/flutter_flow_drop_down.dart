import 'package:flutter/material.dart';

class FlutterFlowDropDown extends StatefulWidget {
  final List<String> items;
  final String? selectedItem;
  final void Function(String?)? onChanged;
  final String hintText;
  final double? width;
  final double? height;
  final TextStyle? textStyle;
  final Color? fillColor;
  final bool isSearchable;
  final bool isMultiSelect;
  final bool isOverButton;
  final bool hidesUnderline;
  final Icon? icon;
  final EdgeInsetsGeometry? margin;
  final Color? borderColor;
  final double? borderWidth;
  final double? borderRadius;
  final double? elevation;

  const FlutterFlowDropDown({
    Key? key,
    required this.items,
    this.selectedItem,
    required this.onChanged,
    required this.hintText,
    this.width,
    this.height,
    this.textStyle,
    this.fillColor,
    this.isSearchable = false,
    this.isMultiSelect = false,
    this.isOverButton = false,
    this.hidesUnderline = true,
    this.icon,
    this.margin,
    this.borderColor,
    this.borderWidth,
    this.borderRadius,
    this.elevation,
  }) : super(key: key);

  @override
  _FlutterFlowDropDownState createState() => _FlutterFlowDropDownState();
}

class _FlutterFlowDropDownState extends State<FlutterFlowDropDown> {
  TextEditingController _searchController = TextEditingController();
  String? _searchQuery;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    List<String> filteredItems = widget.isSearchable
        ? widget.items
            .where((item) => item
                .toLowerCase()
                .contains(_searchQuery?.toLowerCase() ?? ''))
            .toList()
        : widget.items;

    return Container(
      width: widget.width ?? 300,
      height: widget.height ?? 40,
      margin: widget.margin ?? EdgeInsets.zero,
      decoration: BoxDecoration(
        color: widget.fillColor ?? Colors.white,
        borderRadius: BorderRadius.circular(widget.borderRadius ?? 25),
        border: Border.all(
          color: widget.borderColor ?? Colors.black,
          width: widget.borderWidth ?? 1,
        ),
        boxShadow: [
          if (widget.elevation != null)
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              spreadRadius: widget.elevation!,
              blurRadius: 4,
            ),
        ],
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: widget.selectedItem,
          hint: Text(widget.hintText),
          onChanged: widget.onChanged,
          items: filteredItems
              .map((item) => DropdownMenuItem<String>(
                    value: item,
                    child: Text(item, style: widget.textStyle),
                  ))
              .toList(),
          isExpanded: true,
          icon: widget.icon ?? Icon(Icons.keyboard_arrow_down_rounded),
          dropdownColor: widget.fillColor ?? Colors.white,
          style: widget.textStyle,
          isDense: true,
          onTap: widget.isSearchable
              ? () {
                  showSearch(
                    context: context,
                    delegate: _SearchDelegate(
                      items: widget.items,
                      onSelectItem: widget.onChanged,
                    ),
                  );
                }
              : null,
        ),
      ),
    );
  }
}

class _SearchDelegate extends SearchDelegate<String> {
  final List<String> items;
  final void Function(String?)? onSelectItem;

  _SearchDelegate({required this.items, required this.onSelectItem});

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () {
        close(context, '');
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    final results = items
        .where((item) => item.toLowerCase().contains(query.toLowerCase()))
        .toList();

    return ListView(
      children: results
          .map(
            (item) => ListTile(
              title: Text(item),
              onTap: () {
                onSelectItem?.call(item);
                close(context, item);
              },
            ),
          )
          .toList(),
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final suggestions = items
        .where((item) => item.toLowerCase().contains(query.toLowerCase()))
        .toList();

    return ListView(
      children: suggestions
          .map(
            (item) => ListTile(
              title: Text(item),
              onTap: () {
                onSelectItem?.call(item);
                close(context, item);
              },
            ),
          )
          .toList(),
    );
  }
}
