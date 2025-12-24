using System;
using System.Collections.ObjectModel;

namespace community.Models
{
    public class M_DaySchedule
    {
        public DateTime Date { get; set; }
        public string Title { get; set; }
        public string Alias { get; set; }
        public bool IsToday { get; set; }

        public ObservableCollection<M_Schedule> Items { get; set; } 
            = new ObservableCollection<M_Schedule>();
    }
}
