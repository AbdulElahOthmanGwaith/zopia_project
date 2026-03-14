class AdModel {
  final String id;
  final String sellerId;
  final String sellerName;
  final String sellerPhoto;
  final String title;
  final String description;
  final double price;
  final String currency;
  final List<String> imageUrls;
  final String category;
  final String condition; // 'new', 'used', 'refurbished'
  final String location;
  final bool isFeatured;
  final bool isSold;
  final DateTime createdAt;

  AdModel({
    required this.id,
    required this.sellerId,
    required this.sellerName,
    required this.sellerPhoto,
    required this.title,
    required this.description,
    required this.price,
    this.currency = 'SAR',
    this.imageUrls = const [],
    required this.category,
    this.condition = 'new',
    required this.location,
    this.isFeatured = false,
    this.isSold = false,
    required this.createdAt,
  });

  factory AdModel.fromMap(Map<String, dynamic> map) {
    return AdModel(
      id: map['id'] ?? '',
      sellerId: map['sellerId'] ?? '',
      sellerName: map['sellerName'] ?? '',
      sellerPhoto: map['sellerPhoto'] ?? '',
      title: map['title'] ?? '',
      description: map['description'] ?? '',
      price: (map['price'] ?? 0).toDouble(),
      currency: map['currency'] ?? 'SAR',
      imageUrls: List<String>.from(map['imageUrls'] ?? []),
      category: map['category'] ?? '',
      condition: map['condition'] ?? 'new',
      location: map['location'] ?? '',
      isFeatured: map['isFeatured'] ?? false,
      isSold: map['isSold'] ?? false,
      createdAt: map['createdAt'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['createdAt'])
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() => {
        'id': id,
        'sellerId': sellerId,
        'sellerName': sellerName,
        'sellerPhoto': sellerPhoto,
        'title': title,
        'description': description,
        'price': price,
        'currency': currency,
        'imageUrls': imageUrls,
        'category': category,
        'condition': condition,
        'location': location,
        'isFeatured': isFeatured,
        'isSold': isSold,
        'createdAt': createdAt.millisecondsSinceEpoch,
      };
}

const List<String> adCategories = [
  'إلكترونيات',
  'سيارات',
  'عقارات',
  'ملابس',
  'أثاث',
  'هواتف',
  'رياضة',
  'كتب',
  'أخرى',
];
