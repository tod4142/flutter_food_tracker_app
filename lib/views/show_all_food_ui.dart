// ignore_for_file: unused_import, sort_child_properties_last

import 'package:flutter/material.dart';
import 'package:flutter_food_tracker/models/food.dart';
import 'package:flutter_food_tracker/services/supabase_service.dart';
import 'package:flutter_food_tracker/views/add_food_ui.dart';
import 'package:flutter_food_tracker/views/update_delete_ui.dart';

class ShowAllFoodUI extends StatefulWidget {
  const ShowAllFoodUI({super.key});

  @override
  State<ShowAllFoodUI> createState() => _ShowAllFoodUIState();
}

class _ShowAllFoodUIState extends State<ShowAllFoodUI> {
  //สร้างตัวแปรเก็บข้อมูลที่ดึงจาก supabase
  List<Food>? foodData;

  //สร้างคำสั่งเพื่อดึงข้อมูลมาแสดง
  Future<void> fetchFoodData() async {
    final data = await SupabaseService().getAllFoods();
    setState(() {
      foodData = data;
    });
  }

  @override
  void initState() {
    //เรียกใช้งานฟังก์ชัน fetchFoodData ในส่วนนี้
    fetchFoodData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //appBAr
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 244, 67, 54),
        title: Text(
          'FOOD TRACKER',
          style: TextStyle(
            color: Colors.white,
            // fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          //เปิดหน้า add run ui แบบกลับได้
          await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddFoodUI(),
              //builder: (context) => const UpdateDeleteUI(),
            ),
          );
          //เรียกให้ดึงข้อมูล
          fetchFoodData();
        },
        child: Icon(
          Icons.add,
          color: Colors.white,
        ),
        backgroundColor: const Color.fromARGB(255, 244, 67, 54),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      //body
      body: Center(
        child: Column(
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.035,
            ),
            Image.asset(
              'assets/images/burger.png',
              height: MediaQuery.of(context).size.height * 0.23,
              width: MediaQuery.of(context).size.height * 0.23,
              fit: BoxFit.cover,
            ),

            SizedBox(
              height: MediaQuery.of(context).size.height * 0.02,
            ),
            //ต่อไปเป็นส่วนของ แสดงข้อมูล จาก supabase
            // ?? เรียกว่า isnull operator
            Expanded(
              child: ListView.separated(
                itemCount: foodData?.length ?? 0,
                // เปลี่ยนจาก Divider เป็นช่องว่าง
                separatorBuilder: (context, index) => const SizedBox(height: 8),
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.only(
                      left: 20.0,
                      right: 20.0,
                    ),
                    child: ListTile(
                      // มุมโค้งของกล่อง
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      onTap: () async {
                        await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                UpdateDeleteUI(foodDetail: foodData![index]),
                          ),
                        );
                      },
                      tileColor: index % 2 == 0
                          ? const Color.fromARGB(255, 235, 245, 255)
                          : const Color.fromARGB(255, 255, 235, 235),
                      title: Text(
                        "กิน: ${foodData![index].foodName!}",
                      ),
                      subtitle: Text(
                        "วันที่: ${foodData![index].foodDate!}  มื้อ: ${foodData![index].foodMeal!}",
                      ),
                      trailing: const Icon(
                        Icons.arrow_forward_ios,
                        color: Color.fromARGB(255, 244, 67, 54),
                      ),
                      // รูปมุมโค้งเล็กน้อย
                      leading: ClipRRect(
                        borderRadius: BorderRadius.circular(5),
                        child: foodData![index].foodImageUrl! == ''
                            ? Image.asset(
                                'assets/images/burger.png',
                                width: 50,
                                height: 50,
                                fit: BoxFit.cover,
                              )
                            : Image.network(
                                foodData![index].foodImageUrl!,
                                width: 50,
                                height: 50,
                                fit: BoxFit.cover,
                              ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
