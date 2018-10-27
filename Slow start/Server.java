/*
	Assignemt no = 9
	
Write a program to simulate the behavior of Slow Start and AIMD (Additive Increase and
Multiplicative Decrease) congestion control protocols.
************************************************************/


import java.io.*;

import java.net.*;

public class Server

{
	
	public static void main(String args[])throws IOException

	{
	
		int tpdu=2,buffsize;	
		try
		{
			ServerSocket s=new ServerSocket(9999);

			Socket c=s.accept();

			
DataInputStream in=new DataInputStream(c.getInputStream());

			DataOutputStream out=new DataOutputStream(c.getOutputStream());

			out.writeUTF("Enter Size: ");
			buffsize=in.read();
			while(tpdu<=buffsize)
			{
				System.out.println("Congestion window size is: "+tpdu);
				tpdu=tpdu*2;
			}
			System.out.println("Congestion window size is: "+tpdu);
			if(tpdu>=buffsize)
			{
		
			System.out.println("Time out occure ack not n                  
  ++++++++++++++++++++++
			System.out.println("The updated congestion window size is: "+cong);
			}
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
