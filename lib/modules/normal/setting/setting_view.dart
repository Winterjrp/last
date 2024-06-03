import 'package:flutter/material.dart';
import 'package:last/modules/normal/widgets/bottom_navigation_bar.dart';

class SettingView extends StatefulWidget {
  const SettingView({Key? key}) : super(key: key);

  @override
  State<SettingView> createState() => _SettingViewState();
}

class _SettingViewState extends State<SettingView> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            bottomNavigationBar: const ProjectNavigationBar(index: 1),
            body: Padding(
              padding: const EdgeInsets.only(
                  left: 20, right: 20, top: 30, bottom: 30),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "ตั้งค่าการใช้งาน",
                        style: TextStyle(
                            fontSize: 28, fontWeight: FontWeight.bold),
                      ),
                      Text("หมายเลขผู้ใช้งาน: 123456789",
                          style: TextStyle(
                            fontSize: 17,
                          )),
                    ],
                  ),
                  const SizedBox(height: 30),
                  Column(
                    children: [
                      Container(
                        alignment: Alignment.bottomCenter,
                        child: SizedBox(
                          width: double.infinity,
                          height: 50,
                          child: ElevatedButton(
                            onPressed: () {},
                            style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  const Color.fromRGBO(217, 217, 217, 1),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            child: const Text('เปลี่ยนชื่อผู้ใช้งาน',
                                style: TextStyle(
                                    fontSize: 17, color: Colors.black)),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Container(
                        alignment: Alignment.bottomCenter,
                        child: SizedBox(
                          width: double.infinity,
                          height: 50,
                          child: ElevatedButton(
                            onPressed: () {},
                            style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  const Color.fromRGBO(217, 217, 217, 1),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            child: const Text('เปลี่ยนรหัสผ่าน',
                                style: TextStyle(
                                    fontSize: 17, color: Colors.black)),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                    ],
                  )
                ],
              ),
            )));
  }
}
