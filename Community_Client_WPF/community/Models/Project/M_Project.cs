using System;
using System.Collections.ObjectModel;
using System.Linq.Expressions;
using System.Runtime.Serialization;
using System.Windows;
using System.Windows.Media;
using community.Common;

namespace community.Models
{
    public class MonthBox : Notify
    {
        private SolidColorBrush color;
        public SolidColorBrush Color
        {
            get => this.color;
            set => base.OnPropertyChanged(ref this.color, value);
        }
    }

    [DataContract]
    public class M_Project : Notify
    {
        public event ActionHandler<M_Project> OnProjectEdit;
        public event ActionHandler<M_Project> OnProjectDelete;
        public event ActionHandler<M_Project> OnProjectTaskShow;

        private int id;
        private int? customer_id;
        private string name;
        private string description;
        private int progress;
        private DateTime? start_date;
        private DateTime? end_date;
        private string status = "대기"; // '대기','진행','완료','취소','보류'
        private DateTime created_at;
        private DateTime updated_at;
        private DateTime? deleted_at;

        public MonthBox[] Month { get; set; } = new MonthBox[12];
        public ObservableCollection<M_Project_Task> TaskList { get; set; } = new ObservableCollection<M_Project_Task>();
        private Visibility taskView = Visibility.Collapsed;
        public Visibility TaskView
        {
            get => this.taskView;
            set => base.OnPropertyChanged(ref this.taskView, value);
        }

        public M_Project()
        {

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
                    {
                        string colorCode = "";

                        switch (this.Status)
                        {
                            case "대기":
                                colorCode = "#808080";
                                break;

                            case "진행":
                                colorCode = "#89C148";
                                break;

                            case "완료":
                                colorCode = "#3498DB";
                                break;

                            case "보류":
                                colorCode = "#F7B000";
                                break;

                            case "취소":
                                colorCode = "#E74C3C";
                                break;

                            default:
                                break;
                        }

                        month.Color = (SolidColorBrush)(new BrushConverter().ConvertFrom(colorCode));
                    }
                    else
                    {
                        month.Color = Brushes.Transparent;
                    }

                    this.Month[i] = month;
                }
            }
        }

        [DataMember(Name = "id")]
        public int Id
        {
            get => this.id;
            set => base.OnPropertyChanged(ref this.id, value);
        }

        [DataMember(Name = "customer_id")]
        public int? Customer_Id
        {
            get => this.customer_id;
            set => base.OnPropertyChanged(ref this.customer_id, value);
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

        [DataMember(Name = "deleted_at")]
        public DateTime? Deleted_At
        {
            get => this.deleted_at;
            set => base.OnPropertyChanged(ref this.deleted_at, value);
        }

        private void BtnOnProjectEdit()
        {
            this.OnProjectEdit?.Invoke(this);
        }

        private void BtnOnProjectDelete()
        {
            this.OnProjectDelete?.Invoke(this);
        }

        private void BtnOnProjectTaskShow()
        {
            this.OnProjectTaskShow?.Invoke(this);
        }
    }
}
