using System;
using System.Data;
using System.Windows;
using System.Collections.ObjectModel;
using community.Common;
using community.Models;

namespace community.ViewModels
{
    public class VM_Chat : ViewModelBase
    {
        public ObservableCollection<M_Chat_Room> ChatRoomList { get; set; } = new ObservableCollection<M_Chat_Room>();

        private M_Chat_Room _ChatRoomSelected = new M_Chat_Room();
        public M_Chat_Room ChatRoomSelected
        {
            get => this._ChatRoomSelected;
            set
            {
                this._ChatRoomSelected = new M_Chat_Room();

                if (value != null)
                {
                    this._ChatRoomSelected.Id = value.Id;
                    this._ChatRoomSelected.Name = value.Name;
                    this._ChatRoomSelected.Description = value.Description;
                }

                base.OnPropertyChanged(nameof(ChatRoomSelected));
            }
        }

        private Scoket_IO_Client<DataTable> ChatRoom { get; set; }

        public VM_Chat()
        {
            this.ChatRoom = new Scoket_IO_Client<DataTable>();

            this.ChatRoom.OnConnectedMessage += (res) =>
            {
                Console.WriteLine("소켓 접속 성공");
            };

            this.ChatRoom.OnWelcomeMessage += (res) =>
            {
                Console.WriteLine("소켓 접속 성공");
            };

            this.ChatRoom.OnReceiveMessage += (res) =>
            {
                var members = this.ChatRoomSelected.Members;
                var messages = this.ChatRoomSelected.Messages;
            };

            this.ChatRoom.OnDisconnectedMessage += (req) =>
            {
                Console.WriteLine("소켓 해제");
            };
        }

        private void Loaded()
        {
            Console.WriteLine("VM_Chat Loaded");
            ChatRoomSearch();
        }

        private void ChatRoomSearch()
        {
            var rooms = HTTP_Server.API.HttpSend<M_Chat_Room[]>("/chat/room/select");

            this.ChatRoomList.Clear();
            if (rooms != null && rooms.Length > 0)
            {
                foreach (var room in rooms)
                {
                    room.OnChatRoomJoin += (r) =>
                    {
                        this.ChatRoomConnect();
                    };

                    this.ChatRoomList.Add(room);
                }
            }
        }

        private void ChatRoomAdd()
        {
            var room = this.ChatRoomSelected;
            if (string.IsNullOrEmpty(room.Name))
            {
                MessageBox.Show("생성할 채팅방 이름을 입력해주세요.");
            }

            var data = new { name = room.Name, description = room.Description };
            var result = HTTP_Server.API.HttpSend<M_DB_Result>("/chat/room/insert", HTTP_Server.Method.POST, data);
            if (result != null && result.InsertId > 0)
            {
                ChatRoomSearch();
            }
        }

        private void ChatRoomEdit()
        {
            var room = this.ChatRoomSelected;
            if (room.Id == 0)
            {
                MessageBox.Show("수정할 채팅방을 선택해주세요.");
                return;
            }

            var data = new { id = room.Id, name = room.Name, description = room.Description };
            var result = HTTP_Server.API.HttpSend<M_DB_Result>("/chat/room/update", HTTP_Server.Method.PUT, data);
            if (result != null && result.AffectedRows > 0)
            {
                ChatRoomSearch();
            }
        }

        private void ChatRoomDelete()
        {
            var room = this.ChatRoomSelected;
            if (room.Id == 0)
            {
                MessageBox.Show("삭제할 채팅방을 선택해주세요.");
                return;
            }

            var data = new { id = room .Id };
            var result = HTTP_Server.API.HttpSend<M_DB_Result>("/chat/room/delete", HTTP_Server.Method.DELETE, data);
            if (result != null && result.AffectedRows > 0)
            {
                ChatRoomSearch();
            }
        }

        private void ChatRoomConnect()
        {
            this.ChatRoom.Disconnect();

            var join = new { roomId = ChatRoomSelected.Id, userId = CurrentUser.Id };
            this.ChatRoom.Connect(join);
        }

        private void ChatRoomSend()
        {
            var msg = new M_Chat_Message
            {
                Chat_Room_Id = ChatRoomSelected.Id,
                Employee_Id = CurrentUser.Id,
                Message = "",
                Employee_Name = CurrentUser.Name,
            };

            this.ChatRoom.SendMessage(msg);
        }
    }
}
