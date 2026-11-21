// ignore_for_file: non_constant_identifier_names, unused_local_variable, use_build_context_synchronously, sort_child_properties_last, empty_statements

import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_food_tracker/models/food.dart';
import 'package:flutter_food_tracker/services/supabase_service.dart';
import 'package:image_picker/image_picker.dart';

class AddFoodUI extends StatefulWidget {
  const AddFoodUI({super.key});

  @override
  State<AddFoodUI> createState() => _AddFoodUIState();
}

class _AddFoodUIState extends State<AddFoodUI> {
  //foodMeal
  String foodMeal = 'เช้า'; // ค่าเริ่มต้น
  final List<String> mealList = ['เช้า', 'กลางวัน', 'เย็น', 'ว่าง'];

  //----ส่วนของ code ที่เกียวกับ กล้อง , แกลลอรี่ และ
  Uint8List? imageBytes; //เอาไว้เก็บรูป เพื่อแสดงที่หน้าจอ
  XFile? imageFile; //เอาไว้เก็บรูป เพื่อ upload to bucket

  //เปิดกล้อง
  Future<void> selectImageFromCamera() async {
    imageFile = await ImagePicker()
        .pickImage(source: ImageSource.camera, imageQuality: 80);

    //ตรวจสอบว่าได้เลือกมั้ย
    if (imageFile != null) {
      final byte = await imageFile!.readAsBytes();
      setState(() {
        imageBytes = byte;
      });
    }
  }

  //เปิดแกลลอรี่
  Future<void> selectImageFromGallery() async {
    imageFile = await ImagePicker()
        .pickImage(source: ImageSource.gallery, imageQuality: 80);

    //ตรวจสอบว่าได้เลือกมั้ย
    if (imageFile != null) {
      final byte = await imageFile!.readAsBytes();
      setState(() {
        imageBytes = byte;
      });
    }
  }

  //----ส่วนของ code upload and save

  //ตัวแปรเก็บ file ที่ upload
  String imageURL = "";
  //สร้างตัวควบคุม textfield
  TextEditingController FoodNameCtrl = TextEditingController();
  TextEditingController FoodDateCtrl = TextEditingController();
  TextEditingController FoodPersonCtrl = TextEditingController();
  TextEditingController FoodPriceCtrl = TextEditingController();

