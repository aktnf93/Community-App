using System;
using System.Runtime.Serialization;
using community.Common;

namespace community.Models
{
    [DataContract]
    public class M_System_Log : Notify
    {
        private int id;
        private string category;
        private string message;
        private DateTime created_at;

        [DataMember(Name = "id")]
        public int Id
        {
            get => this.id;
            set => base.OnPropertyChanged(ref this.id, value);
        }

        [DataMember(Name = "category")]
        public string Category
        {
            get => this.category;
            set => base.OnPropertyChanged(ref this.category, value);
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
    }
}
