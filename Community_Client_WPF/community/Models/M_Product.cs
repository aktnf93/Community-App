using System;
using System.Runtime.Serialization;
using community.Common;

namespace community.Models
{
    [DataContract]
    public class M_Product : Notify
    {
        private int id;
        private string name;
        private string content;
        private string description;
        private string image_path;
        private int total_count;
        private DateTime created_at;
        private DateTime updated_at;
        private DateTime? deleted_at;

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

        [DataMember(Name = "content")]
        public string Content
        {
            get => this.content;
            set => base.OnPropertyChanged(ref this.content, value);
        }

        [DataMember(Name = "description")]
        public string Description
        {
            get => this.description;
            set => base.OnPropertyChanged(ref this.description, value);
        }

        [DataMember(Name = "image_path")]
        public string Image_Path
        {
            get => this.image_path;
            set => base.OnPropertyChanged(ref this.image_path, value);
        }

        [DataMember(Name = "total_count")]
        public int Total_Count
        {
            get => this.total_count;
            set => base.OnPropertyChanged(ref this.total_count, value);
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
    }
}
