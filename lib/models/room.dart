class Room {
  final String id;
  final String type;
  final String city;
  final double price;
  final String address;
  final String description;
  final List<String> facilities;

  Room({
    required this.id,
    required this.type,
    required this.city,
    required this.price,
    required this.address,
    required this.description,
    required this.facilities,
  });

  String get imageAsset {
    switch (type) {
      case "Deluxe":
        return "assets/deluxe.jpg";
      case "Standard":
        return "assets/std.jpeg";
      default:
        return "assets/reg.jpg";
    }
  }
}
