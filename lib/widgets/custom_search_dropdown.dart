import 'package:flutter/material.dart';

class CustomDropdownSearch<T> extends StatelessWidget {
  final List<T> items;
  final String Function(T) itemLabel;
  final ValueChanged<T> onChanged;
  final T? selectedItem;
  final String hintText;

  const CustomDropdownSearch({
    super.key,
    required this.items,
    required this.itemLabel,
    required this.onChanged,
    this.selectedItem,
    this.hintText = 'Pilih item',
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => _showSearchDialog(context),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.black),
          borderRadius: BorderRadius.all(Radius.elliptical(4, 4)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                overflow: TextOverflow.ellipsis,
                // maxLines: 1,
                selectedItem != null ? itemLabel(selectedItem as T) : hintText,
                style: TextStyle(
                  color: selectedItem != null ? Colors.black : Colors.grey,
                  fontSize: 16,
                ),
              ),
            ),
            const Icon(Icons.arrow_drop_down),
          ],
        ),
      ),
    );
  }

  void _showSearchDialog(BuildContext context) {
    showModalBottomSheet(
      context: context,
      // isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return SizedBox(
          height: MediaQuery.of(context).size.height * 0.5,
          child: _DropdownSearchDialog<T>(
            items: items,
            itemLabel: itemLabel,
            onItemSelected: (value) {
              Navigator.pop(context);
              onChanged(value);
            },
          ),
        );
      },
    );
  }
}

class _DropdownSearchDialog<T> extends StatefulWidget {
  final List<T> items;
  final String Function(T) itemLabel;
  final ValueChanged<T> onItemSelected;

  const _DropdownSearchDialog({
    super.key,
    required this.items,
    required this.itemLabel,
    required this.onItemSelected,
  });

  @override
  State<_DropdownSearchDialog<T>> createState() =>
      _DropdownSearchDialogState<T>();
}

class _DropdownSearchDialogState<T> extends State<_DropdownSearchDialog<T>> {
  String query = '';

  @override
  Widget build(BuildContext context) {
    final filteredItems = widget.items
        .where(
          (item) => widget
              .itemLabel(item)
              .toLowerCase()
              .contains(query.toLowerCase()),
        )
        .toList();

    return Padding(
      padding: MediaQuery.of(context).viewInsets,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: TextField(
              autofocus: false,
              decoration: const InputDecoration(
                hintText: 'Cari...',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                setState(() {
                  query = value;
                });
              },
            ),
          ),
          const SizedBox(height: 8),
          Flexible(
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: filteredItems.length,
              itemBuilder: (context, index) {
                final item = filteredItems[index];
                return ListTile(
                  title: Text(
                    widget.itemLabel(item),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                  onTap: () => widget.onItemSelected(item),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
