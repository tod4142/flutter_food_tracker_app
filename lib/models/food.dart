// ignore_for_file: non_constant_identifier_names

class Food {
  //ตัวแปรล้อกับ column ในตาราง
  String? id;
  String? created_at;
  String? foodDate;
  String? foodMeal;
  String? foodName;
  String? foodPrice;
  String? foodPerson;
  String? foodImageUrl;

  //constructor
  Food({
    this.id,
    this.created_at,
    this.foodDate,
    this.foodMeal,
    this.foodName,
    this.foodPrice,
    this.foodPerson,
    this.foodImageUrl,
  });

  //แปลงข้อมูล จาก mobile เป็น json เพื่อส่งไป supabase
  Map<String, dynamic> toJson() => {
        // ไม่ส่ง id กับ created_at ให้ supabase สร้างให้เอง
        "foodDate": foodDate,
        "foodMeal": foodMeal,
        "foodName": foodName,
        "foodPrice": double.tryParse(foodPrice ?? ''), // float8
        "foodPerson": int.tryParse(foodPerson ?? ''), // int4
        "foodImageUrl": foodImageUrl,
      };

  //แปลงข้อมูล จาก json ใน supabase เป็น object ใน mobile
  factory Food.fromJson(Map<String, dynamic> json) => Food(
        id: json["id"]?.toString(),
        created_at: json["created_at"]?.toString(),
        foodDate: json["foodDate"]?.toString(),
        foodMeal: json["foodMeal"]?.toString(),
        foodName: json["foodName"]?.toString(),
        foodPrice: json["foodPrice"]?.toString(),
        foodPerson: json["foodPerson"]?.toString(),
        foodImageUrl: json["foodImageUrl"]?.toString(),
      );
}
