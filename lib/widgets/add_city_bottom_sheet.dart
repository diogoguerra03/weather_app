import 'package:flutter/material.dart';
import '../data/portugal_cities.dart';
import '../models/city.dart';

class AddCityBottomSheet extends StatefulWidget {
  final String title;
  final String hintText;
  final String buttonText;
  final void Function(City)? onCitySelected;
  final List<City> existingCities;
  const AddCityBottomSheet({
    super.key,
    this.title = 'Add City',
    this.hintText = 'Enter city name',
    this.buttonText = 'Add',
    this.onCitySelected,
    this.existingCities = const [],
  });

  @override
  State<AddCityBottomSheet> createState() => _AddCityBottomSheetState();
}

class _AddCityBottomSheetState extends State<AddCityBottomSheet> {
  String input = '';
  String? errorText;
  bool loading = false;
  final TextEditingController _controller = TextEditingController();
  List<City> suggestions = [];

  void _updateSuggestions(String value) {
    final existingNames = widget.existingCities
        .map((c) => c.name.toLowerCase())
        .toSet();
    setState(() {
      input = value;
      suggestions = portugalCities
          .where(
            (c) =>
                c.name.toLowerCase().contains(value.toLowerCase()) &&
                !existingNames.contains(c.name.toLowerCase()),
          )
          .toList();
    });
  }

  void _selectSuggestion(City city) {
    _controller.text = city.name;
    setState(() {
      input = city.name;
      suggestions = [];
    });
    Navigator.of(context).pop(city);
  }

  Future<void> _tryAdd() async {
    setState(() {
      errorText = null;
      loading = true;
    });
    final match = portugalCities.firstWhere(
      (c) => c.name.toLowerCase() == input.trim().toLowerCase(),
      orElse: () => City(id: -1, name: input.trim()),
    );
    if (match.id != -1) {
      Navigator.of(context).pop(match);
    } else {
      setState(() {
        errorText = 'Cidade não encontrada.';
        loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: 24,
        right: 24,
        top: 24,
        bottom: MediaQuery.of(context).viewInsets.bottom + 24,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            widget.title,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _controller,
            autofocus: true,
            decoration: InputDecoration(
              hintText: widget.hintText,
              border: const OutlineInputBorder(),
              errorText: errorText,
            ),
            onChanged: _updateSuggestions,
            onSubmitted: (v) => _tryAdd(),
          ),
          if (suggestions.isNotEmpty)
            Container(
              constraints: const BoxConstraints(maxHeight: 180),
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: suggestions.length,
                itemBuilder: (ctx, i) {
                  final city = suggestions[i];
                  return ListTile(
                    title: Text(city.name),
                    onTap: () => _selectSuggestion(city),
                  );
                },
              ),
            ),
          const SizedBox(height: 16),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Color(0xFF362A84),
              foregroundColor: Colors.white,
              textStyle: const TextStyle(fontWeight: FontWeight.bold),
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
            ),
            onPressed: input.trim().isEmpty || loading ? null : _tryAdd,
            child: loading
                ? const SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : Text(widget.buttonText),
          ),
        ],
      ),
    );
  }
}
