using System;
using System.Runtime.Serialization;
using community.Common;

namespace community.Models
{
    [DataContract]
    public class M_Chat_Message : Notify
    {
        private int id;
        private int chat_room_id;
        private int employee_id;
        private string employee_name;
        private string message;
        private DateTime created_at;
        private DateTime? deleted_at;

        [DataMember(Name = "id")]
        public int Id
        {
            get => this.id;
            set => base.OnPropertyChanged(ref this.id, value);
        }

        [DataMember(Name = "chat_room_id")]
        public int Chat_Room_Id
        {
            get => this.chat_room_id;
            set => base.OnPropertyChanged(ref this.chat_room_id, value);
        }

        [DataMember(Name = "employee_id")]
        public int Employee_Id
        {
            get => this.employee_id;
            set => base.OnPropertyChanged(ref this.employee_id, value);
        }

        [DataMember(Name = "employee_name")]
        public string Employee_Name
        {
            get => this.employee_name;
            set => base.OnPropertyChanged(ref this.employee_name, value);
        }

        [DataMember(Name = "message")]
        public string Message
        {
            get => this.message;
            set => base.OnPropertyChanged(ref this.message, value);
        }

        [DataMember(Name = "created_at")]
        public DateTime Created_At
        {
            get => this.created_at;
            set => base.OnPropertyChanged(ref this.created_at, value);
        }

        [DataMember(Name = "deleted_at")]
        public DateTime? Deleted_At
        {
            get => this.deleted_at;
            set => base.OnPropertyChanged(ref this.deleted_at, value);
        }
    }
}
