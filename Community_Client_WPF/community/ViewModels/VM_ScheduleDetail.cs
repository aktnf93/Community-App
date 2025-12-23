using community.Common;
using community.Models;

namespace community.ViewModels
{
    public class VM_ScheduleDetail
    {
        public event ActionHandler<M_Schedule> SaveEvent;
        public event ActionHandler<M_Schedule> DeleteEvent;

        public M_Schedule Schedule { get; set; }

        private void BtnScheduleSave()
        {
            this.SaveEvent?.Invoke(this.Schedule);
        }

        private void BtnScheduleDelete()
        {
            this.DeleteEvent?.Invoke(this.Schedule);
        }
    }
}
