import 'package:flutter/material.dart';

class MultiSelectChip extends StatefulWidget {
  final List<String> listaValores;
  final List<String> listaSeleccionados;
  final Function(List<String>) onSelectionChanged;

  MultiSelectChip(this.listaValores, this.listaSeleccionados,
      {this.onSelectionChanged} // +added
      );
  @override
  _MultiSelectChipState createState() => _MultiSelectChipState();
}

class _MultiSelectChipState extends State<MultiSelectChip> {
  _buildChoiceList() {
    List<Widget> choices = List();
    widget.listaValores.forEach((item) {
      choices.add(Container(
        padding: const EdgeInsets.all(2.0),
        child: ChoiceChip(
          label: Text(item),
          selected: widget.listaSeleccionados.contains(item),
          selectedColor: Colors.green,
          onSelected: (selected) {
            setState(() {
              widget.listaSeleccionados.contains(item)
                  ? widget.listaSeleccionados.remove(item)
                  : widget.listaSeleccionados.add(item);
              widget.onSelectionChanged(widget.listaSeleccionados);
            });
          },
        ),
      ));
    });
    return choices;
  }

  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: _buildChoiceList(),
    );
  }
}
