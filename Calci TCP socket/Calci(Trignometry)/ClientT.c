/*
	Assignemt No = 6

Write a program using TCP socket for wired network for following
a. Say Hello to Each other ( For all students)
b. File transfer ( For all students)
c. Calculator (Arithmetic) (50% students)
d. Calculator (Trigonometry) (50% students)
Demonstrate the packets captured traces using Wireshark Packet Analyzer Tool for peer to
peer mode
********************************************************************************/
#include<sys/types.h>
#include<sys/socket.h>
#include<stdio.h>
#include<netinet/in.h> 
#include <unistd.h>
#include<string.h> 
#include<strings.h>
#include <arpa/inet.h>
#include<math.h>
//#define buffsize  150
void main()
{
int b,sockfd,sin_size,con,n,len;
//char buff[256];
double angle,result;
char op;

if((sockfd=socket(AF_INET,SOCK_STREAM,0))>0)
printf("socket created sucessfully\n");
//printf("%d\n", sockfd);
struct sockaddr_in servaddr;

servaddr.sin_family=AF_INET;
servaddr.sin_addr.s_addr=inet_addr("127.0.0.1");
servaddr.sin_port=6666;

sin_size = sizeof(servaddr);
if((con=connect(sockfd,(struct sockaddr *) &servaddr, sin_size))==0); //initiate a connection on a socket
printf("connect sucessful\n");
printf("Enter operation:\n 1:sin \n 2:cos\n 3:tan \n ");
scanf("%c",&op);
printf("Enter angle in degree:");
scanf("%lf",&angle);

write(sockfd,&op,1);

write(sockfd,&angle,sizeof(angle));

read(sockfd,&result,sizeof(result)); 
printf("\n Operation result from server=%lf\n",result);  
close(sockfd);
}

/*OUTPUT
 gcc ServerT.c -lm
 ./a.out
socket created sucessfully
bind sucessful
listen sucessful
accept sucessful
sin(90.000000)=1.000000 


 gcc Client.T.c 
 ./a.out
socket created sucessfully
connect sucessful
Enter operation:
 1:sin 
 2:cos
 3:tan 
 1
Enter angle in degree:90

 Operation result from server=1.000000
*/
