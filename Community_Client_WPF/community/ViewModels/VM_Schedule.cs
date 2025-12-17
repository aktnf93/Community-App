using community.Models;
using System;
using System.Collections.Generic;
using System.Collections.ObjectModel;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace community.ViewModels
{
    public class ScheduleItem
    {
        public string Title { get; set; }
    }

    public class DaySchedule
    {
        public DateTime Date { get; set; }
        public ObservableCollection<ScheduleItem> Items { get; set; } = new ObservableCollection<ScheduleItem>();
    }

    public class VM_Schedule : ViewModelBase
    {
        // public ObservableCollection<M_Schedule> Schedules { get; set; } = new ObservableCollection<M_Schedule>();

        public ObservableCollection<DaySchedule> Schedules { get; set; } = new ObservableCollection<DaySchedule>()
        {
            new DaySchedule()
            {
                Date = DateTime.Today,
                Items = new ObservableCollection<ScheduleItem>
                {
                    new ScheduleItem { Title = "회의" },
                    new ScheduleItem { Title = "점심 약속" }
                }
            },

            new DaySchedule()
            {
                Date = DateTime.Today.AddDays(1),
                Items = new ObservableCollection<ScheduleItem>
                {
                    new ScheduleItem { Title = "프로젝트 마감" }
                }
            }
        };

        public VM_Schedule()
        {

        }

    }
}
