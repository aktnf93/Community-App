using System;
using System.Collections.Concurrent;
using System.Collections.ObjectModel;
using System.Runtime.Remoting.Messaging;
using System.Runtime.Serialization;
using community.Common;
using MySqlX.XDevAPI;

namespace community.Models
{
    [DataContract]
    public class M_Chat_Room : Notify
    {
        public event ActionHandler<M_Chat_Room> OnChatRoomJoin;

        private int id;
        private string name;
        private string description;
        private DateTime? message_at;
        private DateTime created_at;
        private DateTime updated_at;
        private DateTime? deleted_at;
        private string image_path = string.Empty;

        [DataMember(Name = "members")]
        public ObservableCollection<M_Chat_Member> Members { get; set; } = new ObservableCollection<M_Chat_Member>();

        [DataMember(Name = "messages")]
        public ObservableCollection<M_Chat_Message> Messages { get; set; } = new ObservableCollection<M_Chat_Message>();

        private Scoket_IO_Client<M_Chat_Message> live;

        public string SendMessage { get; set; } = string.Empty;

        [DataMember(Name = "id")]
        public int Id
        {
            get => this.id;
            set => base.OnPropertyChanged(ref this.id, value);
        }

        [DataMember(Name = "name")]
        public string Name
        {
            get => this.name;
            set => base.OnPropertyChanged(ref this.name, value);
        }

        [DataMember(Name = "description")]
        public string Description
        {
            get => this.description;
            set => base.OnPropertyChanged(ref this.description, value);
        }

        [DataMember(Name = "message_at")]
        public DateTime? Message_At
        {
            get => this.message_at;
            set => base.OnPropertyChanged(ref this.message_at, value);
        }

        [DataMember(Name = "created_at")]
        public DateTime Created_At
        {
            get => this.created_at;
            set => base.OnPropertyChanged(ref this.created_at, value);
        }

        [DataMember(Name = "updated_at")]
        public DateTime Updated_At
        {
            get => this.updated_at;
            set => base.OnPropertyChanged(ref this.updated_at, value);
        }

        [DataMember(Name = "deleted_at")]
        public DateTime? Deleted_At
        {
            get => this.deleted_at;
            set => base.OnPropertyChanged(ref this.deleted_at, value);
        }

        [DataMember(Name = "image_path")]
        public string Image_Path
        {
            get => this.image_path;
            set => base.OnPropertyChanged(ref this.image_path, value);
        }


        private void OnChatRoomEnter()
        {
            this.OnChatRoomJoin?.Invoke(this);
        }

        public M_Employee _user { get; set; }

        public void OnConnect(M_Chat_Room room, M_Employee user)
        {
            // this.Id = room.Id;
            // this.Name = room.Name;
            // this.Description = room.Description;
            // this.Message_At = room.Message_At;
            // this.Created_At = room.Created_At;
            // this.Updated_At = room.Updated_At;
            // _user = user;



            var join = new { roomId = room.Id, userId = user.Id };
            this.live.Connect(join);
        }

        // -------------------------------------------

        public M_Chat_Room()
        {
            this.live = new Scoket_IO_Client<M_Chat_Message>();
            this.live.OnConnectedMessage += Live_OnConnectedMessage;
            this.live.OnReceiveMessage += Live_OnReceiveMessage;
            this.live.OnWelcomeMessage += Live_OnWelcomeMessage;
            this.live.OnDisconnectedMessage += Live_OnDisconnectedMessage;
        }

        private void Live_OnConnectedMessage(M_Chat_Message obj)
        {
            // DB에서 채팅방 멤버, 채팅 메시지 불러오기.
            Console.WriteLine("Live_OnConnectedMessage");
        }

        private void Live_OnReceiveMessage(M_Chat_Message obj)
        {
            Console.WriteLine("Live_OnReceiveMessage");
            App.Current.Dispatcher.Invoke(() =>
            {
                this.Messages.Add(obj);
            });
        }

        private void Live_OnWelcomeMessage(M_Chat_Room obj)
        {
            App.Current.Dispatcher.Invoke(() =>
            {
                this.Members.Clear();
                this.Messages.Clear();

                foreach (var m in obj.Members)
                {
                    this.Members.Add(m);
                    Console.WriteLine($"Member Add ! {this.Id} {this.Name}");
                }

                foreach (var m in obj.Messages)
                {
                    this.Messages.Add(m);
                }


                Console.WriteLine("Live_OnWelcomeMessage");
            });
        }
        private void Live_OnDisconnectedMessage(M_Chat_Message obj)
        {
            Console.WriteLine("Live_OnDisconnectedMessage");
        }

        private void OnMessageSend()
        {
            var msg = new M_Chat_Message
            {
                Chat_Room_Id = this.Id,
                Employee_Id = this._user.Id,
                Message = this.SendMessage,
                Employee_Name = this._user.Name,
            };

            this.live.SendMessage(msg);
        }
    }
}
