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
        // 채팅방 리스트
        public ObservableCollection<M_Chat_Room> ChatRoomList { get; set; } = new ObservableCollection<M_Chat_Room>();

        // 현재 채팅방
        public M_Chat_Room CurrentChatRoom { get; set; } = new M_Chat_Room();

        private Scoket_IO Socket => Scoket_IO.Client;

        public string TxtChatRoomMessage { get; set; } = "";

        public VM_Chat()
        {
            // 소켓 접속
            this.Socket.OnConnected += () =>
            {
                Console.WriteLine("소켓 접속");
            };

            // 채팅방 접속
            this.Socket.OnWelcome += (res) =>
            {
                Console.WriteLine("채팅방 접속");

                App.Current.Dispatcher.Invoke(async () =>
                {
                    this.CurrentChatRoom = res.DeepCopy();
                    base.OnPropertyChanged(nameof(this.CurrentChatRoom));
                });
            };

            // 메시지 수신
            this.Socket.OnReceived += (res) =>
            {
                Console.WriteLine("메시지 수신");

                App.Current.Dispatcher.Invoke(async () =>
                {
                    this.CurrentChatRoom.Messages.Add(res);
                });
            };

            // 소켓 해제
            this.Socket.OnDisconnected += () =>
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
                    room.OnChatRoomJoin += async (r) =>
                    {
                        await UiAction.Instance.ExecuteAsync(async () =>
                        {
                            var join = new { roomId = r.Id, userId = base.CurrentUser.Id };

                            await this.Socket.Connect(join);
                        });
                    };

                    this.ChatRoomList.Add(room);
                }
            }
        }

        // private void ChatRoomAdd()
        // {
        //     var room = this.ChatRoomSelected;
        //     if (string.IsNullOrEmpty(room.Name))
        //     {
        //         MessageBox.Show("생성할 채팅방 이름을 입력해주세요.");
        //     }
        // 
        //     var data = new { name = room.Name, description = room.Description };
        //     var result = HTTP_Server.API.HttpSend<M_DB_Result>("/chat/room/insert", HTTP_Server.Method.POST, data);
        //     if (result != null && result.InsertId > 0)
        //     {
        //         ChatRoomSearch();
        //     }
        // }
        // 
        // private void ChatRoomEdit()
        // {
        //     var room = this.ChatRoomSelected;
        //     if (room.Id == 0)
        //     {
        //         MessageBox.Show("수정할 채팅방을 선택해주세요.");
        //         return;
        //     }
        // 
        //     var data = new { id = room.Id, name = room.Name, description = room.Description };
        //     var result = HTTP_Server.API.HttpSend<M_DB_Result>("/chat/room/update", HTTP_Server.Method.PUT, data);
        //     if (result != null && result.AffectedRows > 0)
        //     {
        //         ChatRoomSearch();
        //     }
        // }
        // 
        // private void ChatRoomDelete()
        // {
        //     var room = this.ChatRoomSelected;
        //     if (room.Id == 0)
        //     {
        //         MessageBox.Show("삭제할 채팅방을 선택해주세요.");
        //         return;
        //     }
        // 
        //     var data = new { id = room .Id };
        //     var result = HTTP_Server.API.HttpSend<M_DB_Result>("/chat/room/delete", HTTP_Server.Method.DELETE, data);
        //     if (result != null && result.AffectedRows > 0)
        //     {
        //         ChatRoomSearch();
        //     }
        // }

        private void BtnChatRoomMessageSend()
        {
            var msg = new M_Chat_Message
            {
                Chat_Room_Id  = this.CurrentChatRoom.Id,
                Message       = this.TxtChatRoomMessage,
                Employee_Id   = base.CurrentUser.Id,
                Employee_Name = base.CurrentUser.Name,
            };

            this.Socket.SendMessage(msg);
        }
    }
}
