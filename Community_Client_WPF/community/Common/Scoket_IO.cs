using community.Models;
using Newtonsoft.Json;
using System;
using System.Threading.Tasks;
using Client = SocketIOClient.SocketIO;

namespace community.Common
{
    public class Scoket_IO
    {
        public static Scoket_IO Client { get; private set; } = new Scoket_IO();

        private Client client;
        public event ActionHandler OnConnected;
        public event ActionHandler<M_Chat_Room> OnWelcome;
        public event ActionHandler<M_Chat_Message> OnReceived;
        public event ActionHandler OnDisconnected;
        private object joinMessage;

        private Scoket_IO()
        {
            this.client = new Client(HTTP_Server.API.BaseUrl);

            this.client.OnConnected += async (sender, e) =>
            {
                this.OnConnected?.Invoke();

                await this.client.EmitAsync("joinRoom", joinMessage);
            };

            this.client.On("receiveMessage", (response) =>
            {
                var m = response.GetValue<M_Chat_Message>();
                this.OnReceived?.Invoke(m);
            });

            this.client.On("welcome", (response) =>
            {
                var m = response.GetValue<M_Chat_Room>();
                this.OnWelcome?.Invoke(m);
            });

            this.client.OnDisconnected += async (sender, e) =>
            {
                this.OnDisconnected?.Invoke();
            };
        }

        public async Task Connect(object message)
        {
            await this.Disconnect();

            this.joinMessage = message;

            await this.client.ConnectAsync();
        }

        public async Task Disconnect()
        {
            await this.client.DisconnectAsync();
        }

        public void SendMessage(object message)
        {
            this.client.EmitAsync("sendMessage", message);
        }
    }
}
