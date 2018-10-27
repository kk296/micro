#/*
#	Assignment No = 11
#	
#Write a program using TCP sockets for wired network to implement
#a. Peer to Peer Chat
#b. Multiuser Chat
#Demonstrate the packets captured traces using Wireshark Packet Analyzer Tool for peer to
#peer mode.

#*/

import socket
import sys

sock = socket.socket(socket.AF_INET, socket.SOCK_STREAM)

sock.connect(('127.0.0.1',23000))

sock.send("hi from client")

while True:
	
	data = sock.recv(16)
	if "stop." in data:
		break
	else:			
		print "server: " + data

	data = raw_input("you: ")
	sock.send(data)
	if "stop." in data:
		break
sock.close()




