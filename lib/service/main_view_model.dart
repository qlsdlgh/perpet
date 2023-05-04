import 'package:flutter/material.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';
import 'package:perpet/service/kakao_login.dart';
import 'package:perpet/service/social_login.dart';

class MainViewModel {
  final SocialLogin _socialLogin;
  bool isLogined = false;
  User? user;

  MainViewModel(this._socialLogin);

  Future login() async {
    isLogined = await _socialLogin.login();
    if (isLogined) {
      user = await UserApi.instance.me();
    }
  }

  Future logout() async {
    await _socialLogin.logout();
    isLogined = false;
    user = null;
  }
}

class LoginKakao extends StatefulWidget {
  const LoginKakao({super.key});

  @override
  State<LoginKakao> createState() => _LoginKakaoState();
}

class _LoginKakaoState extends State<LoginKakao> {
  final viewModel = MainViewModel(KakaoLogin());

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          Image.network(viewModel
                  .user?.kakaoAccount?.profile?.profileImageUrl ??
              'https://img.danawa.com/prod_img/500000/445/387/img/16387445_1.jpg?shrink=330:*&_v=20220325175050'),
          Text('${viewModel.isLogined}'),
          ElevatedButton(
            onPressed: () async {
              await viewModel.login();
              setState(() {});
            },
            child: const Text('Login'),
          ),
          ElevatedButton(
            onPressed: () async {
              await viewModel.logout();
              setState(() {});
            },
            child: const Text('Logout'),
          ),
        ],
      ),
    );
  }
}
