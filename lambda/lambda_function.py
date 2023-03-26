import json
import os
from datetime import datetime
from influxdb import InfluxDBClient

def lambda_handler(event, context):
    # IoT Core����̃��b�Z�[�W���p�[�X����
    sensor_id = event['raspiId']
    temperature = event['temperature']
    humidity = event['humidity']
    pressure = event['pressure']
    timestamp = int(datetime.now().timestamp())

    # InfluxDB�ւ̐ڑ��������ϐ�����擾�BLambda�̊��ϐ����ɐݒ肷�邱��
    influxdb_host = os.environ['INFLUXDB_HOST']
    influxdb_port = int(os.environ['INFLUXDB_PORT'])
    influxdb_user = os.environ['INFLUXDB_USER']
    influxdb_password = os.environ['INFLUXDB_PASSWORD']
    influxdb_dbname = os.environ['INFLUXDB_DBNAME']

    # InfluxDB�N���C�A���g���쐬
    client = InfluxDBClient(host=influxdb_host, port=influxdb_port, username=influxdb_user, password=influxdb_password, database=influxdb_dbname)

    # InfluxDB�Ƀf�[�^����������
    data = [
        {
            "measurement": "sensor_data",
            "tags": {
                "sensor_id": sensor_id,
            },
            "time": timestamp,
            "fields": {
                "temperature": temperature,
                "humidity": humidity,
                "pressure": pressure
            }
        }
    ]
    client.write_points(data)

    return {
        'statusCode': 200,
        'body': json.dumps('Data saved to InfluxDB!')
    }