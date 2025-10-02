using System;
using System.Collections.Generic;
using System.Collections.ObjectModel;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using community.Common;
using community.Models;
using System.Data;
using System.Windows;

namespace community.ViewModels
{
    public class VM_MainViewModel : Notify
    {
        public VM_Moard VM_Moard_Instance { get; set; } = new VM_Moard();

        public ObservableCollection<M_Board> User_Messages { get; set; } = new ObservableCollection<M_Board>();


        public M_User Login_User { get; set; } = new M_User();

        public M_Views_Show Views_Show { get; set; } = new M_Views_Show();


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

                VM_Moard_Instance.Login_User_Id = this.Login_User.Id;
            }
            else
            {
                // 로그인 실패
                MessageBox.Show("아이디 또는 비밀번호가 올바르지 않습니다.", "로그인 실패");
            }
        }
    }
}
