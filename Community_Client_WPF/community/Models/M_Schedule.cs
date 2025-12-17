using System;
using System.Runtime.Serialization;
using community.Common;

namespace community.Models
{
    [DataContract]
    public class M_Schedule : Notify
    {
        private int id;
        private int employee_id;
        private string title;
        private string description;
        private DateTime start_at;
        private DateTime end_at;
        private int color_code;
        private DateTime created_at;
        private DateTime updated_at;

        [DataMember(Name = "id")]
        public int Id
        {
            get => this.id;
            set => base.OnPropertyChanged(ref this.id, value);
        }

        [DataMember(Name = "employee_id")]
        public int Employee_Id
        {
            get => this.employee_id;
            set => base.OnPropertyChanged(ref this.employee_id, value);
        }

        [DataMember(Name = "title")]
        public string Title
        {
            get => this.title;
            set => base.OnPropertyChanged(ref this.title, value);
        }

        [DataMember(Name = "description")]
        public string Description
        {
            get => this.description;
            set => base.OnPropertyChanged(ref this.description, value);
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

        [DataMember(Name = "color_code")]
        public int Color_Code
        {
            get => this.color_code;
            set => base.OnPropertyChanged(ref this.color_code, value);
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
