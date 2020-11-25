class Unit {
  final id;
  final unit_name;
  final address;
  final phone;

  Unit({
    this.id,
    this.unit_name,
    this.address,
    this.phone,
  });

  factory Unit.fromJson(Map<String, dynamic> parsedJson){

    return Unit(
        id: parsedJson['id'],
        unit_name: parsedJson['unit_name'],
        address: parsedJson['address'],
        phone: parsedJson['phone']
    );
  }
}