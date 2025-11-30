using community.Common;
using community.Models;
using Microsoft.SqlServer.Server;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows;

namespace community.ViewModels
{
    public class VM_Login : ViewModelBase
    {
        public event ActionHandler<M_Employee> LoginEvent;

        public M_Employee LoginUser { get; set; } = new M_Employee();

        public M_Employee SignupUser { get; set; } = new M_Employee();

        private Visibility signupVisibility = Visibility.Collapsed;
        public Visibility SignupVisibility
        {
            get => this.signupVisibility;
            set => base.OnPropertyChanged(ref this.signupVisibility, value);
        }

        private void Loaded()
        {
            Console.WriteLine("VM_Login Loaded");
            this.LoginUser = new M_Employee();
            this.SignupUser = new M_Employee();
        }

        private void OnLogin()
        {
            var login = this.LoginUser;

            try
            {
                Dictionary<string, dynamic> param = new Dictionary<string, dynamic>();
                param.Add("login_id", login.Login_Id);
                param.Add("login_pw", login.Login_Pw);

                var user = HTTP_Server.API.HttpSend<M_Employee[]>("/employee/list/select", HTTP_Server.Method.POST, param);

                if (user.Length > 0)
                {
                    // 로그인 성공
                    login.Login_Id = string.Empty;
                    login.Login_Pw = string.Empty;

                    this.LoginEvent?.Invoke(user[0]);
                }
                else
                {
                    // 로그인 실패
                    MessageBox.Show("아이디 또는 비밀번호가 올바르지 않습니다.", "로그인 실패",
                        MessageBoxButton.OK, MessageBoxImage.Warning);
                }
            }
            catch (Exception ex) 
            {
                MessageBox.Show(ex.Message, "로그인 실패",
                    MessageBoxButton.OK, MessageBoxImage.Error);
            }
        }

        private void OnSignUp()
        {
            MessageBox.Show("회원가입 페이지로 이동합니다.", "회원가입", MessageBoxButton.OK, MessageBoxImage.Information);
            SignupVisibility = Visibility.Visible;
        }

        private void OnSignUpCommit()
        {
            // 회원가입 개시.
            var u = SignupUser;

            // 로그인 ID 중복 검사.
            if (u.Login_Id != "")
            {
                object id = new { login_id = u.Login_Id };
                M_Employee e = HTTP_Server.API.HttpSend<M_Employee>("/employee/list/select", HTTP_Server.Method.POST, id);

                if (e != null)
                {
                    MessageBox.Show("해당 로그인 ID는 사용하실 수 없습니다.", "회원가입 오류");
                    return;
                }
            }
            else
            {
                MessageBox.Show("로그인 ID를 입력해주세요.", "회원가입 오류");
                return;
            }

            // 패스워드 일치 검사.
            if (u.Login_Id != "")
            {
                if (u.Login_Pw != u.Login_Pw_Check)
                {
                    MessageBox.Show("비밀번호가 일치하지 않습니다.\n다시 작성해주세요.", "회원가입 오류");
                    return;
                }
            }
            else
            {
                MessageBox.Show("로그인 비밀번호를 입력해주세요.", "회원가입 오류");
                return;
            }

            // 이름 공백 검사.
            if (u.Name == "")
            {
                MessageBox.Show("이름을 입력해주세요.", "회원가입 오류");
                return;
            }

            M_DB_Result d = HTTP_Server.API.HttpSend<M_DB_Result>("/employee/list/insert", HTTP_Server.Method.POST, u);
            if (d != null && d.InsertId > 0)
            {
                this.SignupVisibility = Visibility.Collapsed;
                this.LoginUser.Login_Id = u.Login_Id;
                this.LoginUser.Login_Pw = u.Login_Pw;
                this.OnLogin();
                return;
            }
            else
            {
                MessageBox.Show("알 수 없는 오류가 발생했습니다.\n관리자에게 문의하여 주세요.", "회원가입 오류");
                return;
            }
        }
    }
}
