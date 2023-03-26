from AWSIoTPythonSDK.MQTTLib import AWSIoTMQTTClient
import logging
import time
import json
import smbus2
from bme280 import BME280

# BME280初期化
bus = smbus2.SMBus(1)
bme280 = BME280(i2c_dev=bus)

# ログ設定
logger = logging.getLogger("AWSIoTPythonSDK.core")
logger.setLevel(logging.DEBUG)
streamHandler = logging.StreamHandler()
formatter = logging.Formatter('%(asctime)s - %(name)s - %(levelname)s - %(message)s')
streamHandler.setFormatter(formatter)
logger.addHandler(streamHandler)

# hostエンドポイント、証明書の設定
host = "#hostID#.ap-northeast-1.amazonaws.com"
root_ca_path = "#path/RootCA1.pem#"
certificate_path = "#path/.crt#"
private_key_path = "#path/.key#"
my_rpi = AWSIoTMQTTClient("my_rpi")
my_rpi.configureEndpoint(host, 8883)
my_rpi.configureCredentials(root_ca_path, private_key_path, certificate_path    )
my_rpi.configureAutoReconnectBackoffTime(1, 32, 20)
my_rpi.configureOfflinePublishQueueing(-1)  # Infinite offline Publish queue    ing
my_rpi.configureDrainingFrequency(2)  # Draining: 2 Hz
my_rpi.configureConnectDisconnectTimeout(10)  # 10 sec
my_rpi.configureMQTTOperationTimeout(5)  # 5 sec

my_rpi.connect()
time.sleep(2)
# Replace this function with your code to read the temperature sensor
def get_sensor_data():
    temperature = round(bme280.get_temperature(), 1)
    humidity = round(bme280.get_humidity(), 1)
    pressure = round(bme280.get_pressure(), 1)

    return {"temperature": temperature, "humidity": humidity, "pressure": pressure}


# Iot coreの送信先
topic = "pub/myhome"

while True:
    temperature_data = get_sensor_data()
    message = json.dumps(temperature_data)

    my_rpi.publish(topic, message, 1)
    print("Published message: {}\n".format(message))

    time.sleep(60)  # 時間間隔を記載

my_rpi.disconnect()