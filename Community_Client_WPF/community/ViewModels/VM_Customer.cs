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

        private void Loaded()
        {
            Console.WriteLine("VM_Customer Loaded");
        }

        private void BtnCustomerSearch()
        {

        }

        private void BtnCustomerAdd()
        {

        }

        private void BtnCustomerUpdate()
        {

        }

        private void BtnCustomerDelete()
        {

        }
    }
}
