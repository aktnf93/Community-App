using community.Common;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows;

namespace community.Models
{
    public class M_Views_Show : Notify
    {
        private Visibility login = Visibility.Visible;

        public Visibility Login
        {
            get => this.login;
            set => base.OnPropertyChanged(ref this.login, value);
        }


    }
}
