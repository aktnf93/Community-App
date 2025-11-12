using community.Common;
using community.Models;

namespace community.ViewModels
{
    public class ViewModelBase : Notify
    {
        private M_Employee currentUser = new M_Employee();
        public M_Employee CurrentUser
        {
            get => this.currentUser;
            set => base.OnPropertyChanged(ref this.currentUser, value);
        }
    }
}
