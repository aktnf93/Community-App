using community.Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace community.ViewModels
{
    public class VM_Product : ViewModelBase
    {
        public M_Card BannerCard { get; set; } = new M_Card()
        {
            Title = "재고관리"
        };

        public M_Card[] DashboardCard { get; set; } =
        {
            new M_Card() { Title = "총 제품 종류", Content = "", Description = "" },
            new M_Card() { Title = "총 제품 수량", Content = "", Description = "" },
            new M_Card() { Title = "입고 수량", Content = "", Description = "" },
            new M_Card() { Title = "출고 수량", Content = "", Description = "" },
            new M_Card() { Title = "단종 제품", Content = "", Description = "" },
        };

        private void Loaded()
        {
            Console.WriteLine("VM_Inventory Loaded");
        }
    }
}
