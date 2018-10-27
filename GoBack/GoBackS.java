/*
	Assignment No = 4
	
Write a program to simulate Go back N and Selective Repeat Modes of Sliding Window
Protocol in peer to peer mode and demonstrate the packets captured traces using Wireshark
Packet Analyzer Tool for peer to peer mode.

************************************************************************************/
import java.io.*;
import java.net.*;
import java.util.*;

public class GoBackS {
	static ServerSocket ss;
	static DataInputStream dis;
	static DataOutputStream dos;

	public static void main(String[] args) throws SocketException {

		
		Scanner scan=new Scanner(System.in);		
		int i;
		
		
		try {
			int a[] = { 30, 40, 50, 60, 70, 80, 90, 100 };
			/*
			int a[]=new int[8];
			int m;
			for(m=0;m<8;m++){
				System.out.println("Frame no "+(m+1)+" : ");
				a[m]=scan.nextInt();
			}
			*/
			
			
			ss = new ServerSocket(9999);	//creating port 9999
			System.out.println("waiting for connection");
			Socket s = ss.accept();		//establish connection with client
			dis = new DataInputStream(s.getInputStream());
			dos = new DataOutputStream(s.getOutputStream());
			System.out.println("The number of packets sent is:" + a.length);	//length of array
			int y = a.length;
			dos.write(y);
			dos.flush();	//clear buffer

			for (i = 0; i < a.length; i++) {
				dos.write(a[i]);
				dos.flush();
			}

			//NACK recieved
			int k = dis.read();		//k==4 eg		read l61


		
for(i=k;i<a.length;i++)
{
		dos.write(a[i]);		//l75
		dos.flush();
	

}



		//	dos.write(a[k]);	//resend the lost packet
		//	dos.flush();
			
			
		} catch (IOException e) {
			System.out.println(e);
		} finally {
			try {
				dis.close();
				dos.close();
			} catch (IOException e) {
				e.printStackTrace();
			}

		}
	}
}
/*OUTPUT
javac GoBackS.java
java GoBackS

waiting for connection
The number of packets sent is:8

*/
