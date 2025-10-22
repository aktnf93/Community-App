using community.Common;
using community.Enums;
using community.Models;
using System;
using System.Collections.Generic;
using System.Collections.ObjectModel;
using System.Data;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows;

namespace community.ViewModels
{
    public class VM_MainViewModel : ViewModelBase
    {
        public VM_Login VM_Login { get; set; }

        private VM_Board vm_Board;
        private VM_Messages vm_Messages;
        private VM_Chat vm_Chat;

        private VM_Project vm_Project;
        private VM_Customer vm_Customer;
        private VM_Inventory vm_Inventory;
        private VM_Employee vm_Employee;
        private VM_Settings vm_Settings;

        public ViewModelBase currentViewModel;
        public ViewModelBase CurrentViewModel
        {
            get => this.currentViewModel;
            set => base.OnPropertyChanged(ref this.currentViewModel, value);
        }

        private MenuType menuSelected = MenuType.None;
        public MenuType MenuSelected
        {
            get => this.menuSelected;
            set
            {
                base.OnPropertyChanged(ref this.menuSelected, value);

                switch (this.menuSelected)
                {
                    default:
                    case MenuType.None:
                        this.CurrentViewModel = null;
                        break;

                    case MenuType.Board:
                        this.CurrentViewModel = this.vm_Board;
                        break;

                    case MenuType.Messages:
                        this.CurrentViewModel = this.vm_Messages;
                        break;

                    case MenuType.Chat:
                        this.CurrentViewModel = this.vm_Chat;
                        break;

                    case MenuType.Project:
                        this.CurrentViewModel = this.vm_Project;
                        break;

                    case MenuType.Customer:
                        this.CurrentViewModel = this.vm_Customer;
                        break;

                    case MenuType.Inventory:
                        this.CurrentViewModel = this.vm_Inventory;
                        break;

                    case MenuType.Employee:
                        this.CurrentViewModel = this.vm_Employee;
                        break;

                    case MenuType.Settings:
                        this.CurrentViewModel = this.vm_Settings;
                        break;
                }
            }
        }


        public VM_MainViewModel()
        {
            this.VM_Login = new VM_Login();
            this.VM_Login.LoginEvent += VM_Login_LoginEvent;
        }

        private void VM_Login_LoginEvent(bool isLogin)
        {
            if (isLogin)
            {
                vm_Board = new VM_Board();
                vm_Messages = new VM_Messages();
                vm_Chat = new VM_Chat();
                vm_Project = new VM_Project();
                vm_Customer = new VM_Customer();
                vm_Inventory = new VM_Inventory();
                vm_Employee = new VM_Employee();
                vm_Settings = new VM_Settings();

                MenuSelected = MenuType.Board;
            }
        }
    }
}
