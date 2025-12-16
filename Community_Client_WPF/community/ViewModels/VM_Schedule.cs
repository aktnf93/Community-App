using community.Models;
using System;
using System.Collections.Generic;
using System.Collections.ObjectModel;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace community.ViewModels
{
    public class VM_Schedule : ViewModelBase
    {
        public ObservableCollection<M_Schedule> Schedules { get; set; } = new ObservableCollection<M_Schedule>();
    }
}
