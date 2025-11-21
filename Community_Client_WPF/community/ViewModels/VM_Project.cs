using community.Common;
using community.Models;
using System;
using System.Collections.Generic;
using System.Collections.ObjectModel;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows;
using System.Windows.Media;

namespace community.ViewModels
{
    public class VM_Project : ViewModelBase
    {
        public M_Card BannerCard { get; set; } = new M_Card()
        {
            Title = "프로젝트"
        };

        public M_Card[] DashboardCard { get; set; } =
        {
            new M_Card() { Title = "총 프로젝트", Content = "", Description = "" },
            new M_Card() { Title = "대기 중", Content = "", Description = "" },
            new M_Card() { Title = "진행 중", Content = "", Description = "" },
            new M_Card() { Title = "완료", Content = "", Description = "" },
            new M_Card() { Title = "보류", Content = "", Description = "" },
        };

        public ObservableCollection<M_Project> ProjectList { get; set; }
            = new ObservableCollection<M_Project>();

        private void Loaded()
        {
            Console.WriteLine("VM_Project Loaded");

            var result = Server.API.HttpSend<M_Project[]>("/project/list/select");

            if (result != null)
            {
                this.ProjectList.Clear();
                foreach (var item in result)
                {
                    if (item.Start_Date != null && item.End_Date != null)
                    {
                        var start = item.Start_Date.Value.Month + (item.Start_Date.Value.Year * 10);
                        int current = (DateTime.Now.Year * 10);
                        var end = item.End_Date.Value.Month + (item.End_Date.Value.Year * 10);

                        for (int i = 0; i < 12; i++)
                        {
                            current += 1;
                            Console.WriteLine("project: {0}, {1} <= {2} && {2} <= {3}", item.Name, start, current, end);
                            if (start <= current && current <= end)
                            {
                                item.Month[i].Color = Brushes.LightGreen;
                            }
                            else
                            {
                                item.Month[i].Color = Brushes.Transparent;
                            }
                        }
                    }

                    // Task Load
                    item.OnProjectTaskShow += (p) =>
                    {
                        // var result = Server.API.HttpSend<M_Project[]>("/project/list/select");
                    };

                    this.ProjectList.Add(item);
                }
            }
        }

        private void BtnProjectAdd()
        {
            new Window().ShowDialog();
        }
    }
}
