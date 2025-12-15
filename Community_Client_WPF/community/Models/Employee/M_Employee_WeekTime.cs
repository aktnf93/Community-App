using System;
using System.Runtime.Serialization;
using community.Common;

namespace community.Models
{
    [DataContract]
    public class M_Employee_WeekTime : Notify
    {
        private int employee_id;
        private TimeSpan total_minutes;
        private TimeSpan base_minutes;
        private TimeSpan overtime_minutes;
        private TimeSpan remaining_minutes;
        private DateTime week_start;
        private DateTime week_day;
        private DateTime week_end;

        [DataMember(Name = "employee_id")]
        public int Employee_Id
        {
            get => this.employee_id;
            set => base.OnPropertyChanged(ref this.employee_id, value);
        }

        /// <summary>
        /// 총 근무시간
        /// </summary>
        [DataMember(Name = "total_minutes")]
        public TimeSpan Total_Minutes
        {
            get => this.total_minutes;
            set => base.OnPropertyChanged(ref this.total_minutes, value);
        }

        /// <summary>
        /// 기본 근무 시간
        /// </summary>
        [DataMember(Name = "base_minutes")]
        public TimeSpan Base_Minutes
        {
            get => this.base_minutes;
            set => base.OnPropertyChanged(ref this.base_minutes, value);
        }

        /// <summary>
        /// 연장 근무 시간
        /// </summary>
        [DataMember(Name = "overtime_minutes")]
        public TimeSpan Overtime_Minutes
        {
            get => this.overtime_minutes;
            set => base.OnPropertyChanged(ref this.overtime_minutes, value);
        }

        /// <summary>
        /// 잔여 근무시간
        /// </summary>
        [DataMember(Name = "remaining_minutes")]
        public TimeSpan Remaining_Minutes
        {
            get => this.remaining_minutes;
            set => base.OnPropertyChanged(ref this.remaining_minutes, value);
        }

        [DataMember(Name = "week_start")]
        public DateTime Week_Start
        {
            get => this.week_start;
            set => base.OnPropertyChanged(ref this.week_start, value);
        }

        [DataMember(Name = "week_day")]
        public DateTime Week_Day
        {
            get => this.week_day;
            set => base.OnPropertyChanged(ref this.week_day, value);
        }

        [DataMember(Name = "week_end")]
        public DateTime Week_End
        {
            get => this.week_end;
            set => base.OnPropertyChanged(ref this.week_end, value);
        }
    }
}
