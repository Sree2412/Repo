from kafka import KafkaClient, SimpleProducer

broker = "MTPVPSESLG02.consilio.com:9092"
channel = "logging"
topic = "logging"

client = KafkaClient(broker)
producer = SimpleProducer(client)

def send_sample(file):
    with open(file) as f:
        lines = f.readlines()
        for line in lines:
            producer.send_messages(topic, str.encode(line))

if __name__=="__main__":
    send_sample("sport-sample.txt")