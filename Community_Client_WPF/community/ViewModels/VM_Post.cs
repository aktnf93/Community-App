using community.Common;
using community.Models;
using System;
using System.Collections.Generic;
using System.Collections.ObjectModel;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows;

namespace community.ViewModels
{
    public class VM_Post : ViewModelBase
    {
        public VM_Post()
        {

        }

        private void Loaded()
        {
            Console.WriteLine("VM_Board Loaded");
        }
    }
}
