import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:perpet/screens/setting/pet_add_screen.dart';
import 'package:perpet/screens/setting/pet_edit_screen.dart';

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
                                    petId: data['petId'],
                                    petType: data['petType'],
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

class PetCardList extends StatefulWidget {
  final String image, name, age, weight, sex, petId, petType;

  const PetCardList({
    super.key,
    required this.image,
    required this.name,
    required this.age,
    required this.weight,
    required this.sex,
    required this.petId,
    required this.petType,
  });

  @override
  State<PetCardList> createState() => _PetCardListState();
}

class _PetCardListState extends State<PetCardList> {
  final User _currentUser = FirebaseAuth.instance.currentUser!;

  void deletePet(String petId) async {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          content: const Text(
            '정말 삭제하시겠습니까?',
          ),
          actions: [
            TextButton(
              onPressed: () async {
                CollectionReference collectionRef = FirebaseFirestore.instance
                    .collection('users')
                    .doc(_currentUser.uid)
                    .collection('pets');

                QuerySnapshot querySnapshot =
                    await collectionRef.where('petId', isEqualTo: petId).get();

                for (var doc in querySnapshot.docs) {
                  doc.reference.delete();
                }

                showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      content: const Text('반려동물 정보가 삭제되었습니다.'),
                      actions: [
                        TextButton(
                          child: const Text(
                            'close',
                            style: TextStyle(color: Colors.black45),
                          ),
                          onPressed: () {
                            Navigator.pop(context);
                            Navigator.pop(context);
                            Navigator.pop(context);
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const PetInfo()));
                          },
                        )
                      ],
                    );
                  },
                );
              },
              child: const Text(
                '예',
                style: TextStyle(
                  color: Colors.black45,
                ),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text(
                '아니오',
                style: TextStyle(
                  color: Colors.black45,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

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
                        backgroundImage: NetworkImage(widget.image)),
                    const SizedBox(
                      width: 20,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.name,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Text(
                          "${widget.age}살 | ${widget.weight}kg",
                          style: const TextStyle(
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        Text(
                          widget.sex,
                          style: const TextStyle(fontSize: 16),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => PetEditScreen(
                                  petId: widget.petId,
                                  petType: widget.petType,
                                  petName: widget.name,
                                  petAge: widget.age,
                                  petWeight: widget.weight,
                                  petSex: widget.sex,
                                )));
                  },
                  style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all(const Color(0xffffBABA)),
                    foregroundColor: MaterialStateProperty.all(Colors.white),
                    padding: MaterialStateProperty.all(
                      const EdgeInsets.symmetric(
                        horizontal: 5,
                      ),
                    ),
                    shape: MaterialStateProperty.all(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                    ),
                  ),
                  child: const Text(
                    '수정',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(
                  width: 5,
                ),
                TextButton(
                  onPressed: () {
                    deletePet(widget.petId);
                  },
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(Colors.black38),
                    foregroundColor: MaterialStateProperty.all(Colors.white),
                    padding: MaterialStateProperty.all(
                      const EdgeInsets.symmetric(
                        horizontal: 5,
                      ),
                    ),
                    shape: MaterialStateProperty.all(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                    ),
                  ),
                  child: const Text(
                    '삭제',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ],
    );
  }
}
