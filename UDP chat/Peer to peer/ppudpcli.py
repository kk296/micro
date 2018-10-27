#/*
#	Assignment No = 12
#	
#Write a program using UDP sockets for wired network to implement
#a. Peer to Peer Chat
#b. Multiuser Chat
#Demonstrate the packets captured traces using Wireshark Packet Analyzer Tool for peer to
#peer mode.*/

import socket
import sys

sock = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
sock.sendto("Hi from client", ('', 10000))
while True:    	
	msg, (ip, port) = sock.recvfrom(100)

	if "stop." in msg:
		break
	else:			
		print "server: " + msg
	
	msg = raw_input("you: ")
	sock.sendto(msg, (ip,port))
	if "stop." in msg:
		break
sock.close()
#OUTPUT
# python pptcpserv.py
#client: hi from client
#you: hi
#client: how r u
#you: 


#python pptcpcli.py
#server: hi
#you: how r u
#i am fine


