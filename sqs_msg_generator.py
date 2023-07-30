import boto3
import multiprocessing
import time
import concurrent.futures
import json

QUEUE_NAME = ''
MAX_WORKER = max(1, multiprocessing.cpu_count() - 3)
TPS_PER_WORKER = 10

def producer(queue):
    msg = {
      "Subject": "",
      "Message": ""
    }

    queue.send_message(MessageBody=json.dumps(msg))

    print('1 message sent')

    time.sleep(1.0 / TPS_PER_WORKER)

if __name__ == "__main__":
    try:
        sqs = boto3.resource('sqs')
        queue = sqs.get_queue_by_name(QueueName=QUEUE_NAME)

        print(f'Start sending SQS messages with {TPS_PER_WORKER * MAX_WORKER} tps...')

        with concurrent.futures.ThreadPoolExecutor(max_workers=MAX_WORKER) as executor:
            while True:
                executor.submit(producer, queue)
    except Exception as e:
        print(e)
        exit(1)

