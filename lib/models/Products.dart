// ignore_for_file: file_names

class Products {
  String description;
  String name;
  int quantity;
  List<String> images;

  Products({
    required this.description,
    required this.name,
    required this.quantity,
    required this.images,
  });

  factory Products.fromJson(Map<String, dynamic> json) => Products(
        description: json["description"],
        name: json["name"],
        quantity: json["quantity"],
        images: List<String>.from(json["images"].map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "description": description,
        "name": name,
        "quantity": quantity,
        "images": List<dynamic>.from(images.map((x) => x)),
      };
}
