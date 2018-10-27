/*
	Assignemt no = 9
	
Write a program to simulate the behavior of Slow Start and AIMD (Additive Increase and
Multiplicative Decrease) congestion control protocols.
************************************************************/

import java.io.*;

import java.net.*;

public class Client

{

	public static void main(String args[])throws IOException

	{

		try
		{
			Socket s=new Socket("127.0.0.1",9999);

			DataInputStream in=new DataInputStream(s.getInputStream());

			DataOutputStream out=new DataOutputStream(s.getOutputStream());
			DataInputStream din=new DataInputStream(System.in);
			String msg=in.readUTF();
			System.out.println(msg);
			int buffsize=Integer.parseInt(din.readLine());
			out.write(buffsize);
			out.close();

			in.close();		
		}
		catch(Exception e)
		{
			System.out.println(e);
		}
	}
}
/*OUTPUT
javac Server.java
java Server

Congestion window size is: 2
Congestion window size is: 4
Congestion window size is: 8
Congestion window size is: 16
Time out occure ack not recieve at sender side
The updated congestion window size is: 8


 javac Client.java
 java Client
Enter Size: 
8
*/
