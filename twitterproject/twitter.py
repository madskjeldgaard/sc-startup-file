#!/usr/bin/env python
# -*- coding: utf-8 -*-

import tweepy
import argparse

from pythonosc import udp_client

# Setup api
consumer_key = "7gkO8uxwjpPkQ3FrszfrgiedH"
consumer_secret = "L6YkZAVBqWGYsUxnFpUfyZAlWGMWFXEaN2eRNMv0x1s4obFm7E"
access_token = "480500000-XhTFPlBVbw7nPo4DMDfTdiBbiKknPjWgPp8wvYms"
access_token_secret = "x614ulV2ho7uUi76Buf4J0RxqlXxJDTWSeeiQLg8wOTeX"

auth = tweepy.OAuthHandler(consumer_key, consumer_secret)
auth.set_access_token(access_token, access_token_secret)

api = tweepy.API(auth)


# Override tweepy.StreamListener to add logic to on_status
class MyStreamListener(tweepy.StreamListener):

    def on_status(self, status):
        return status.text


if __name__ == "__main__":
    # Set up command line arguments
    parser = argparse.ArgumentParser()
    parser.add_argument("--track", default="#maga", help="Keywords to track")
    parser.add_argument("--ip", default="127.0.0.1", help="The ip of the OSC server")
    parser.add_argument("--port", type=int, default=57120, help="The port the OSC server is listening on")
    parser.add_argument("--pattern", default="/yo/lo", help="The OSC message pattern")
    args = parser.parse_args()

    # Setup OSC Client
    client = udp_client.SimpleUDPClient(args.ip, args.port)

    # Call the stream class and setup listener
    myStreamListener = MyStreamListener()
    myStream = tweepy.Stream(auth=api.auth, listener=MyStreamListener())
    # Start the stream
    
    # Send it as osc
    client.send_message(args.pattern, myStream.filter(track=[args.track]))

# todo: 
# find a way to send each tweet as seperate osc message