  Future<void> uploadAndSaveData() async {
    // 1) validate ก่อน
    if (FoodNameCtrl.text.isEmpty ||
        FoodPersonCtrl.text.isEmpty ||
        FoodPriceCtrl.text.isEmpty ||
        FoodDateCtrl.text.isEmpty ||
        foodMeal.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(' ⚠ กรุณากรอกข้อมูลให้ครบถ้วน',
              style: TextStyle(color: Colors.white)),
          duration: Duration(seconds: 2),
          backgroundColor: const Color.fromARGB(255, 244, 67, 54),
        ),
      );
      return;
    }
    // 2) แล้วค่อยอัปโหลดรูป
    if (imageFile != null) {
      imageURL = await SupabaseService().uploadImageFile(imageFile!);
    }
    // 3) pack data แล้วส่ง
    Food FoodData = Food(
      foodName: FoodNameCtrl.text,
      foodDate: FoodDateCtrl.text,
      foodMeal: foodMeal,
      foodPrice: FoodPriceCtrl.text,
      foodPerson: FoodPersonCtrl.text,
      foodImageUrl: imageURL,
    );
    //ส่ง data to table
    await SupabaseService().insertFood(FoodData);
    //แจ้งเตือน
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          ' ✅ บันทึกข้อมูลเรียบร้อย',
          style: TextStyle(color: Colors.white),
        ),
        duration: Duration(seconds: 2),
        backgroundColor: const Color.fromARGB(255, 76, 175, 80),
      ),
    );
    //กลับไปหน้า ShowAllRun
    Navigator.pop(context);
  }
  //-------------------------

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 244, 67, 54),
        title: Text(
          'FOOD TRACKER (เพิ่ม)',
          style: TextStyle(
            color: Colors.white,
            // fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(
            Icons.arrow_back_ios,
            color: Colors.white,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsetsGeometry.only(
            top: 50,
            bottom: 50,
            left: 45,
            right: 45,
          ),
          child: Center(
            child: Column(
              children: [
                imageBytes == null
                    ? InkWell(
                        onTap: () {
                          selectImageFromGallery();
                        },
                        child: Icon(
                          Icons.camera_enhance_outlined,
                          size: MediaQuery.of(context).size.width * 0.45,
                          color: Colors.grey,
                        ),
                      )
                    : InkWell(
                        onTap: () {
                          selectImageFromGallery();
                        },
                        child: Image.memory(
                          imageBytes!,
                          width: MediaQuery.of(context).size.width * 0.45,
                          height: MediaQuery.of(context).size.width * 0.45,
                          fit: BoxFit.cover,
                        ),
                      ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.035,
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'กินอะไร',
                    style: TextStyle(
                      color: const Color.fromARGB(255, 0, 0, 0),
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                ),
                TextField(
                  controller: FoodNameCtrl,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                    hintText: 'เช่น KFC, Pizza ...',
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.015,
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'กินมื้อไหน',
                    style: TextStyle(
                      color: const Color.fromARGB(255, 0, 0, 0),
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: mealList.map((m) {
                    final selected = foodMeal == m;
                    return ChoiceChip(
                      label: Text(m),
                      selected: selected,
                      showCheckmark: false,
                      // สี
                      selectedColor: const Color.fromARGB(255, 76, 175, 80),
                      backgroundColor: const Color.fromARGB(255, 158, 158, 158),
                      // ทรงแคปซูล ไม่มีขอบ
                      shape: const StadiumBorder(),
                      side: BorderSide.none,
                      // เงาบางๆ แบบของอาจารย์
                      elevation: 3,
                      shadowColor: Colors.black45,
                      // ขนาดปุ่ม
                      labelPadding: const EdgeInsets.symmetric(
                          horizontal: 18, vertical: 5),
                      labelStyle: TextStyle(
                        fontSize: 14,
                        color: selected
                            ? const Color.fromARGB(255, 255, 255, 255)
                            : const Color.fromARGB(255, 255, 255, 255),
                      ),
                      onSelected: (_) {
                        setState(() {
                          foodMeal = m;
                        });
                      },
                    );
                  }).toList(),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.015,
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'กินไปเท่าไหร่',
                    style: TextStyle(
                      color: const Color.fromARGB(255, 0, 0, 0),
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                ),
                TextField(
                  controller: FoodPriceCtrl,
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                    hintText: 'เช่น 100, 200, 300...',
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.015,
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'กินกี่คน',
                    style: TextStyle(
                      color: const Color.fromARGB(255, 0, 0, 0),
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                ),
                TextField(
                  controller: FoodPersonCtrl,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                    hintText: 'เช่น 1 , 2 , 3 ...',
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.015,
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'กินวันไหน',
                    style: TextStyle(
                      color: const Color.fromARGB(255, 0, 0, 0),
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                ),
                TextField(
                  controller: FoodDateCtrl,
                  readOnly: true, // กันไม่ให้คีย์บอร์ดเด้งขึ้นมา
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                    hintText: 'เช่น 2020-01-31',
                    suffixIcon: const Icon(Icons.calendar_today_outlined),
                  ),
                  onTap: () async {
                    final DateTime? picked = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(2000),
                      lastDate: DateTime(2100),
                    );

                    if (picked != null) {
                      setState(() {
                        FoodDateCtrl.text =
                            '${picked.year}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}';
                      });
                    }
                  },
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.04,
                ),
                ElevatedButton(
                  onPressed: () {
                    //upload รูป ไปยัง bucket และบันทึก ลง table
                    //แต่ code มันยาว ขอทำ method ฃื่อ uploadAndSaveData ไว้ด้านบน
                    uploadAndSaveData();
                  },
                  child: Text(
                    'บันทึกข้อมูล',
                    style: TextStyle(
                      color: Colors.white,
                      //fontWeight: FontWeight.bold,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 76, 175, 80),
                    fixedSize: Size(
                      MediaQuery.of(context).size.width,
                      55.0,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.02,
                ),
                ElevatedButton(
                  onPressed: () {
                    //กดปุ่มเพื่อ clear หน้าจอ
                    setState(() {
                      imageBytes = null;
                      imageFile = null;
                      FoodNameCtrl.clear();
                      foodMeal = 'เช้า';
                      FoodDateCtrl.clear();
                      FoodPersonCtrl.clear();
                      FoodPriceCtrl.clear();
                    });
                  },
                  child: Text(
                    'ยกเลิก',
                    style: TextStyle(
                      color: Colors.white,
                      //fontWeight: FontWeight.bold,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 244, 67, 54),
                    fixedSize: Size(
                      MediaQuery.of(context).size.width,
                      55.0,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
