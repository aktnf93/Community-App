using System;
using System.Runtime.Serialization;
using community.Common;

namespace community.Models
{
    [DataContract]
    public class M_Approval : Notify
    {
        private int id;
        private string type;
        private string title;
        private int employee_id;
        private string status;
        private DateTime created_at;
        private DateTime updated_at;

        [DataMember(Name = "id")]
        public int Id
        {
            get => this.id;
            set => base.OnPropertyChanged(ref this.id, value);
        }

        [DataMember(Name = "type")]
        public string Type
        {
            get => this.type;
            set => base.OnPropertyChanged(ref this.type, value);
        }

        [DataMember(Name = "title")]
        public string Title
        {
            get => this.title;
            set => base.OnPropertyChanged(ref this.title, value);
        }

        [DataMember(Name = "employee_id")]
        public int Employee_id
        {
            get => this.employee_id;
            set => base.OnPropertyChanged(ref this.employee_id, value);
        }

        [DataMember(Name = "status")]
        public string Status
        {
            get => this.status;
            set => base.OnPropertyChanged(ref this.status, value);
        }

        [DataMember(Name = "created_at")]
        public DateTime Created_at
        {
            get => this.created_at;
            set => base.OnPropertyChanged(ref this.created_at, value);
        }

        [DataMember(Name = "updated_at")]
        public DateTime Updated_at
        {
            get => this.updated_at;
            set => base.OnPropertyChanged(ref this.updated_at, value);
        }
    }
}
