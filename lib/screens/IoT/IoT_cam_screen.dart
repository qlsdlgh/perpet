import 'dart:async';
import 'dart:io' as io;
import 'package:flutter/material.dart';
import 'package:perpet/widgets/no_glow_scroll.dart';
import 'package:flutter_audio_recorder3/flutter_audio_recorder3.dart';
import 'package:file/file.dart';
import 'package:file/local.dart';
import 'package:path_provider/path_provider.dart';

class IoTCamScreen extends StatefulWidget {
  final LocalFileSystem localFileSystem;

  const IoTCamScreen({super.key, localFileSystem})
      : localFileSystem = localFileSystem ?? const LocalFileSystem();
  @override
  State<IoTCamScreen> createState() => _IoTCamScreen();
}

class _IoTCamScreen extends State<IoTCamScreen> {
  FlutterAudioRecorder3? _recorder;
  Recording? _current;
  RecordingStatus _currentStatus = RecordingStatus.Unset;
  String SERVER_IP = ""; //서버 IP 주소
  int SERVER_PORT = 8080; //서버 포트 번호
  bool state_L = false;
  bool state_R = false;
  String mic_button_text = "마이크";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _init();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text(
          '웹캠 확인',
          style: TextStyle(
              color: Colors.black, fontSize: 24, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        toolbarHeight: 60,
        bottomOpacity: 20,
        actions: [
          IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(Icons.close_rounded),
            iconSize: 34,
          )
        ],
      ),
      body: ScrollConfiguration(
        behavior: NoGlowScrollBehavior(),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 40,
                ),
                child: Container(
                  width: double.infinity,
                  height: 250,
                  color: Colors.black,
                  child: const Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'cam screen',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 20, color: Colors.white),
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    InkWell(
                      onTap: () {
                        //왼쪽회전 눌렀을 때 실행될 코드
                        if (state_L == true) {
                          //정지 명령
                          //서버로 정보를 보내는 코드 IP와 PORT는 테스트 시 변환
                          io.Socket.connect(SERVER_IP, SERVER_PORT)
                              .then((socket) {
                            socket.write("WC_S");
                          });
                          state_L = false; // 상태 변경
                        } else {
                          //왼쪽회전 시작
                          //서버로 정보를 보내는 코드 IP와 PORT는 테스트 시 변환
                          io.Socket.connect(SERVER_IP, SERVER_PORT)
                              .then((socket) {
                            socket.write("WC_L");
                          });
                          state_L = true; // 상태 변경
                        }
                      },
                      borderRadius: const BorderRadius.all(Radius.circular(50)),
                      child: const CircleAvatar(
                        radius: 35,
                        backgroundColor: Colors.black26,
                        child: Icon(
                          Icons.rotate_left_rounded,
                          color: Colors.black87,
                          size: 35,
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 20,
                    ),
                    InkWell(
                      onTap: () {
                        switch (_currentStatus) {
                          case RecordingStatus.Initialized:
                            {
                              _start();
                              setState(() {
                                mic_button_text = "녹음 중지";
                              });
                              break;
                            }
                          case RecordingStatus.Recording:
                            {
                              _stop();
                              setState(() {
                                mic_button_text = "마이크";
                              });
                              break;
                            }

                          case RecordingStatus.Stopped:
                            {
                              _init();
                              setState(() {
                                mic_button_text = "녹음 시작";
                              });
                              break;
                            }
                          default:
                            break;
                        }
                      },
                      borderRadius: const BorderRadius.all(Radius.circular(50)),
                      child: const CircleAvatar(
                        radius: 60,
                        backgroundColor: Colors.black26,
                        child: Icon(
                          Icons.mic,
                          color: Colors.black87,
                          size: 60,
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 20,
                    ),
                    InkWell(
                      onTap: () {
                        //오른쪽회전 눌렀을 때 실행될 코드
                        if (state_R == true) {
                          //정지 명령
                          //서버로 정보를 보내는 코드 IP와 PORT는 테스트 시 변환
                          io.Socket.connect(SERVER_IP, SERVER_PORT)
                              .then((socket) {
                            socket.write("WC_S");
                          });
                          state_R = false; // 상태 변경
                        } else {
                          //오른쪽회전 시작
                          //서버로 정보를 보내는 코드 IP와 PORT는 테스트 시 변환
                          io.Socket.connect(SERVER_IP, SERVER_PORT)
                              .then((socket) {
                            socket.write("WC_R");
                          });
                          state_R = true; // 상태 변경
                        }
                      },
                      borderRadius: const BorderRadius.all(Radius.circular(50)),
                      child: const CircleAvatar(
                        radius: 35,
                        backgroundColor: Colors.black26,
                        child: Icon(
                          Icons.rotate_right_rounded,
                          color: Colors.black87,
                          size: 35,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Text(mic_button_text),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void deactivate() {
    super.deactivate();
    // TODO: implement deactivate
    //화면 나갈 때 무조건 웹캠 정지
    //서버로 정보를 보내는 코드 IP와 PORT는 테스트 시 변환
    io.Socket.connect(SERVER_IP, SERVER_PORT).then((socket) {
      socket.write("WC_S");
    });
  }

  _init() async {
    try {
      bool hasPermission = await FlutterAudioRecorder3.hasPermissions ?? false;

      if (hasPermission) {
        String customPath = '/flutter_audio_recorder_';
        io.Directory appDocDirectory;
//        io.Directory appDocDirectory = await getApplicationDocumentsDirectory();
        if (io.Platform.isIOS) {
          appDocDirectory = await getApplicationDocumentsDirectory();
        } else {
          appDocDirectory = (await getExternalStorageDirectory())!;
        }

        // can add extension like ".mp4" ".wav" ".m4a" ".aac"
        customPath = appDocDirectory.path +
            customPath +
            DateTime.now().millisecondsSinceEpoch.toString();

        // .wav <---> AudioFormat.WAV
        // .mp4 .m4a .aac <---> AudioFormat.AAC
        // AudioFormat is optional, if given value, will overwrite path extension when there is conflicts.
        _recorder =
            FlutterAudioRecorder3(customPath, audioFormat: AudioFormat.WAV);

        await _recorder!.initialized;
        // after initialization
        var current = await _recorder!.current(channel: 0);
        print(current);
        // should be "Initialized", if all working fine
        setState(() {
          _current = current;
          _currentStatus = current!.status!;
          print(_currentStatus);
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("You must accept permissions")));
      }
    } catch (e) {
      print(e);
    }
  }

  _start() async {
    try {
      await _recorder!.start();
      var recording = await _recorder!.current(channel: 0);
      setState(() {
        _current = recording;
      });

      const tick = Duration(milliseconds: 50);
      Timer.periodic(tick, (Timer t) async {
        if (_currentStatus == RecordingStatus.Stopped) {
          t.cancel();
        }

        var current = await _recorder!.current(channel: 0);
        // print(current.status);
        setState(() {
          _current = current;
          _currentStatus = _current!.status!;
        });
      });
    } catch (e) {
      print(e);
    }
  }

  _stop() async {
    var result = await _recorder!.stop();
    print("Stop recording: ${result!.path}");
    print("Stop recording: ${result.duration}");
    File file = widget.localFileSystem.file(result.path);
    print("File length: ${await file.length()}");
    //서버로 음성 파일을 보내는 코드 IP와 PORT는 테스트 시 변환
    io.Socket.connect(SERVER_IP, SERVER_PORT).then((socket) {
      socket.addStream(file.openRead());
    });
    setState(() {
      _current = result;
      _currentStatus = _current!.status!;
    });
  }
}
