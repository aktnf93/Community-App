using System;
using System.Runtime.Serialization;
using community.Common;

namespace community.Models
{
    [DataContract]
    public class M_Employee_Review : Notify
    {
        private int id;
        private int employee_id;
        private int reviewer_id;
        private DateTime review_date;
        private string review_type;
        private int score;
        private string description;
        private string revicw_result;
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

        [DataMember(Name = "reviewer_id")]
        public int Reviewer_Id
        {
            get => this.reviewer_id;
            set => base.OnPropertyChanged(ref this.reviewer_id, value);
        }

        [DataMember(Name = "review_date")]
        public DateTime Review_Date
        {
            get => this.review_date;
            set => base.OnPropertyChanged(ref this.review_date, value);
        }

        [DataMember(Name = "review_type")]
        public string Review_Type
        {
            get => this.review_type;
            set => base.OnPropertyChanged(ref this.review_type, value);
        }

        [DataMember(Name = "score")]
        public int Score
        {
            get => this.score;
            set => base.OnPropertyChanged(ref this.score, value);
        }

        [DataMember(Name = "description")]
        public string Description
        {
            get => this.description;
            set => base.OnPropertyChanged(ref this.description, value);
        }

        [DataMember(Name = "revicw_result")]
        public string Revicw_Result
        {
            get => this.revicw_result;
            set => base.OnPropertyChanged(ref this.revicw_result, value);
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
