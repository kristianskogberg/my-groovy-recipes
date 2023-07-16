class Ingredient {
  double amount;
  String name;
  Ingredient({required this.amount, required this.name});

  Map<String, dynamic> toJson() {
    return {
      "amount": amount,
      "name": name,
    };
  }

  factory Ingredient.fromJson(Map<String, dynamic> json) {
    return Ingredient(
      amount: json["amount"],
      name: json["name"],
    );
  }
}
