// file นี้ประกอบด้วน code คำสั่งที่ทำงานกับ  supabase
// เช่น upload file , add , delete ,search ข้อมูล, และอื่นๆ ที่เกี่ยวข้องกับการเชื่อมต่อกับ database ของ supabase
// ignore_for_file: unused_local_variable, duplicate_import, depend_on_referenced_packages, unused_import

import 'package:flutter_food_tracker/models/food.dart';
import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseService {
  //***สิ่งสำคัญจะต้องสร้าง instance ที่จะทำงานกับ supabase
  final supabase = Supabase.instance.client;

  //--- ต่อจากนี้จะเป็น  method ที่จะทำงานกับ supabase
  // method upload file ที่อยู่ใน storage ของ supabase
  Future<String> uploadImageFile(XFile xfile) async {
    //ตั้งชื่อ file ให้ไม่ซ้ำกัน เวลาอยู่ บน bucket
    final newFileName =
        '${DateTime.now().millisecondsSinceEpoch}.${xfile.name}';

    //upload file
    await supabase.storage.from('food_tracker_bk').uploadBinary(
          newFileName,
          await xfile.readAsBytes(),
          fileOptions: FileOptions(contentType: xfile.mimeType),
        );

    //คืนค่าที่อยู่ของ file ใน bucket
    return supabase.storage.from('food_tracker_bk').getPublicUrl(newFileName);
  }

  // method เพิ่มข้อมูลลงใน table ของ supabase
  Future<void> insertFood(Food food) async {
    await supabase.from('food_tracker_tb').insert(food.toJson());
  }

  //method ดึงข้อมูลจาก table ของ supabase
  Future<List<Food>> getAllFoods() async {
    //คำสั่งดึงข้อมูลจาก table ของ supabase
    final runs = await supabase.from('food_tracker_tb').select('*');
    //เอาข้อมูลที่ดึงมา แปลงเป้น object ที่ใช้
    return runs.map((e) => Food.fromJson(e)).toList();
  }

  // method ลบข้อมูลจาก bucket ใน storage ของ supabase
  Future<void> deleteImageFile(String fileName) async {
    await supabase.storage.from('food_tracker_bk').remove([fileName]);
  }

  //methood แก้ไขข้อมูลใน table ของ supabase
  Future<void> updateFood(Food food, String id) async {
    await supabase.from('food_tracker_tb').update(food.toJson()).eq('id', id);
  }

  //method ลบข้อมูลใน table ของ supabase
  Future<void> deleteRun(String id) async {
    await supabase.from('food_tracker_tb').delete().eq('id', id);
  }
}
