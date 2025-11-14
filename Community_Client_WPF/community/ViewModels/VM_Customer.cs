using community.Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace community.ViewModels
{
    public class VM_Customer : ViewModelBase
    {
        public M_Card BannerCard { get; set; } = new M_Card()
        {
            Title = "고객관리"
        };

        public M_Card[] DashboardCard { get; set; } =
        {
            new M_Card() { Title = "총 고객사", Content = "", Description = "" },
            new M_Card() { Title = "계약 중", Content = "", Description = "" },
            new M_Card() { Title = "", Content = "", Description = "" },
            new M_Card() { Title = "", Content = "", Description = "" },
            new M_Card() { Title = "", Content = "", Description = "" },
        };

        private void Loaded()
        {
            Console.WriteLine("VM_Customer Loaded");
        }
    }
}
