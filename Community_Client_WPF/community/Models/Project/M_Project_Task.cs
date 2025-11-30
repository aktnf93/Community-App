using community.Common;
using System;
using System.Collections.ObjectModel;
using System.Runtime.Serialization;
using System.Windows.Media;

namespace community.Models
{
    [DataContract]
    public class M_Project_Task : Notify
    {
        public event ActionHandler<M_Project_Task> OnTaskDelete;

        private int id;
        private int project_id;
        private int task_no;
        private string name;
        private string description;
        private int progress;
        private DateTime? start_date;
        private DateTime? end_date;
        private string status;
        private DateTime created_at;
        private DateTime updated_at;

        public MonthBox[] Month { get; set; } = new MonthBox[12];

        public M_Employee TaskMember { get; set; }

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

        [DataMember(Name = "task_no")]
        public int Task_No
        {
            get => this.task_no;
            set => base.OnPropertyChanged(ref this.task_no, value);
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

        public void UpdateMonth()
        {
            var start_dt = this.Start_Date;
            var end_dt = this.End_Date;
            if (start_dt != null && end_dt != null)
            {
                var start = start_dt.Value.Month + (start_dt.Value.Year * 10);
                int current = (DateTime.Now.Year * 10);
                var end = end_dt.Value.Month + (end_dt.Value.Year * 10);

                for (int i = 0; i < 12; i++)
                {
                    var month = new MonthBox();

                    current += 1;
                    if (start <= current && current <= end)
                        month.Color = Brushes.LightGreen;
                    else
                        month.Color = Brushes.Transparent;

                    this.Month[i] = month;
                }
            }
        }

        private void OnDelete()
        {
            this.OnTaskDelete?.Invoke(this);
        }
    }
}
