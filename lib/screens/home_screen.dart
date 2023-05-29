import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:perpet/screens/main_screen.dart';
import 'package:perpet/screens/setting_page.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final bool _loading = true;
  final User _currentUser = FirebaseAuth.instance.currentUser!;
  Map<String, dynamic>? _userData;
  List<Map<String, dynamic>>? petData;

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    fetchUserData();
    getPetData(_currentUser.uid);
  }

  Future<void> fetchUserData() async {
    final document = await FirebaseFirestore.instance
        .collection('users')
        .doc(_currentUser.uid)
        .get();
    if (document.exists) {
      setState(() {
        _userData = document.data() as Map<String, dynamic>;
      });
    }
  }

  Future<void> getPetData(String uid) async {
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
    String mainPetName = 'mainPetName';

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        title: const Text("Perpet"),
        titleTextStyle: const TextStyle(
            color: Colors.black, fontSize: 24, fontWeight: FontWeight.bold),
        toolbarHeight: 60,
        bottomOpacity: 20,
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => SettingPage(
                    currentUser: _userData,
                  ),
                ),
              );
            },
            icon: const Icon(Icons.menu),
            iconSize: 28,
          )
        ],
      ),
      body: petData == null
          ? const Center(
              child: CircularProgressIndicator(color: Color(0xffffBABA)),
            )
          : SingleChildScrollView(
              child: Padding(
                  padding: const EdgeInsets.all(25),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: 25,
                        ),
                        child: Column(
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Row(
                                  children: [
                                    Text(
                                      '주변에 있는 동물병원, 약국을 찾으시나요?',
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 22,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                    top: 10,
                                  ),
                                  child: TextButton.icon(
                                    icon: const Icon(
                                      Icons.arrow_forward_ios_rounded,
                                      size: 14,
                                    ),
                                    label: const Text(
                                      '지도 바로가기',
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    onPressed: () {
                                      Navigator.pushAndRemoveUntil(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  const MainScreen(
                                                    current: 1,
                                                  )),
                                          (route) => false);
                                    },
                                    style: ButtonStyle(
                                      backgroundColor:
                                          MaterialStateProperty.all(
                                              Colors.blue.shade200),
                                      foregroundColor:
                                          MaterialStateProperty.all(
                                              Colors.white),
                                      padding: MaterialStateProperty.all(
                                        const EdgeInsets.symmetric(
                                          vertical: 5,
                                          horizontal: 10,
                                        ),
                                      ),
                                      shape: MaterialStateProperty.all(
                                        RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(20.0),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 30,
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Row(
                                  children: [
                                    Text(
                                      '동네 이웃들과 일상을 공유해요',
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 22,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    )
                                  ],
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                    top: 10,
                                  ),
                                  child: TextButton.icon(
                                    icon: const Icon(
                                      Icons.arrow_forward_ios_rounded,
                                      size: 14,
                                    ),
                                    label: const Text(
                                      '커뮤니티 바로가기',
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    onPressed: () {
                                      Navigator.pushAndRemoveUntil(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  const MainScreen(
                                                    current: 2,
                                                  )),
                                          (route) => false);
                                    },
                                    style: ButtonStyle(
                                      backgroundColor:
                                          MaterialStateProperty.all(
                                              const Color(0xffC0E69E)),
                                      foregroundColor:
                                          MaterialStateProperty.all(
                                              Colors.white),
                                      padding: MaterialStateProperty.all(
                                        const EdgeInsets.symmetric(
                                          vertical: 5,
                                          horizontal: 10,
                                        ),
                                      ),
                                      shape: MaterialStateProperty.all(
                                        RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(20.0),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 60,
                      ),
                      Column(
                        children: [
                          const Row(
                            children: [
                              Text(
                                '나의 반려동물',
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                  fontSize: 28,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 60,
                          ),
                          SizedBox(
                            height: 400,
                            child: ListView.separated(
                              scrollDirection: Axis.horizontal,
                              itemCount: petData!.length,
                              padding: const EdgeInsets.symmetric(
                                vertical: 10,
                              ),
                              itemBuilder: (context, index) {
                                final data = petData![index];
                                return MyPets(
                                  imageUrl: data['petImage'],
                                  petName: data['petName'],
                                  petAge: data['petAge'],
                                  petWeight: data['petWeight'],
                                  petSex: data['petSex'],
                                );
                              },
                              separatorBuilder: (context, index) =>
                                  const SizedBox(
                                width: 40,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  )),
            ),
    );
  }
}

class MyPets extends StatelessWidget {
  final String imageUrl, petName, petAge, petWeight, petSex;

  const MyPets({
    super.key,
    required this.imageUrl,
    required this.petName,
    required this.petAge,
    required this.petWeight,
    required this.petSex,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        CircleAvatar(
          backgroundColor: Colors.white,
          radius: 150,
          backgroundImage: NetworkImage(imageUrl),
        ),
        Positioned(
          bottom: 20,
          child: GestureDetector(
            onTap: () {}, // 반려동물 정보 카드 누르면 동물 정보로 이동
            child: Container(
              width: 300,
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    spreadRadius: 1,
                    blurRadius: 3,
                  )
                ],
                borderRadius: BorderRadius.circular(40),
              ),
              padding: const EdgeInsets.symmetric(
                vertical: 15,
              ),
              child: Column(
                children: [
                  Text(
                    petName,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '$petAge살 | ${petWeight}kg | $petSex',
                        style: const TextStyle(
                          fontSize: 16,
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
