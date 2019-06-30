#!/usr/bin/env python
# -*- coding: utf-8 -*-

import argparse
import random
import time

from pythonosc import udp_client


if __name__ == "__main__":
    parser = argparse.ArgumentParser()
    parser.add_argument("--ip", default="127.0.0.1", help="The ip of the OSC server")
    parser.add_argument("--port", type=int, default=57120, help="The port the OSC server is listening on")
    parser.add_argument("--pattern", default="/yo/lo", help="The OSC message pattern")
    args = parser.parse_args()

    client = udp_client.SimpleUDPClient(args.ip, args.port)

    for x in range(10):
        client.send_message(args.pattern, random.random())
        time.sleep(1)
