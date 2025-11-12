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
    public class VM_System : ViewModelBase
    {
        public M_Card BannerCard { get; set; } = new M_Card()
        {
            Title = "시스템 설정"
        };

        public M_Card[] DashboardCard { get; set; } =
        {
            new M_Card() { Title = "", Content = "", Description = "" },
            new M_Card() { Title = "", Content = "", Description = "" },
            new M_Card() { Title = "", Content = "", Description = "" },
            new M_Card() { Title = "", Content = "", Description = "" },
            new M_Card() { Title = "", Content = "", Description = "" },
        };

        public ObservableCollection<M_System_Config> SystemConfigs { get; set; }
            = new ObservableCollection<M_System_Config>();

        private void Loaded()
        {
            Console.WriteLine("VM_System Loaded");


            var configs = Server.API.HttpSend<M_System_Config[]>("/system/config/select");
            this.SystemConfigs.Clear();

            if (configs != null)
            {
                foreach (var c in configs)
                {
                    this.SystemConfigs.Add(c);
                }
            }
        }
    }
}
