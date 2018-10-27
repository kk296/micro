/*
	Assignemt No = 7

Write a program using UDP Sockets to enable file transfer (Script, Text, Audio and Video
one file each) between two machines. Demonstrate the packets captured traces using
Wireshark Packet Analyzer Tool for peer to peer mode.
********************************************************************************/

#include<stdio.h>
#include<stdlib.h>

#include<sys/socket.h>
#include<sys/types.h>
#include<netinet/in.h>
#include<string.h>
#include<unistd.h>
#include<arpa/inet.h>
#include<error.h>

#define ERROR -1
#define BUFFER 1024
#define MAX_CLIENTS 2

int main(int argc, char **argv)
{
	int sock, cli; // sock: server socket descriptor, cli: client socket descriptor
	struct sockaddr_in server, client;

	char send_data[BUFFER]= "Hello from server mayur"; // send buffer: hold information to send to client
	char recv_data[BUFFER]; // receive buffer: hold information to received from client

	int sockaddr_len = sizeof(struct sockaddr_in); // socket address length
	int data_len; // store data length of send_data or recv_data length   

	if((sock = socket(AF_INET, SOCK_DGRAM, 0)) == -1)
	{	
		perror("socket error. ");
		exit(-1);
	}
	
	server.sin_family = AF_INET;
	server.sin_port = htons(atoi(argv[1]));
	server.sin_addr.s_addr = INADDR_ANY;
	bzero(&server.sin_zero , 8);

	if((bind(sock, (struct sockaddr *)&server, sockaddr_len)) == -1)
	{
		perror("bind error");	
		exit(-1);
	}

	
	//printf("New client connected to port: %d and IP %s \n", ntohs(client.sin_port), inet_ntoa(client.sin_addr)); //  inet_ntoa: network byte order, to a string in IPv4 dotted-decimal notation.
//while(1){
	data_len = recvfrom(sock,recv_data,BUFFER,0, (struct sockaddr *) &client, &sockaddr_len);
	
	recv_data[data_len] = '\0';

	printf("%s\n",recv_data);

	sendto(sock,recv_data,strlen(recv_data),0, 	(struct sockaddr *) &client, sockaddr_len); 	

	//printf("client disconnected \n");
//}
	return 0;
}


