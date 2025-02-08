using System;
using System.Text;
using System.Threading;
using System.Threading.Tasks;
using System.Net.WebSockets;
using UnityEngine;

public class CubeSatClient : MonoBehaviour
{
    private ClientWebSocket ws;
    private string receivedData = "Esperando datos...";

    async void Start()
    {
        ws = new ClientWebSocket();
        Uri serverUri = new Uri("ws://localhost:3002"); // Conectar a WebSocket en Node.js

        try
        {
            await ws.ConnectAsync(serverUri, CancellationToken.None);
            Debug.Log("✅ Conectado al servidor WebSocket");

            StartListening();
        }
        catch (Exception e)
        {
            Debug.LogError("❌ Error al conectar: " + e.Message);
        }
    }

    async void StartListening()
    {
        byte[] buffer = new byte[1024];

        while (ws.State == WebSocketState.Open)
        {
            WebSocketReceiveResult result = await ws.ReceiveAsync(new ArraySegment<byte>(buffer), CancellationToken.None);
            string message = Encoding.UTF8.GetString(buffer, 0, result.Count);

            Debug.Log("📥 Datos recibidos en Unity: " + message);
            receivedData = message;
        }
    }

    void OnGUI()
    {
        GUI.Label(new Rect(10, 10, 600, 20), "Datos de CubeSat: " + receivedData);
    }

    void OnDestroy()
    {
        ws.CloseAsync(WebSocketCloseStatus.NormalClosure, "Cerrando", CancellationToken.None);
    }
}


