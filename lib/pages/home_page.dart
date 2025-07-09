import 'package:absensiq/constant/app_color.dart';
import 'package:absensiq/pages/riwayat_page.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  static const String id = "/home";

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 78, left: 28),
                  child: CircleAvatar(radius: 35),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 70, left: 15),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Semangat Pagi',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 3),
                      Text('Alfarezhi Mohamad Rasidan'),
                      SizedBox(height: 3),
                      Text('123456789'),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 18),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 26),
              child: Container(
                width: 350,
                height: 160,
                decoration: BoxDecoration(
                  color: AppColor.main,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 15, top: 17),
                          child: CircleAvatar(
                            radius: 12,
                            backgroundColor: Color(0xffD9D9D9),
                          ),
                        ),
                        Flexible(
                          child: Padding(
                            padding: const EdgeInsets.only(left: 11, top: 17),
                            child: Text(
                              'Jl. Pangeran Diponegoro No 5, Kec. Medan Petisah, Kota MEdan, Sumatra Utara',
                              style: TextStyle(color: Colors.white),
                              softWrap: true,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 16),
                    Container(
                      width: 300,
                      height: 67,
                      decoration: BoxDecoration(
                        color: Color(0x21113289),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'Check In',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                                Text(
                                  '07 : 50 : 00',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          VerticalDivider(
                            indent: 6,
                            endIndent: 6,
                            color: Colors.white,
                          ),
                          Expanded(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'Check Out',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                                Text(
                                  '17 : 00 : 00',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 14),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 26),
              child: Container(
                width: 350,
                height: 70,
                decoration: BoxDecoration(
                  color: Color(0x3084BFFF),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Padding(
                  padding: const EdgeInsets.only(left: 32, top: 10),
                  child: Row(
                    children: [
                      Column(
                        children: [
                          Text('Distance from place'),
                          Text(
                            'jarak',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(width: 55),
                      TextButton(
                        onPressed: () {},
                        child: Container(
                          width: 100,
                          height: 35,
                          decoration: BoxDecoration(
                            color: AppColor.darkblue,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Center(
                            child: Text(
                              'Open Maps',
                              style: TextStyle(
                                fontSize: 13,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(height: 12),
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30),
                  child: Text(
                    'Riwayat Kehadiran',
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                  ),
                ),
                SizedBox(width: 85),
                TextButton(
                  onPressed: () {
                    Navigator.pushNamed(context, RiwayatPage.id);
                  },
                  child: Text(
                    'Lihat Semua',
                    style: TextStyle(color: Color(0xff113289)),
                  ),
                ),
              ],
            ),
            ListView.builder(
              padding: EdgeInsets.zero,
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: 3,
              itemBuilder: (BuildContext context, int index) {
                return Padding(
                  padding: const EdgeInsets.only(
                    left: 26,
                    right: 26,
                    bottom: 15,
                  ),
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 25, horizontal: 20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: AppColor.border),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          flex: 2,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Monday'),
                              SizedBox(height: 4),
                              Text('13-Jun-25'),
                            ],
                          ),
                        ),
                        Expanded(
                          flex: 3,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Column(
                                children: [
                                  Text('Check In'),
                                  SizedBox(height: 4),
                                  Text('Jam'),
                                ],
                              ),
                              Column(
                                children: [
                                  Text('Check Out'),
                                  SizedBox(height: 4),
                                  Text('Jam'),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
