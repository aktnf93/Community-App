using System;
using System.Collections.ObjectModel;
using System.Runtime.Serialization;
using community.Common;

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
    }
}
