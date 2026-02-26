using System;
using System.Net; 
using System.Net.Sockets;
using System.Text;
using System.Threading.Tasks;
using UnityEngine;
public class Esp32Socket : MonoBehaviour

{
  // Member variables for TCP connection
  private TcpClient client;
  private NetworkStream stream;
  private string Ip;
  private int Port;

  // Connect to ESP32 server
  public void Connect(string ip, int port)
  {
    Ip = ip; 
    Port = port;
    
    // Create TCP client object and connect
    client = new TcpClient();
    client.Connect(ip, port);
    
    // Get network stream to send/receive data
    stream = client.GetStream();
  }

  // Send array of angles to ESP32  
  public void WriteAngles(double[] anglesArray)
  {
    try 
    {
      // Convert array to byte array
      byte[] data = new byte[anglesArray.Length * sizeof(double)];
      Buffer.BlockCopy(anglesArray, 0, data, 0, data.Length);

      // Send data
      stream.Write(data, 0, data.Length);
    }
    catch (Exception e)
    {
      Debug.Log(e.ToString());
      
      // Reconnect if error
      this.Close();
      this.Connect(Ip, Port);
    }
  }

  // Close TCP connection
  public void Close()
  {
    stream.Dispose();
    client.Dispose();
  }
}
