import RPi.GPIO as GPIO
import socket

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
SERVER_IP = # 서버 아이피
SERVER_PORT = # 포트 번호

# socket.AF_INET은 IPv4를 사용하고, socket.SOCK_STREAM은 TCP를 사용한다는 것을 의미
server_socket = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
server_socket.bind((SERVER_IP, SERVER_PORT))
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

# ------------ 서버 통신 ------------
def Input_From_Server():
    data = client_socket.recv(1024).decode()
    return data

def Control_Rpi(data):
    if data == :# 웹캠 좌회전
        servo_cap.ChangeDutyCycle(2)
    elif data == : # 웹캠 우회전
        servo_cap.ChangeDutyCycle(2)
    elif data == : # 웹캠 화면 송출
        # 카메라 모듈 사용
    elif data == : # 건식 급식기 회전 (1회)
        servo_meal.ChangeDutyCycle(2)
    elif data == : # 습식 급식기 회전 (1칸)
        servo_bottom.ChangeDutyCycle(2)
    elif data == : # 솔레노이드 밸브 작동 (시간단위)
        # 솔레노이드 밸브 사용
    elif data == : # 스피커 녹음 재생
        # 전송받은 스피커 소리 정보를 출력해주기.

try:
    while True:
        Control_Rpi(Input_From_Server())

except KeyboardInterrupt:
    Server_Close(server_socket, client_socket)
    Rpi_Stop()