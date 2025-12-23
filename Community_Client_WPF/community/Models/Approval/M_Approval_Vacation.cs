using System;
using System.Collections.Generic;
using System.Runtime.Serialization;
using community.Common;

namespace community.Models
{
    [DataContract]
    public class M_Approval_Vacation : Notify
    {
        private int id;
        private int approval_id;
        private string type;
        private DateTime start_at = DateTime.Now;
        private DateTime end_at = DateTime.Now;
        private string description = "\n\t\n\t\n\t\n\t\n\t\n\t\n\t\n\t\n\t\n\t";
        private DateTime created_at;
        private DateTime updated_at;

        [DataMember(Name = "id")]
        public int Id
        {
            get => this.id;
            set => base.OnPropertyChanged(ref this.id, value)   ;
        }

        [DataMember(Name = "approval_id")]
        public int Approval_Id
        {
            get => this.approval_id;
            set => base.OnPropertyChanged(ref this.approval_id, value);
        }

        [DataMember(Name = "type")]
        public string Type
        {
            get => this.type;
            set => base.OnPropertyChanged(ref this.type, value);
        }

        [DataMember(Name = "start_at")]
        public DateTime Start_At
        {
            get => this.start_at;
            set => base.OnPropertyChanged(ref this.start_at, value);
        }

        [DataMember(Name = "end_at")]
        public DateTime End_At
        {
            get => this.end_at;
            set => base.OnPropertyChanged(ref this.end_at, value);
        }

        [DataMember(Name = "description")]
        public string Description
        {
            get => this.description;
            set => base.OnPropertyChanged(ref this.description, value);
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

        public Dictionary<string, string> Vacation_Types { get; set; } = new Dictionary<string, string>()
        {
            { "연차", "연차" },
            { "월차", "월차" },
            { "반차", "반차" },
            { "병가", "병가" },
            { "공가", "공가" },
            { "무급", "무급" },
            { "특별", "특별" },
        };
    }
}
