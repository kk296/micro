/*
	Assignment No = 12

Write a program using UDP sockets for wired network to implement
a. Peer to Peer Chat
b. Multiuser Chat
Demonstrate the packets captured traces using Wireshark Packet Analyzer Tool for peer to
peer mode.*/

import java.io.*;
import java.net.*;
public class multclient 
{
	public static void main(String argv[]) throws Exception {
	String sentence;
	String modifiedSentence;
 	BufferedReader inFromUser =new BufferedReader(new InputStreamReader(System.in));
 	Socket clientSocket = new Socket("10.65.6.159", 6789);
 	while (true) 
	{
 		DataOutputStream outToServer =new DataOutputStream(clientSocket.getOutputStream());
 		BufferedReader inFromServer =new BufferedReader(new InputStreamReader(clientSocket.getInputStream()));
 		sentence = inFromUser.readLine();
 		outToServer.writeBytes(sentence + '\n');
 		if (sentence.equals("EXIT")) {
		break;
 		}
		modifiedSentence = inFromServer.readLine();
 		System.out.println("FROM SERVER: " + modifiedSentence);
 	}
	clientSocket.close();
 	}
 }
 /*
OUTPUT
 javac multserver.java
 java multserver
client : hi
hello
client : hi
hello prachi
client : hey
wassup
client : hey teju

**********Client1*****************
 javac multclient.java
 java multclient
hi
FROM SERVER: hello

***********Client2**************
 javac multclient.java
 java multclient
hi
FROM SERVER: hello prachi
hey teju
*/
