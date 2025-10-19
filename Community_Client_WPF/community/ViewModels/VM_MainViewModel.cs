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
        public VM_Board Instance_VM_Board { get; set; } = new VM_Board();
        public VM_Chat Instance_VM_Chat { get; set; } = new VM_Chat();
        public VM_Employee Instance_VM_Employee { get; set; } = new VM_Employee();
        public VM_Inventory Instance_VM_Inventory { get; set; } = new VM_Inventory();
        public VM_Login Instance_VM_Login { get; set; } = new VM_Login();
        public VM_Messages Instance_VM_Messages { get; set; } = new VM_Messages();
        public VM_Project Instance_VM_Project { get; set; } = new VM_Project();
        public VM_Settings Instance_VM_Settings { get; set; } = new VM_Settings();
        public VM_TEST Instance_VM_TEST { get; set; } = new VM_TEST();



        public M_User Login_User { get; set; } = new M_User();

        public M_Views_Show Views_Show { get; set; } = new M_Views_Show();


        public ViewModelBase currentViewModel = null;
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
                    case MenuType.None:
                        this.CurrentViewModel = null;
                        break;

                    case MenuType.Board:
                        this.CurrentViewModel = this.Instance_VM_Board;
                        break;

                    case MenuType.Chat:
                        this.CurrentViewModel = this.Instance_VM_Chat;
                        break;

                    case MenuType.Employee:
                        this.CurrentViewModel = this.Instance_VM_Employee;
                        break;

                    case MenuType.Inventory:
                        this.CurrentViewModel = this.Instance_VM_Inventory;
                        break;

                    case MenuType.Login:
                        this.CurrentViewModel = this.Instance_VM_Login;
                        break;

                    case MenuType.Messages:
                        this.CurrentViewModel = this.Instance_VM_Messages;
                        break;

                    case MenuType.Project:
                        this.CurrentViewModel = this.Instance_VM_Project;
                        break;

                    case MenuType.Settings:
                        this.CurrentViewModel = this.Instance_VM_Settings;
                        break;

                    case MenuType.TEST:
                        this.CurrentViewModel = this.Instance_VM_TEST;
                        break;

                    default:
                        this.CurrentViewModel = null;
                        break;
                }
            }
        }


        public VM_MainViewModel()
        {
            this.Login_User.LoginEvent += User_OnLogin;
        }

        private void User_OnLogin()
        {
            var u = Server_REST_API.Instance.PostUser(this.Login_User.Login_Id, this.Login_User.Login_Pw);

            if (u.Id != 0)
            {
                // 로그인 성공

                // this.User_Messages.Clear();
                // 
                // for (int i = 0; i < boards.Length; i++)
                // {
                //     this.User_Messages.Add(boards[i]);
                // }

                this.Login_User.Id = u.Id;
                this.Login_User.Nickname = u.Nickname;
                this.Login_User.Login_Id = string.Empty;
                this.Login_User.Login_Pw = string.Empty;

                this.Views_Show.Login = Visibility.Collapsed;

                this.Instance_VM_Board.Login_User_Id = this.Login_User.Id;
            }
            else
            {
                // 로그인 실패
                MessageBox.Show("아이디 또는 비밀번호가 올바르지 않습니다.", "로그인 실패");
            }
        }
    }
}
