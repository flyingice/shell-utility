#!/usr/bin/env python3

import argparse
import base64
import struct
import sys

def parse_command_line():
    parser = argparse.ArgumentParser(description='OpenSSH public key parser')
    parser.add_argument(
        '-i', '--input', dest='infile', metavar='INFILE', help='OpenSSH public key file',required=True)
    return parser

def print_result(res):
    print("Algorithm: {}".format(res[0].decode()))
    print("Exponent: {}".format(int.from_bytes(res[1], byteorder='big')))
    # The modulus is encoded in 2's complement. It is stored as a string with MSB first.
    print("Modulus: length={} bytes".format(len(res[2])), end='')
    cnt = 0
    for b in res[2]:
        if cnt % 16 == 0:
            print()
        print("{:02x}".format(b), end=' ')
        cnt = cnt + 1
    print()

if __name__ == '__main__':
    args = parse_command_line().parse_args()

    try:
        with open(args.infile, 'r') as infile:
            data = infile.read()
            # OpenSSH public key follows the format [algorithm] [key] [commet]
            # The components are separated by a single space. The key is base64-encoded.
            key = base64.b64decode(data.split()[1].encode())
            start = 0
            res = []
            while start < len(key):
                sz = struct.unpack('>I', key[start:start + 4])[0]
                start = start + 4
                res.append(key[start:start + sz])
                start = start + sz

            print_result(res)

    except OSError:
        print("Failed to open the file: {}".format(args.infile))
        sys.exit(1)
