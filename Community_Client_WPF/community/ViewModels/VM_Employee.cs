using community.Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace community.ViewModels
{
    public class VM_Employee : ViewModelBase
    {
        public M_Card BannerCard { get; set; } = new M_Card()
        {
            Title = "직원관리"
        };

        public M_Card[] DashboardCard { get; set; } =
        {
            new M_Card() { Title = "총 직원", Content = "", Description = "" },
            new M_Card() { Title = "출근", Content = "", Description = "" },
            new M_Card() { Title = "퇴근", Content = "", Description = "" },
            new M_Card() { Title = "휴가", Content = "", Description = "" },
            new M_Card() { Title = "외주", Content = "", Description = "" },
        };

        private void Loaded()
        {
            Console.WriteLine("VM_Employee Loaded");
        }
    }
}
