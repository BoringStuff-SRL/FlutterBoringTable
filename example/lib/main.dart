// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:boring_table/boring_table.dart';
import 'package:boring_table/src/filters/boring_filter.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Boring Table example',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: const Example(),
    );
  }
}

class Example extends StatelessWidget {
  const Example({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Boring Table"),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: ExampleBody(),
      ),
    );
  }
}

class Person {
  String name;
  String surname;

  Person({
    required this.name,
    required this.surname,
  });
}

enum UserType {
  admin,
  normal;
}

class ExampleBody extends StatelessWidget {
  ExampleBody({super.key});

  Color getColor(Set<MaterialState> states) {
    const Set<MaterialState> interactiveStates = <MaterialState>{
      MaterialState.pressed, // Any states you want to affect here
      MaterialState.hovered,
      MaterialState.focused,
    };
    if (states.any(interactiveStates.contains)) {
      // if any of the input states are found in our list
      return Colors.transparent;
    }
    return Colors.red; // default color
  }

  List<int> a = [1, 2, 3, 4, 5];

  static final List<Person> userList = List.generate(
    5,
    (index) => Person(name: '$index', surname: 'valente'),
  );

  final ValueNotifier<bool> _isSelected = ValueNotifier(false);

  @override
  Widget build(BuildContext context) {
    return BoringFilterTable<Person>(
      headerRow: RowElementClass(isSelected: _isSelected).tableHeader(),
      filterColumnStyle: BoringFilterColumnStyle(),
      rowActionsColumnLabel: "More",
      toTableRow: (dynamic user) {
        return [
          ValueListenableBuilder(
            valueListenable: _isSelected,
            builder: (BuildContext context, bool value, Widget? child) {
              print('build');
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
                  Text(user.name)
                ]);
              }
            },
          ),
          Text(user.name),
          Text(user.name),
          Text(user.surname),
        ];
      },
      rawItems: userList,
      decoration: BoringTableDecoration(
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
              return (element).name == (controller.value);
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
              print(controller.value);
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
            print(controller.value);
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

  RowElementClass({this.isSelected});

  List<TableHeaderElement> tableHeader() {
    return [
      TableHeaderElement.selectedAll(
          label: "Column A",
          icon: const Icon(Icons.check_box),
          secondaryIcon: const Icon(Icons.check_box_outline_blank),
          onPressed: (value) async {
            if (isSelected != null) {
              isSelected!.value = !isSelected!.value;
            }
          }),
      TableHeaderElement(label: "Column B"),
      TableHeaderElement(label: "Column C"),
      TableHeaderElement(label: "Column D"),
    ];
  }
}
