
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

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
        body: SingleChildScrollView(
            child: Padding(
          padding: const EdgeInsets.fromLTRB(40, 30, 40, 40),
          child: petData == null
              ? const Center(
                  child: CircularProgressIndicator(),
                )
              : Column(
                  children: [
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          '새로운 반려동물 추가',
                          style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.black54),
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        Icon(
                          Icons.add_circle_outline_sharp,
                          color: Colors.black54,
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 40,
                    ),
                    ListView.separated(
                      shrinkWrap: true,
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
                      separatorBuilder: (context, index) => const SizedBox(
                        height: 20,
                      ),
                    ),
                  ],
                ),
        ))

        /*
      petData == null
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: petData!.length,
              itemBuilder: (context, index) {
                final data = petData![index];

                return ListTile(
                  title: Text(data['petName']),
                  subtitle: Text(data['petType']),
                );
              }),
              */
        );
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
                border: Border.all(width: 2, color: const Color(0xffffBABA)),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Row(
                  children: [
                    CircleAvatar(
                        backgroundColor: Colors.white,
                        radius: 100,
                        backgroundImage: NetworkImage(image)),
                    const SizedBox(
                      width: 30,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          name,
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        Text(
                          "$age살 | ${weight}kg",
                          style: const TextStyle(
                            fontSize: 16,
                          ),
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
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () {},
                  style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all(const Color(0xffFF8F9A)),
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
          ],
        ),
      ],
    );
  }
}
