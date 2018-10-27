#/*
#	Assignment No = 10
#	
#Write a program for DNS lookup. Given an IP address input, it should return URL and vice-
#versa.
#********************************************************************/

import socket

print 'Welcome to DNS to IP Address'
URL=raw_input('Enter URL: ')

addr1 = socket.gethostbyname(URL)

print(addr1)
print 'WelCome IP address to DNS'
IP=raw_input('Enter IP Address: ')
addr6=socket.gethostbyaddr(IP)
print addr6

#Output
# python DNS.py
#Welcome to DNS to IP Address
#Enter URL: www.google.com
#172.217.27.196
#WelCome IP address to DNS
#Enter IP Address: 172.217.27.196
#('bom07s15-in-f4.1e100.net', [], ['172.217.27.196'])

