#!/usr/bin/env python

import argparse
import base64
import logging


def parse_command_line():
    parser = argparse.ArgumentParser(description='base64 decoder/encoder')
    group = parser.add_mutually_exclusive_group(required=True)
    group.add_argument(
        '-e', '--encode', dest='text', metavar='TEXT', help='encode the plain text into base64 representation')
    group.add_argument(
        '-d', '--decode', dest='cipher', metavar='CIPHER', help='decode the base64 representation into plain text')
    return parser


def encode(text):
    return base64.b64encode(text.encode())  # return a bytes object


def decode(cipher):
    return base64.b64decode(cipher.encode())  # return a bytes object


if __name__ == '__main__':
    logging.getLogger().setLevel(logging.INFO)
    args = parse_command_line().parse_args()

    try:
        if args.text:
            print('{}'.format(encode(args.text).decode()))
        else:
            print('{}'.format(decode(args.cipher).decode()))
    except TypeError as err:
        logging.error(err)
