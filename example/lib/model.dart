class Person {
  String name;
  String surname;
  int id;

  Person({
    required this.id,
    required this.name,
    required this.surname,
  });

  @override
  String toString() {
    return "id: $id, name: $name, surname: $surname";
  }
}

enum UserType {
  admin,
  normal;
}
