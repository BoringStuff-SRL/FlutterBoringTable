import 'package:flutter/material.dart';
import 'package:boring_table/boring_table.dart';

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
      body: const Padding(
        padding: EdgeInsets.all(16.0),
        child: ExampleBody(),
      ),
    );
  }
}

class ExampleBody extends StatelessWidget {
  const ExampleBody({super.key});

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

  @override
  Widget build(BuildContext context) {
    return BoringTable.fromList(
      onTap: ((p0) => print("Tapped $p0")),
      headerRow: RowElementClass.tableHeader,
      rowActionsColumnLabel: "More",
      items: list,
      groupActions: true,
      groupActionsMenuShape:
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      groupActionsWidget: const Icon(
        Icons.more_vert,
        color: Colors.amber,
      ),
      actionGroupTextStyle: TextStyle(color: Colors.red),
      rowActions: [
        BoringRowAction(
            icon: Icon(Icons.add),
            buttonText: "asd",
            onTap: (int c) {
              print("ADD $c");
            }),
        BoringRowAction(
            icon: Icon(Icons.add),
            onTap: (int c) {
              print("ADD $c");
            }),
      ],
      title: BoringTableTitle(
        actions: [
          ElevatedButton(
              onPressed: () => print("PRESSED"), child: Text("PRESS ME"))
        ],
        title: "Titolo",
      ),
    );
  }
}

class RowElementClass extends BoringTableRowElement {
  static final tableHeader = [
    TableHeaderElement(label: "Column A"),
    TableHeaderElement(label: "Column B"),
  ];

  @override
  List<Widget> toTableRow() {
    return [
      const Text("Text A"),
      const Text("Text B"),
    ];
  }
}

final list = List.generate(10000, (index) => RowElementClass());
