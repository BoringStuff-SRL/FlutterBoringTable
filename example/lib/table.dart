import 'package:boring_table/boring_table.dart';
import 'package:flutter/material.dart';

import 'model.dart';

class PersonTable extends StatelessWidget {
  PersonTable({super.key});

  static final List<Person> userList = [
    Person(id: 0, name: 'Francesco', surname: 'De Salvo'),
    Person(id: 1, name: 'Enzo', surname: 'De Simone'),
    Person(id: 2, name: 'Leonardo', surname: 'Valente'),
    Person(id: 3, name: 'Riccardo', surname: 'Gabellone'),
    Person(id: 4, name: 'Mattia', surname: 'Donadio')
  ];

  final ValueNotifier<bool> _isSelected = ValueNotifier(false);

  @override
  Widget build(BuildContext context) {
    return BoringFilterTable<Person>(
      headerRow: RowElementClass(isSelected: _isSelected, items: userList)
          .tableHeader(),
      filterColumnStyle: BoringFilterColumnStyle(),
      rowActionsColumnLabel: "More",
      toTableRow: (dynamic user) async {
        return [
          ValueListenableBuilder(
            valueListenable: _isSelected,
            builder: (BuildContext context, bool value, Widget? child) {
              if (value) {
                return Row(children: [
                  Icon(Icons.check_box),
                  SizedBox(width: 10),
                  Text(user.name)
                ]);
              } else {
                return Row(children: [
                  Icon(Icons.check_box_outline_blank),
                  SizedBox(width: 10),
                  Text(user.id.toString())
                ]);
              }
            },
          ),
          Text(user.name),
          Text(user.surname),
        ];
      },
      rawItems: userList,
      decoration: BoringTableDecoration(
        prototypeItem: true,
          showDivider: true,
          evenRowColor: Colors.purple,
          oddRowColor: Colors.pink),
      groupActions: true,
      groupActionsMenuShape: 10,
      groupActionsWidget: const Icon(
        Icons.more_vert,
        color: Colors.amber,
      ),
      filterStyle: BoringFilterStyle(
        chipThemeData: ChipThemeData(
          selectedColor: Colors.red,
          pressElevation: 0,
          labelStyle: TextStyle(
            color: Colors.white,
          ),
        ),
        openFiltersDialogWidget: Icon(Icons.abc),
        titleStyle: TextStyle(fontWeight: FontWeight.bold, color: Colors.red),
        hintStyle: TextStyle(color: Colors.amber),
        textInputDecoration: const InputDecoration(
          focusedBorder:
              OutlineInputBorder(borderSide: BorderSide(color: Colors.red)),
          border: OutlineInputBorder(borderSide: BorderSide(color: Colors.red)),
        ),
        dropdownBoxDecoration: BoxDecoration(
          border: Border.all(color: Colors.red),
        ),
        filterDialogTitle: Text('FILTRIIIIIIII'),
        applyFiltersText: "APPLICA",
        removeFiltersText: "RIMUOVI",
        applyFiltersButtonStyle: ButtonStyle(
          backgroundColor:
              MaterialStateColor.resolveWith((states) => Colors.red),
        ),
        removeFiltersButtonStyle: ButtonStyle(
          backgroundColor:
              MaterialStateColor.resolveWith((states) => Colors.black),
        ),
      ),
      filters: [
        BoringTextFilter(
          //type: BoringFilterType.text
          title: 'Nome',
          where: (element, controller) {
            if (controller.value != null) {
              return (element).name.contains(controller.value);
            }
            return true;
          },
          valueController: BoringFilterValueController<String>(),
          hintText: 'Inserisci nome',
        ),
        BoringDropdownMultiChoiceFilter(
          title: 'Cognome',
          searchMatchFn: (dropdownMenuItem, value) {
            return dropdownMenuItem.value
                .toString()
                .toLowerCase()
                .contains(value.toLowerCase());
          },
          values: [
            'asd',
            'qwe',
          ],
          showingValues: [
            'asd',
            'qwe',
          ],
          where: (element, controller) {
            if (controller.value != null &&
                (controller.value as List).isNotEmpty) {
              return (controller.value as List).contains(element.name);
            }
            return true;
          },
          valueController:
              BoringFilterValueController<List<String>>(initialValue: []),
          hintText: 'Seleziona cognome',
        ),
        BoringChipFilter(
          title: 'Stato',
          showingValues: [
            'Attivo',
            'Non attivo',
          ],
          values: [
            'active',
            'notactive',
          ],
          where: (element, controller) {
            return true;
          },
          valueController:
              BoringFilterValueController<List<String>>(initialValue: []),
        ),
      ],
      actionGroupTextStyle: TextStyle(color: Colors.red),
      rowActions: [
        BoringFilterRowAction(
            icon: Icon(Icons.add),
            buttonText: "svuota",
            onTap: (c) {
              print((c as Person).name);
            }),
        BoringFilterRowAction(
            icon: Icon(Icons.add),
            buttonText: "carica",
            onTap: (c) {
              print((c as Person).name);
            }),
        BoringFilterRowAction(
            buttonText: "quantità",
            onTap: (c) {
              print((c as Person).name);
            }),
      ],
      title: BoringTableTitle(
        actions: [
          ElevatedButton(
              onPressed: () => print("PRESSED"), child: Text("PRESS ME"))
        ],
        title: Text("Titolo"),
      ),
    );
  }
}

class RowElementClass {
  final ValueNotifier<bool>? isSelected;
  final List<Person> items;

  RowElementClass({this.isSelected, required this.items});

  List<TableHeaderElement> tableHeader() {
    return [
      TableHeaderElement.selectedAll(
          label: "ID",
          tableHeaderDecoration: TableHeaderDecoration(),
          showOnColumFilter: false,
          orderBy: () async {
            List<Person> a = items.toList();
            a.sort((c, b) => c.id.compareTo(b.id));
            return a;
          },
          onPressed: (value) async {}),
      TableHeaderElement(
          label: "Name",
          tableHeaderDecoration: TableHeaderDecoration(),
          orderBy: () async {
            List<Person> a = items.toList();
            a.sort((c, b) => c.name.compareTo(b.name));
            return a;
          }),
      TableHeaderElement(
          label: "Surname",
          tableHeaderDecoration: TableHeaderDecoration(),
          orderBy: () async {
            List<Person> a = items.toList();
            a.sort((c, b) => c.id.compareTo(b.id));
            return a;
          }),
    ];
  }
}
