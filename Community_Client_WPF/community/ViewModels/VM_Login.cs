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

        /// <summary>
        /// 로그인
        /// </summary>
        private async void OnLogin()
        {
            await UiAction.Instance.ExecuteAsync(async () => 
            {
                var login = this.LoginUser;

                var req = new { login_id = login.Login_Id, login_pw = login.Login_Pw };
                var user = await HTTP_Server.API.HttpSendAsync<M_Employee[]>("/employee/list/login", HTTP_Server.Method.POST, req);

                if (user is null)
                {
                    MessageBox.Show(
                        "서버에 접속하지 못했습니다.",
                        "로그인 실패",
                        MessageBoxButton.OK, MessageBoxImage.Error);
                    return;
                }

                if (user.Length < 1)
                {
                    MessageBox.Show(
                        "아이디 또는 비밀번호가 올바르지 않습니다.",
                        "로그인 실패",
                        MessageBoxButton.OK, MessageBoxImage.Warning);
                    return;
                }

                // 로그인 성공
                login.Login_Id = string.Empty;
                login.Login_Pw = string.Empty;

                this.LoginEvent?.Invoke(user[0]);
            });
        }

        /// <summary>
        /// 회원가입 페이지로 전환
        /// </summary>
        private void OnSignUp()
        {
            MessageBox.Show(
                "회원가입 페이지로 이동합니다.", 
                "회원가입", 
                MessageBoxButton.OK, MessageBoxImage.Information);
            SignupVisibility = Visibility.Visible;
        }

        /// <summary>
        /// 회원가입 시도
        /// </summary>
        private async void OnSignUpCommit()
        {
            await UiAction.Instance.ExecuteAsync(async () =>
            {
                var u = SignupUser;

                if (u is null)
                {
                    MessageBox.Show(
                        "입력 정보가 올바르지 않습니다.",
                        "회원가입 오류",
                        MessageBoxButton.OK, MessageBoxImage.Error);
                    return;
                }

                if (string.IsNullOrEmpty(u.Login_Id) || string.IsNullOrEmpty(u.Login_Pw) || string.IsNullOrEmpty(u.Name))
                {
                    MessageBox.Show(
                        "로그인 ID, 비밀번호, 사용자 이름을 입력해주세요.",
                        "회원가입 오류",
                        MessageBoxButton.OK, MessageBoxImage.Error);
                    return;
                }

                if (u.Login_Pw != u.Login_Pw_Check)
                {
                    MessageBox.Show(
                        "비밀번호가 일치하지 않습니다.\n다시 작성해주세요.",
                        "회원가입 오류",
                        MessageBoxButton.OK, MessageBoxImage.Error);
                    return;
                }

                // // 로그인 ID 중복 검사.
                // object id = new { login_id = u.Login_Id };
                // M_Employee e = HTTP_Server.API.HttpSend<M_Employee>("/employee/list/select", HTTP_Server.Method.POST, id);
                // if (e != null)
                // {
                //     MessageBox.Show("해당 로그인 ID는 사용하실 수 없습니다.", "회원가입 오류");
                //     return;
                // }

                M_DB_Result d = await HTTP_Server.API.HttpSendAsync<M_DB_Result>("/employee/list/insert", HTTP_Server.Method.POST, u);

                if (d is null)
                {
                    MessageBox.Show(
                        "알 수 없는 오류가 발생했습니다.\n관리자에게 문의하여 주세요.",
                        "회원가입 오류",
                        MessageBoxButton.OK, MessageBoxImage.Error);
                    return;
                }

                if (d.InsertId < 1)
                {
                    MessageBox.Show(
                        "해당 정보로 회원가입 할 수 없습니다.",
                        "회원가입 오류",
                        MessageBoxButton.OK, MessageBoxImage.Error);
                    return;
                }

                this.SignupVisibility = Visibility.Collapsed;
                this.LoginUser.Login_Id = u.Login_Id;
                this.LoginUser.Login_Pw = u.Login_Pw;
            });

            this.OnLogin();
        }
    }
}
