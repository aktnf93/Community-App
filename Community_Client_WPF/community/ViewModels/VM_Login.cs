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
        public event ActionHandler<bool> LoginEvent;

        public M_Employee LoginUser { get; set; } = new M_Employee();

        private void Loaded()
        {
            Console.WriteLine("VM_Login Loaded");
        }

        private void OnLogin()
        {
            bool result = false;

            try
            {
                // var u = Server_REST_API.Instance.PostUser(this.LoginUser.Login_Id, this.LoginUser.Login_Pw);

                Dictionary<string, dynamic> param = new Dictionary<string, dynamic>();
                param.Add("login_id", this.LoginUser.Login_Id);
                param.Add("login_pw", this.LoginUser.Login_Pw);


                var rows = Server.API.HttpSendAsync<Dictionary<string, dynamic>, M_Employee[]>("/employee/list/select", Server.HttpMethod.POST, param);

                if (rows.Length > 0)
                {
                    var u = rows[0];
                    // 로그인 성공
                    this.LoginUser.Id = u.Id;
                    this.LoginUser.Name = u.Name;
                    this.LoginUser.Login_Id = string.Empty;
                    this.LoginUser.Login_Pw = string.Empty;
                    result = true;
                }
                else
                {
                    // 로그인 실패
                    new Exception("아이디 또는 비밀번호가 올바르지 않습니다.");
                }
            }
            catch (Exception ex)
            {
                MessageBox.Show(ex.Message, "로그인 실패",
                    MessageBoxButton.OK, MessageBoxImage.Error);
            }

            this.LoginEvent?.Invoke(result);
        }

        private void OnSignUp()
        {
            MessageBox.Show("회원가입 페이지로 이동합니다.", "회원가입", MessageBoxButton.OK, MessageBoxImage.Information);
        }

        private void OnForgotUsername()
        {
            MessageBox.Show("아이디 찾기 페이지로 이동합니다.", "아이디 찾기", MessageBoxButton.OK, MessageBoxImage.Information);
        }

        private void OnForgotPassword()
        {
            MessageBox.Show("비밀번호 찾기 페이지로 이동합니다.", "비밀번호 찾기", MessageBoxButton.OK, MessageBoxImage.Information);
        }

        private void OnLogin_Kakao()
        {
            MessageBox.Show("카카오 로그인 페이지로 이동합니다.", "카카오 로그인", MessageBoxButton.OK, MessageBoxImage.Information);
        }
    }
}
