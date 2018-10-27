#/*
#	Assignment No = 11
#	
#Write a program using TCP sockets for wired network to implement
#a. Peer to Peer Chat
#b. Multiuser Chat
#Demonstrate the packets captured traces using Wireshark Packet Analyzer Tool for peer to
#peer mode.


import socket
import sys

sock = socket.socket(socket.AF_INET, socket.SOCK_STREAM)

sock.bind(('localhost',23000))

sock.listen(1)

clisock, (ip,port) = sock.accept()

while True:    	
	data = clisock.recv(16)

	if "stop." in data:
		break
	else:			
		print "client: " + data
	
	data = raw_input("you: ")
	clisock.send(data)
	if "stop." in data:
		break
sock.close()
            
