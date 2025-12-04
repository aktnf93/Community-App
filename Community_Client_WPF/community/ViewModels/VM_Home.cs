using community.Common;
using community.Models;
using Mysqlx.Crud;
using System;
using System.Collections.Generic;
using System.Collections.ObjectModel;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace community.ViewModels
{
    public class VM_Home : ViewModelBase
    {
        private DateTime currentAt;
        public DateTime CurrentAt
        {
            get => this.currentAt;
            set => base.OnPropertyChanged(ref this.currentAt, value);
        }

        public ObservableCollection<M_Project> ProjectList { get; set; }
            = new ObservableCollection<M_Project>();

        private void Loaded()
        {
            Console.WriteLine("Home");

            // 프로필 및 근태 정보 불러오기
            var req = new { employee_id = base.CurrentUser.Id, select_type = "single" };
            var result = HTTP_Server.API.HttpSend<M_Employee_Attendance[]>("/employee/attendance/select", data: req);
            if (result != null && result.Length > 0)
            {
                base.CurrentUserAttendance = result[0];
            }

            // 게시글 중 공지사항 불러오기
            //

            // 공지사항 제외한 게시글 불러오기
            //

            // 프로젝트 불러오기
            var projects = HTTP_Server.API.HttpSend<M_Project[]>("/project/list/select");
            this.ProjectList = new ObservableCollection<M_Project>(projects);
            base.OnPropertyChanged(nameof(this.ProjectList));
        }

        private void BtnCheckIn()
        {
            var req = new { employee_id = base.CurrentUser.Id };
            var result = HTTP_Server.API.HttpSend<M_Employee_Attendance[]>("/employee/attendance/insert", HTTP_Server.Method.POST, req);
            if (result != null)
            {
                // 출근 ok.
                
            }
            else
            {
                // 출근 x
            }

            Loaded();
        }

        private void BtnCheckOut()
        {
            var req = new { employee_id = base.CurrentUser.Id };
            var result = HTTP_Server.API.HttpSend<M_Employee_Attendance[]>("/employee/attendance/update", HTTP_Server.Method.PUT, req);
            if (result != null)
            {
                // 출근 ok.
                
            }
            else
            {
                // 출근 x
            }

            Loaded();
        }
    }
}
