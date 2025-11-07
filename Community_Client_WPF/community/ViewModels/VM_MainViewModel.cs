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
        private VM_Login vm_login;
        private VM_Post vm_post;
        private VM_Chat vm_chat;
        private VM_Project vm_project;
        private VM_Customer vm_customer;
        private VM_Product vm_product;
        private VM_Employee vm_employee;
        private VM_System vm_system;
        public ViewModelBase currentViewModel;
        private MenuType menuSelected = MenuType.Login;

        public ViewModelBase CurrentViewModel
        {
            get => this.currentViewModel;
            set => base.OnPropertyChanged(ref this.currentViewModel, value);
        }
        
        public MenuType MenuSelected
        {
            get => this.menuSelected;
            set
            {
                base.OnPropertyChanged(ref this.menuSelected, value);

                switch (this.menuSelected)
                {
                    default:
                    case MenuType.Login:
                        this.CurrentViewModel = this.vm_login;
                        break;

                    case MenuType.Post:
                        this.CurrentViewModel = this.vm_post;
                        break;

                    case MenuType.Chat:
                        this.CurrentViewModel = this.vm_chat;
                        break;

                    case MenuType.Project:
                        this.CurrentViewModel = this.vm_project;
                        break;

                    case MenuType.Customer:
                        this.CurrentViewModel = this.vm_customer;
                        break;

                    case MenuType.Product:
                        this.CurrentViewModel = this.vm_product;
                        break;

                    case MenuType.Employee:
                        this.CurrentViewModel = this.vm_employee;
                        break;

                    case MenuType.System:
                        this.CurrentViewModel = this.vm_system;
                        break;
                }
            }
        }

        public VM_MainViewModel()
        {
            this.vm_login = new VM_Login();
            this.vm_login.LoginEvent += VM_Login_LoginEvent;

            this.CurrentViewModel = this.vm_login;
        }

        private void VM_Login_LoginEvent(bool isLogin)
        {
            if (isLogin)
            {
                vm_chat = new VM_Chat();
                vm_post = new VM_Post();
                vm_project = new VM_Project();
                vm_customer = new VM_Customer();
                vm_product = new VM_Product();
                vm_employee = new VM_Employee();
                vm_system = new VM_System();

                MenuSelected = MenuType.Post;
            }
        }
    }
}
