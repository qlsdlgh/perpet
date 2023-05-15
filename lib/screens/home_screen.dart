import 'package:flutter/material.dart';
import 'package:perpet/widgets/button_style.dart';
import 'package:perpet/screens/setting_page.dart';

//로그인 후 보이는 첫화면
class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 1), () {
      setState(() {
        _loading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    List<Map<String, dynamic>> imageTest = [
      {
        "imageUrl":
            'https://img1.daumcdn.net/thumb/R1280x0/?scode=mtistory2&fname=https%3A%2F%2Fblog.kakaocdn.net%2Fdn%2FboRFFg%2FbtsdKjNjuEW%2FMzSLgoPetfTFH0ffYUqCt1%2Fimg.jpg',
        "name": "dog1",
        "age": "1",
        "weight": "10"
      },
      {
        "imageUrl":
            'https://hips.hearstapps.com/hmg-prod/images/domestic-cat-lies-in-a-basket-with-a-knitted-royalty-free-image-1592337336.jpg?crop=0.88889xw:1xh;center,top&resize=1200:*',
        "name": "cat2",
        "age": "2",
        "weight": "4"
      },
      {
        "imageUrl":
            'https://www.peta.org.uk/wp-content/uploads/2022/02/cute-cat-keep-cats-indoors-peta.jpg',
        "name": "cat3",
        "age": "3",
        "weight": "6"
      },
    ];

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
                  builder: (context) => const SettingPage(),
                ),
              );
            },
            icon: const Icon(Icons.menu),
            iconSize: 28,
          )
        ],
      ),
      body: _loading
          ? const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(
                    color: Color.fromARGB(255, 252, 152, 152),
                  ),
                ],
              ),
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
                                Row(
                                  children: [
                                    RichText(
                                      text: TextSpan(
                                        text: '오늘은 ',
                                        style: const TextStyle(
                                          color: Colors.black,
                                          fontSize: 22,
                                          fontWeight: FontWeight.bold,
                                        ),
                                        children: <TextSpan>[
                                          TextSpan(
                                            text: mainPetName,
                                            style: const TextStyle(
                                              color: Color(0xffffBABA),
                                              fontSize: 22,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          const TextSpan(
                                            text: '에게 무슨 일이 있었나요?',
                                            style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 22,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                const Padding(
                                  padding: EdgeInsets.fromLTRB(10, 10, 0, 0),
                                  child: QuickButton(
                                    text: '다이어리 쓰러가기',
                                    bgColor: Color(0xffffBABA),
                                    textColor: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 40,
                            ),
                            const Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
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
                                  padding: EdgeInsets.fromLTRB(10, 10, 0, 0),
                                  child: QuickButton(
                                    text: '커뮤니티 바로가기',
                                    bgColor: Color(0xffC0E69E),
                                    textColor: Colors.white,
                                  ),
                                )
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 40,
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
                            height: 50,
                          ),
                          SizedBox(
                            height: 400,
                            child: ListView.separated(
                              scrollDirection: Axis.horizontal,
                              itemCount: imageTest.length,
                              padding: const EdgeInsets.symmetric(
                                vertical: 10,
                              ),
                              itemBuilder: (context, index) {
                                return MyPets(
                                  imageUrl: imageTest[index]['imageUrl'],
                                  petName: imageTest[index]['name'],
                                  petAge: imageTest[index]['age'],
                                  petWeight: imageTest[index]['weight'],
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
  final String imageUrl, petName, petAge, petWeight;

  const MyPets({
    super.key,
    required this.imageUrl,
    required this.petName,
    required this.petAge,
    required this.petWeight,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        CircleAvatar(
          radius: 150,
          backgroundImage: NetworkImage(imageUrl), // db에서 불러오는 url로 변경
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
                        '$petAge살',
                        style: const TextStyle(
                          fontSize: 16,
                        ),
                      ),
                      const Text(
                        ' | ',
                        style: TextStyle(
                          fontSize: 16,
                        ),
                      ),
                      Text(
                        '${petWeight}kg',
                        style: const TextStyle(
                          fontSize: 16,
                        ),
                      )
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
