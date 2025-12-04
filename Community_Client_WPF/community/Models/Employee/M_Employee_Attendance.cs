using System;
using System.Runtime.Serialization;
using community.Common;

namespace community.Models
{
    [DataContract]
    public class M_Employee_Attendance : Notify
    {
		private int? id;
		private int employee_id;
		private string name;
		private string employee_code;
        private DateTime? start_work_at;
        private DateTime? end_work_at;
		private DateTime? total_work_minutes;
		private string description;
		private DateTime? created_at;
		private DateTime? updated_at;

        public DateTime SelectedDate { get; set; }

        [DataMember(Name = "id")]
        public int? Id
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

        [DataMember(Name = "name")]
        public string Name
        {
            get => this.name;
            set => base.OnPropertyChanged(ref this.name, value);
        }

        [DataMember(Name = "department_name")]
        public string Department_Name { get; set; }

        [DataMember(Name = "rank_name")]
        public string Rank_Name { get; set; }


        [DataMember(Name = "employee_code")]
        public string Employee_Code
        {
            get => this.employee_code;
            set => base.OnPropertyChanged(ref this.employee_code, value);
        }

        [DataMember(Name = "start_work_at")]
        public DateTime? Start_Work_At
        {
            get => this.start_work_at;
            set => base.OnPropertyChanged(ref this.start_work_at, value);
        }

        [DataMember(Name = "end_work_at")]
        public DateTime? End_Work_At
        {
            get => this.end_work_at;
            set => base.OnPropertyChanged(ref this.end_work_at, value);
        }

        [DataMember(Name = "total_work_minutes")]
        public DateTime? Total_Work_Minutes
        {
            get => this.total_work_minutes;
            set => base.OnPropertyChanged(ref this.total_work_minutes, value);
        }

        [DataMember(Name = "description")]
        public string Description
        {
            get => this.description;
            set => base.OnPropertyChanged(ref this.description, value);
        }

        [DataMember(Name = "created_at")]
        public DateTime? Created_At
        {
            get => this.created_at;
            set => base.OnPropertyChanged(ref this.created_at, value);
        }

        [DataMember(Name = "updated_at")]
        public DateTime? Updated_At
        {
            get => this.updated_at;
            set => base.OnPropertyChanged(ref this.updated_at, value);
        }

        public string Status
        {
            get
            {
                string _status = "정상근무";

                if (Total_Work_Minutes == null)
                {
                    // 출근 혹은 퇴근 안함.
                    _status = "근태이상";
                }
                else if (this.Total_Work_Minutes.Value.Hour < 9)
                {
                    // 근무 시간이 모자름
                    _status = "근태이상";
                }

                return _status;
            }
        }
    }
}
