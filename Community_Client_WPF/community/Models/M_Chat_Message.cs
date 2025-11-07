using System;
using System.Runtime.Serialization;
using community.Common;

namespace community.Models
{
    [DataContract]
    public class M_Chat_Message : Notify
    {
        private int id;
        private int chat_member_id;
        private string message;
        private DateTime created_at;
        private DateTime? deleted_at;

        [DataMember(Name = "id")]
        public int Id
        {
            get => this.id;
            set => base.OnPropertyChanged(ref this.id, value);
        }

        [DataMember(Name = "chat_member_id")]
        public int Chat_Member_Id
        {
            get => this.chat_member_id;
            set => base.OnPropertyChanged(ref this.chat_member_id, value);
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
