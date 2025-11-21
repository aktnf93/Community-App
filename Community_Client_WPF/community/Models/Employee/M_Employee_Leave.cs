using System;
using System.Runtime.Serialization;
using community.Common;

namespace community.Models
{
    [DataContract]
    public class M_Employee_Leave : Notify
    {
        private int id;
        private int employee_id;
        private int approver_id;
        private string leave_type;
        private DateTime start_date;
        private DateTime end_date;
        private string description;
        private string leave_result;
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

        [DataMember(Name = "approver_id")]
        public int Approver_Id
        {
            get => this.approver_id;
            set => base.OnPropertyChanged(ref this.approver_id, value);
        }

        [DataMember(Name = "leave_type")]
        public string Leave_Type
        {
            get => this.leave_type;
            set => base.OnPropertyChanged(ref this.leave_type, value);
        }

        [DataMember(Name = "start_date")]
        public DateTime Start_Date
        {
            get => this.start_date;
            set => base.OnPropertyChanged(ref this.start_date, value);
        }

        [DataMember(Name = "end_date")]
        public DateTime End_Date
        {
            get => this.end_date;
            set => base.OnPropertyChanged(ref this.end_date, value);
        }

        [DataMember(Name = "description")]
        public string Description
        {
            get => this.description;
            set => base.OnPropertyChanged(ref this.description, value);
        }

        [DataMember(Name = "leave_result")]
        public string Leave_Result
        {
            get => this.leave_result;
            set => base.OnPropertyChanged(ref this.leave_result, value);
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
