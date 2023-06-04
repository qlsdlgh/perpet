import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:perpet/screens/setting/pet_add_screen.dart';

import '../../widgets/no_glow_scroll.dart';

class PetInfo extends StatefulWidget {
  const PetInfo({super.key});

  @override
  State<PetInfo> createState() => _PetInfoState();
}

class _PetInfoState extends State<PetInfo> {
  final User _currentUser = FirebaseAuth.instance.currentUser!;
  List<Map<String, dynamic>>? petData;

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    getPetData(_currentUser.uid);
  }

  Future getPetData(String uid) async {
    final collectionRef = FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .collection('pets');

    final querySnapshot = await collectionRef.get();

    petData = await querySnapshotToList(querySnapshot);
    setState(() {});
  }

  Future<List<Map<String, dynamic>>> querySnapshotToList(
      QuerySnapshot<Map<String, dynamic>> snapshot) async {
    final List<Map<String, dynamic>> dataList = [];

    for (var doc in snapshot.docs) {
      dataList.add(doc.data());
    }

    return dataList;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          centerTitle: true,
          backgroundColor: Colors.white,
          title: const Text("내 반려동물 관리"),
          titleTextStyle: const TextStyle(
              color: Colors.black, fontSize: 24, fontWeight: FontWeight.bold),
          toolbarHeight: 60,
          bottomOpacity: 20,
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(Icons.arrow_back_ios_new_rounded),
            iconSize: 34,
          ),
        ),
        body: petData == null
            ? const Center(
                child: CircularProgressIndicator(color: Color(0xffffBABA)),
              )
            : Column(
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const PetAddScreen(),
                        ),
                      ).then((value) {
                        getPetData(_currentUser.uid);
                        setState(() {});
                      });
                    },
                    child: const Padding(
                      padding: EdgeInsets.only(
                        bottom: 10,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            '새로운 반려동물 추가',
                            style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.black54),
                          ),
                          SizedBox(
                            width: 3,
                          ),
                          Icon(
                            Icons.add_circle_outline_sharp,
                            color: Colors.black54,
                            size: 17,
                          ),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    child: ScrollConfiguration(
                      behavior: NoGlowScrollBehavior(),
                      child: SingleChildScrollView(
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(20, 10, 20, 20),
                          child: Column(
                            children: [
                              ListView.separated(
                                shrinkWrap: true,
                                primary: false,
                                scrollDirection: Axis.vertical,
                                itemCount: petData!.length,
                                itemBuilder: (context, index) {
                                  final data = petData![index];
                                  return PetCardList(
                                    image: data['petImage'],
                                    name: data['petName'],
                                    age: data['petAge'],
                                    weight: data['petWeight'],
                                    sex: data['petSex'],
                                  );
                                },
                                separatorBuilder: (context, index) =>
                                    const SizedBox(
                                  height: 20,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ));
  }
}

class PetCardList extends StatelessWidget {
  final String image, name, age, weight, sex;

  const PetCardList({
    super.key,
    required this.image,
    required this.name,
    required this.age,
    required this.weight,
    required this.sex,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Column(
          children: [
            Container(
              decoration: BoxDecoration(
                border: Border.all(width: 1, color: Colors.black26),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: Row(
                  children: [
                    CircleAvatar(
                        backgroundColor: Colors.white,
                        radius: 60,
                        backgroundImage: NetworkImage(image)),
                    const SizedBox(
                      width: 20,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          name,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Text(
                          "$age살 | ${weight}kg",
                          style: const TextStyle(
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        Text(
                          sex,
                          style: const TextStyle(fontSize: 16),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            /*
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () {},
                  style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all(const Color(0xffffBABA)),
                    foregroundColor: MaterialStateProperty.all(Colors.white),
                    padding: MaterialStateProperty.all(
                      const EdgeInsets.symmetric(
                        vertical: 5,
                        horizontal: 20,
                      ),
                    ),
                    shape: MaterialStateProperty.all(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                    ),
                  ),
                  child: const Text(
                    '정보 수정',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                )
              ],
            )
            */
          ],
        ),
      ],
    );
  }
}
