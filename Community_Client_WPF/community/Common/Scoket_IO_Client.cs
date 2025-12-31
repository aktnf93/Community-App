using community.Models;
using Newtonsoft.Json;
using System;
using Client = SocketIOClient.SocketIO;

namespace community.Common
{
    public class Scoket_IO_Client<T>
    {
        private Client client;
        public event ActionHandler<T> OnConnectedMessage;
        public event ActionHandler<M_Chat_Message> OnReceiveMessage;
        public event ActionHandler<M_Chat_Room> OnWelcomeMessage;
        public event ActionHandler<T> OnDisconnectedMessage;
        private object joinMessage;

        public Scoket_IO_Client()
        {
            this.client = new Client(HTTP_Server.API.BaseUrl);

            this.client.OnConnected += async (sender, e) =>
            {
                this.OnConnectedMessage?.Invoke(default(T));

                await this.client.EmitAsync("joinRoom", joinMessage);
            };

            this.client.On("receiveMessage", (response) =>
            {
                var m = response.GetValue<M_Chat_Message>();
                this.OnReceiveMessage?.Invoke(m);
            });

            this.client.On("welcome", (response) =>
            {
                var m = response.GetValue<M_Chat_Room>();
                this.OnWelcomeMessage?.Invoke(m);
            });

            this.client.OnDisconnected += async (sender, e) =>
            {
                this.OnDisconnectedMessage?.Invoke(default(T));
            };
        }

        public bool Connect(object message)
        {
            if (this.client != null)
            {
                this.Disconnect();
            }

            this.joinMessage = message;
            return this.client.ConnectAsync().Wait(5000);
        }

        public void Disconnect()
        {
            this.client.DisconnectAsync().Wait(5000);
        }

        public void SendMessage(object message)
        {
            this.client.EmitAsync("sendMessage", message);
        }
    }
}
