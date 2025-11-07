using System;
using System.Runtime.Serialization;
using community.Common;

namespace community.Models
{
    [DataContract]
    public class M_Project_Task : Notify
    {
        private int id;
        private int project_id;
        private string name;
        private string description;
        private int progress;
        private DateTime? start_date;
        private DateTime? end_date;
        private string status;
        private DateTime created_at;
        private DateTime updated_at;

        [DataMember(Name = "id")]
        public int Id
        {
            get => this.id;
            set => base.OnPropertyChanged(ref this.id, value);
        }

        [DataMember(Name = "project_id")]
        public int Project_Id
        {
            get => this.project_id;
            set => base.OnPropertyChanged(ref this.project_id, value);
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

        [DataMember(Name = "progress")]
        public int Progress
        {
            get => this.progress;
            set => base.OnPropertyChanged(ref this.progress, value);
        }

        [DataMember(Name = "start_date")]
        public DateTime? Start_Date
        {
            get => this.start_date;
            set => base.OnPropertyChanged(ref this.start_date, value);
        }

        [DataMember(Name = "end_date")]
        public DateTime? End_Date
        {
            get => this.end_date;
            set => base.OnPropertyChanged(ref this.end_date, value);
        }

        [DataMember(Name = "status")]
        public string Status
        {
            get => this.status;
            set => base.OnPropertyChanged(ref this.status, value);
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
    }
}
