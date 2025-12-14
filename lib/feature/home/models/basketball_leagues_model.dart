class BasketballLeague {
  final int? id;
  final String? name;
  final String? type;
  final String? logo;

  BasketballLeague({this.id, this.name, this.type, this.logo});

  factory BasketballLeague.fromJson(Map<String, dynamic> json) {
    return BasketballLeague(
      id: json['id'] as int?,
      name: json['name'] as String?,
      type: json['type'] as String?,
      logo: json['logo'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'type': type,
    'logo': logo,
  };
}