using community.Common;
using community.Models;
using System;
using System.Collections.Generic;
using System.Collections.ObjectModel;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

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
                    this.ProjectList.Add(item);
                }
            }
        }

        private void ProjectAdd()
        {
            var project = new M_Project()
            {
                Name = "New Project"
            };

            var result = Server.API.HttpSend<M_DB_Result>("/project/list/insert", Server.Method.POST, project);

            if (result != null)
            {
                if (result.InsertId.HasValue && result.InsertId.Value > 0)
                {
                    this.ProjectList.Add(project);
                }
            }
        }
    }
}
