using community.Common;
using community.Models;

namespace community.ViewModels
{
    public class ViewModelBase : Notify
    {
        private M_Employee currentUser = new M_Employee();
        private M_Employee_Attendance currentUserAttendance = new M_Employee_Attendance();

        public M_Employee CurrentUser
        {
            get => this.currentUser;
            set => base.OnPropertyChanged(ref this.currentUser, value);
        }

        public M_Employee_Attendance CurrentUserAttendance
        {
            get => this.currentUserAttendance;
            set => base.OnPropertyChanged(ref this.currentUserAttendance, value);
        }
    }
}
