# 0.6
# 진짜 최종 예약까지 추가함

import RPi.GPIO as GPIO
import socket
import cv2
import numpy as np
from time import sleep
import struct
import threading

# ------------------- 초기 변수 설정 -------------------
GPIO.setmode(GPIO.BCM)

# GPIO 제어부
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
SERVER_PORT = '5000' # 포트 번호

# socket.AF_INET은 IPv4를 사용하고, socket.SOCK_STREAM은 TCP를 사용한다는 것을 의미
server_socket = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
server_socket.setsockopt(socket.SOL_SOCKET, socket.SO_REUSEADDR, 1)
# 서버 연결
server_socket.bind((SERVER_IP, int(SERVER_PORT)))
# 소켓 수신 대기
server_socket.listen()

# ------------------- 함수 정의 -------------------
# ------------ 라즈베리파이 제어 ------------
def Rpi_Stop():
    servo_cap.stop(0)
    servo_meal.stop(0)
    servo_bottom.stop(0)
    GPIO.cleanup()

def Server_Close(client_socket):
    client_socket.close()

def Capture_And_Send_Frame():
    cap = cv2.VideoCapture(0)
    cap.set(cv2.CAP_PROP_FRAME_WIDTH, 320)
    cap.set(cv2.CAP_PROP_FRAME_HEIGHT, 240)
    
    while True:
        ret, frame = cap.read()
        if not ret:
            print("Failed to capture frame")
            sleep(0.1)
            continue
        frame = cv2.resize(frame, (320, 240))
        result, frame = cv2.imencode('.jpg', frame)
        data = bytearray(frame)
        message = struct.pack(">L", len(data)) + data
        client_socket.sendall(message)
        print(len(message))   

# ------------ 서버 통신 ------------
def Recv_Control():
    data = client_socket.recv(1024)
    return data

def Control_Rpi(data):
    print(data)
    if data == b"WC_L":# 웹캠 좌회전
        servo_cap.ChangeDutyCycle(7.5)
    elif data == b"WC_R": # 웹캠 우회전
        servo_cap.ChangeDutyCycle(4)
    elif data == b"WC_S": # 웹캠 정지
        servo_cap.ChangeDutyCycle(0)
    elif data == b"WC": # 웹캠 화면 송출, 카메라 모듈 사용
        Capture_And_Send_Frame()
    elif data == b"DRY_MEAL": # 건식 급식기 회전 (1회)
        data = client_socket.recv(1024)
        data = int(data.decode())
        for p in range(data):
            servo_meal.ChangeDutyCycle(2)
            sleep(2)
            servo_meal.ChangeDutyCycle(0)
            sleep(0.5)
    elif data == b"WET_MEAL": # 습식 급식기 회전 (1칸)
        data = client_socket.recv(1024)
        data = int(data.decode())
        for p in range(data):
            servo_bottom.ChangeDutyCycle(2)
            sleep(0.5)
            servo_bottom.ChangeDutyCycle(0)
            sleep(0.5)
    
    elif data == b"DELAYED_DRY_MEAL":
        delay_time = client_socket.recv(1024)
        delay_time = int(delay_time.decode())
        count = client_socket.recv(1024)
        count = int(count.decode())
        
        def perform_delayed_dry_meal():
            sleep(delay_time)
            for feeding in range(count):
                servo_meal.ChangeDutyCycle(2)
                sleep(2)
                servo_meal.ChangeDutyCycle(0)
                sleep(0.5)
        threading.Thread(target=perform_delayed_wet_meal).start()

    elif data == b"DELAYED_WET_MEAL":
        delay_time = client_socket.recv(1024)
        delay_time = int(delay_time.decode())
        count = client_socket.recv(1024)
        count = int(count.decode())

        def perform_delayed_wet_meal():
            sleep(delay_time)
            for feeding in range(count):
                servo_bottom.ChangeDutyCycle(2)
                sleep(0.5)
                servo_bottom.ChangeDutyCycle(0)
                sleep(0.5)
        threading.Thread(target=perform_delayed_wet_meal).start()

    client_socket.sendall(data)

try:
    while True:
        # 클라이언트 소켓과 연결된 새로운 소켓 객체와 클라이언트의 IP주소와 포트를 반환
        client_socket, addr = server_socket.accept()
        print("클라이언트 연결: ", addr)
        while True:
            try:
                Control_Rpi(Recv_Control())
            except Exception as e:
                print("클라이언트 연결 종료: ", e)
                break
        print("새로운 클라이언트 연결을 기다리는 중...")

except KeyboardInterrupt:
    print("서버 종료")

finally:
    Server_Close()
    Rpi_Stop()
