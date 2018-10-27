/*
	Assignment No = 5
	

Write a program to demonstrate subletting and find the subnet masks.

****************************************************************************/


import java.io.*;
import java.util.*;
import java.util.Formatter.*;

class SubnetCheck
{
	Scanner sc = new Scanner(System.in);
	int IPsubnet[] = new int[4];
	int broadcastID[] = new int[4];
	int networkID[] = new int[4];

	public String getIP()
	{
		String IPadd = "";
		System.out.println("Enter the IP address to be traced. ");
		IPadd = sc.nextLine();
		return IPadd;
	}
	
	public int getAddr()
	{
		int addr;
		System.out.println("Enter the number of addresses required.");
		addr = sc.nextInt();
		return addr;
	}
	
	public int calculateHostBits(int addr)
	{
		int hostBits;
		// Number of bits used for host = log(n)/log(2)
		hostBits = (int)Math.ceil(Math.log(addr)/Math.log(2));
		return hostBits;
	}
	
	public void subnetsRequired(int hostBits)
	{
		// Number of subnets required: 8 - hostBits + 1
		System.out.println("Number of subnets required: " + (int)Math.pow(2,(8-hostBits)) + "\n");
	}
	
	public void printIP(int IP[])
	{
		int i;
		for(i = 0; i<4 ; i++)
		{
			if(i!=3)
				System.out.print(IP[i] + ".");
			else
				System.out.println(IP[i] + "\n");
		}
	}

	public void subnetMask(int NIDbits, int hostBits)
	{
		String subnetMask = "";
		String subnetMaskTemp = "";
		// Carrying out a similar process of converting subnet mask to int form (to make it easier for ANDing process):
		// TURNING network ID BITS ON and TURNING host ID BITS OFF
		int i,j = 0;
		for(i = 1; i<=NIDbits ; i++)
		{
			subnetMask += '1';
			subnetMaskTemp += '1';
			
			if(i%8 == 0)
			{
				IPsubnet[j] = Integer.parseInt(subnetMaskTemp,2);
				subnetMaskTemp = "";
				j++;
			}
		}
		for(i = 1; i<=hostBits; i++)
		{
			subnetMask += '0';
			subnetMaskTemp += '0';
			if((NIDbits + i)%8 == 0)
			{
				IPsubnet[j] = Integer.parseInt(subnetMaskTemp,2);
				subnetMaskTemp = "";
				j++;
			}
		}
		
		System.out.println("Subnet mask is: " );
		printIP(IPsubnet);
	}
	
	public void networkIP(int destIP[])
	{
		int i;
		// ANDing to obtain the network ID:
		for(i = 0; i<4; i++)
		{
			networkID[i] = IPsubnet[i] & destIP[i];
		}
		
		System.out.println("Network ID is: ");
		printIP(networkID);		
	}
	
	public void broadcastIP(int hostBits, int classNo)
	{
		int i;
		for(i=0; i<4; i++)
		{
			if(i!=classNo)
				broadcastID[i] = networkID[i];
			else
				broadcastID[i] = networkID[i] + ((int)Math.pow(2,hostBits) -1);
		}
		System.out.println("Broadcast ID is: ");
		printIP(broadcastID);
	}
	
	public void classA(int destIP[])
	{
		int i, addr, hostBits, NIDbits;
		
		addr = getAddr();
		
		hostBits = calculateHostBits(addr);
		
		subnetsRequired(hostBits);
		
		NIDbits = 16 - hostBits;
		
		hostBits = 32 - NIDbits;
		
		System.out.println("Number of bits used for host: " + hostBits);
		System.out.println("NIDbits: " + NIDbits + "\n");
		
		subnetMask(NIDbits,hostBits);
		
		networkIP(destIP);
		
		hostBits = calculateHostBits(addr);
		
		broadcastIP(hostBits,1);
		
	}
	
	public void classB(int destIP[])
	{
		int i, addr, hostBits, NIDbits;
		
		addr = getAddr();

		hostBits = calculateHostBits(addr);

		subnetsRequired(hostBits);

		NIDbits = 24 - hostBits;

		hostBits = 32 - NIDbits;

		System.out.println("Number of bits used for host: " + hostBits);
		System.out.println("NIDbits: " + NIDbits + "\n");

		subnetMask(NIDbits,hostBits);

		networkIP(destIP);

		hostBits = calculateHostBits(addr);

		broadcastIP(hostBits,2);
	}
	
	public void classC(int destIP[])
	{
		int i,addr, hostBits, NIDbits;
		
		addr = getAddr();
		
		hostBits = calculateHostBits(addr);

		// Total number of bits used for NID (class C)= 32 - number of bits used for host
		NIDbits = 32 - hostBits;
		
		System.out.println("Number of bits used for host: " + hostBits);
		System.out.println("NIDbits: " + NIDbits + "\n");

		subnetsRequired(hostBits);
		subnetMask(NIDbits, hostBits);
	
		// Obtaining the network ID:
		networkIP(destIP);
	
		// Obtaining the broadcast ID:
		broadcastIP(hostBits,3);
	}

	public static void main(String args[])
	{
		SubnetCheck c1 = new SubnetCheck();
		String IPadd = "";
		String binaryIP = "";
		int destIP[] = new int[4];
		int i;
		
		IPadd = c1.getIP();
		
		// Splitting the IP entered by ".", storing it to Int
		// AND converting it to binary and storing it in a String
		i = 0;
		for(String w : IPadd.split("\\."))
		{
			int temp = Integer.parseInt(w);
			
			destIP[i] = temp;
			
			// Converting temp to binary and Appending 0's to the converted version of int
			binaryIP += String.format("%08d", Integer.parseInt(Integer.toBinaryString(temp)));
			
			i++;
		}
		System.out.println("\nIP in binary form: " + binaryIP + "\n");
		
		if(destIP[0] >= 0 && destIP[0] <= 127)
		{
			c1.classA(destIP);
		}
		else if(destIP[0] >= 128 && destIP[0] <= 191)
		{	
			c1.classB(destIP);
		}
		else
			c1.classC(destIP);
	}
}


/*
Output
javac SubnetCheck.java
java SubnetCheck

Enter the IP address to be traced. 
192.168.12.63

IP in binary form: 11000000101010000000110000111111

Enter the number of addresses required.
25
Number of bits used for host: 5
NIDbits: 27

Number of subnets required: 8

Subnet mask is: 
255.255.255.224

Network ID is: 
192.168.12.32

Broadcast ID is: 
192.168.12.63

*/
