# v 0.3
# 각도 제어 수정 완료

import RPi.GPIO as GPIO
import socket
import cv2
import numpy as np
import pyaudio
from time import sleep

# ------------------- 초기 변수 설정 -------------------
GPIO.setmode(GPIO.BCM)

# 서보 모터 제어부
servo_cap_pin = 20  # 캠
servo_meal_pin = 21  # 건식
servo_bottom_pin = 22  # 습식

GPIO.setup(servo_cap_pin, GPIO.OUT)
GPIO.setup(servo_meal_pin, GPIO.OUT)
GPIO.setup(servo_bottom_pin, GPIO.OUT)

servo_max_duty = 12  # 180도
servo_min_duty = 3  # 0도

servo_cap = GPIO.PWM(servo_cap_pin, 50)
servo_cap.start(0)
servo_meal = GPIO.PWM(servo_meal_pin, 50)
servo_meal.start(0)
servo_bottom = GPIO.PWM(servo_bottom_pin, 50)
servo_bottom.start(0)

# ------------ 서버 설정 ------------
SERVER_IP = '0.0.0.0'# 서버 아이피
SERVER_PORT = '443' # 포트 번호

# socket.AF_INET은 IPv4를 사용하고, socket.SOCK_STREAM은 TCP를 사용한다는 것을 의미
server_socket = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
# 서버 연결
server_socket.bind((SERVER_IP, int(SERVER_PORT)))
# 소켓 수신 대기
server_socket.listen()

# 클라이언트 소켓과 연결된 새로운 소켓 객체와 클라이언트의 IP주소와 포트를 반환
client_socket, addr = server_socket.accept()


# send() : 클라이언트에게 데이터를 보냄
# recv() : 클라이언트로부터 데이터를 받음
# client_socket.send('hello, client'.encode())
# data = client_socket.recv(1024).decode()

# ------------------- 함수 정의 -------------------
# ------------ 라즈베리파이 제어 ------------
def Rpi_Stop():
    servo_cap.stop(0)
    servo_meal.stop(0)
    servo_bottom.stop(0)
    GPIO.cleanup()

def Server_Close(server_socket, client_socket):
    client_socket.close()
    server_socket.close()

def Capture_And_Send_Frame():
    cap = cv2.VideoCapture(0)
    cap.set(cv2.CAP_PROP_FRAME_WIDTH, 320)
    cap.set(cv2.CAP_PROP_FRAME_HEIGHT, 240)
    
    while True:
        ret, frame = cap.read()
        frame = cv2.resize(frame, (320, 240))
        data = pickle.dumps(frame)
        message = struct.pack(">L", len(data)) + data
        client_socket.sendall(message)
        
def Play_Audio(sound):
    p = pyaudio.PyAudio()
    stream = p.open(format = pyaudio.paInt16,
                    channels = 1,
                    rate = 44100,
                    output = True)
    
    stream.write(sound)
    stream.stop_stream()
    stream.close()
    p.terminate()
    
# ------------ 서버 통신 ------------
def Recv_Control():
    data = client_socket.recv(1024).decode()
    return data

def Control_Rpi(data):
    if data == "WC_L":# 웹캠 좌회전
        servo_cap.ChangeDutyCycle(7.5)
    elif data == "WC_R": # 웹캠 우회전
        servo_cap.ChangeDutyCycle(4)
    elif data == "WC_S": # 웹캠 정지
        servo_cap.ChangeDutyCycle(0)
    elif data == "WC": # 웹캠 화면 송출, 카메라 모듈 사용
        Capture_And_Send_Frame()
    elif data == "DRY_MEAL": # 건식 급식기 회전 (1회)
        servo_meal.ChangeDutyCycle(2)
        sleep(2)
        servo_meal.ChangeDutyCycle(0)
    elif data == "WET_MEAL": # 습식 급식기 회전 (1칸)
        servo_bottom.ChangeDutyCycle(2)
        sleep(0.5)
        servo_bottom.ChangeDutyCycle(0)
    elif data == "SOUND": # 스피커 녹음 재생, 전송받은 스피커 소리 정보를 출력해주기.
        sound = client_socket.recv(1024)
        Play_Audio(sound)
#    elif data == "WATER": # 솔레노이드 밸브 작동 (시간단위)
        # 솔레노이드 밸브 사용
        

    client_socket.sendall(data)

try:
    while True:
        print("실행중")
        Control_Rpi(Recv_Control())

except KeyboardInterrupt:
    Server_Close(server_socket, client_socket)
    
finally:
    Rpi_Stop()
