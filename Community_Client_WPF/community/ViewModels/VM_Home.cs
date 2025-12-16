using community.Common;
using community.Models;
using Mysqlx.Crud;
using System;
using System.Collections.Generic;
using System.Collections.ObjectModel;
using System.ComponentModel;
using System.Data;
using System.Threading.Tasks;
using System.Windows;
using System.Windows.Controls;
using System.Windows.Data;

namespace community.ViewModels
{
    public class VM_Home : ViewModelBase
    {
        public event ActionHandler<int> OnQuickView;

        private DateTime currentAt;
        public DateTime CurrentAt
        {
            get => this.currentAt;
            set => base.OnPropertyChanged(ref this.currentAt, value);
        }

        public ObservableCollection<M_Project> ProjectList { get; set; } = new ObservableCollection<M_Project>();
        public M_Employee_Attendance CurrentUserDayTime { get; set; } = new M_Employee_Attendance();
        public M_Employee_WeekTime CurrentUserWeekTime { get; set; } = new M_Employee_WeekTime();
        public ObservableCollection<M_Post> NoticePosts { get; set; } = new ObservableCollection<M_Post>();
        public ObservableCollection<M_Post> RecentPosts { get; set; } = new ObservableCollection<M_Post>();

        private async void Loaded()
        {
            Console.WriteLine("Home");

            await ProfileLoad();

            await PostLoad();

            await ProjectLoad();
        }

        private async Task ProfileLoad()
        {
            await UiAction.Instance.ExecuteAsync(async () =>
            {
                object req = null;

                // 프로필 및 근태 정보 불러오기
                req = new { select_type = "day_time", employee_id = base.CurrentUser.Id, date = DateTime.Now.ToString("yyyy-MM-dd") };
                var dayTime = await HTTP_Server.API.HttpSendAsync<M_Employee_Attendance[]>("/employee/attendance/select", HTTP_Server.Method.POST, req);
                if (dayTime != null && dayTime.Length > 0)
                {
                    this.CurrentUserDayTime = dayTime[0];
                    base.OnPropertyChanged(nameof(this.CurrentUserDayTime));
                }

                // 주간 근무시간 불러오기
                req = new { select_type = "week_time", employee_id = base.CurrentUser.Id, date = DateTime.Now.ToString("yyyy-MM-dd") };
                var weektime = await HTTP_Server.API.HttpSendAsync<DataTable>("/employee/attendance/select", HTTP_Server.Method.POST, req);

                if (weektime != null)
                {
                    if (weektime.Rows.Count > 0)
                    {
                        var set_week = weektime.Rows[0];
                        var current_week = this.CurrentUserWeekTime;

                        try
                        {
                            current_week.Employee_Id        = Convert.ToInt32(set_week["employee_id"]);
                            current_week.Total_Minutes      = TimeSpan.FromMinutes(Convert.ToInt32(set_week["total_minutes"]));
                            current_week.Base_Minutes       = TimeSpan.FromMinutes(Convert.ToInt32(set_week["base_minutes"]));
                            current_week.Overtime_Minutes   = TimeSpan.FromMinutes(Convert.ToInt32(set_week["overtime_minutes"]));
                            current_week.Remaining_Minutes  = TimeSpan.FromMinutes(Convert.ToInt32(set_week["remaining_minutes"]));
                        }
                        catch (Exception ex)
                        {
                            Console.WriteLine("주간 근무시간 로드 에러 {0}", ex);
                        }
                    }
                }
            });
        }

        private async Task PostLoad()
        {
            await UiAction.Instance.ExecuteAsync(async () =>
            {
                this.NoticePosts.Clear();

                var notice_req = new { post_level = 1, limit = 6, post_level_operator = 1 };
                var notice = HTTP_Server.API.HttpSend<List<M_Post>>("/post/list/select", HTTP_Server.Method.POST, notice_req);

                if (notice != null)
                {
                    foreach (var post in notice)
                    {
                        this.NoticePosts.Add(post);
                    }
                }


                this.RecentPosts.Clear();

                var recent_req = new { post_level = 1, limit = 6, post_level_operator = 0 };
                var recent = HTTP_Server.API.HttpSend<List<M_Post>>("/post/list/select", HTTP_Server.Method.POST, recent_req);

                if (recent != null)
                {
                    foreach (var post in recent)
                    {
                        this.RecentPosts.Add(post);
                    }
                }
            });
        }

        private async Task ProjectLoad()
        {
            await UiAction.Instance.ExecuteAsync(async () =>
            {
                // 프로젝트 불러오기
                var result = HTTP_Server.API.HttpSend<M_Project[]>("/project/list/select");
                this.ProjectList = new ObservableCollection<M_Project>(result);
                base.OnPropertyChanged(nameof(this.ProjectList));
            });
        }

        private async Task BtnCheckIn()
        {
            await UiAction.Instance.ExecuteAsync(async () =>
            {
                var result = MessageBox.Show(
                    "출근 하시겠습니까?",
                    "출근",
                    MessageBoxButton.YesNo, MessageBoxImage.Information);

                if (result != MessageBoxResult.Yes)
                {
                    return;
                }

                var req = new { employee_id = base.CurrentUser.Id };
                var db_result = await HTTP_Server.API.HttpSendAsync<M_DB_Result>("/employee/attendance/insert", HTTP_Server.Method.POST, req);
                if (db_result is null)
                {
                    // 출근 X
                }
                else
                {
                    // 출근 ok. 
                }
            });

            await ProfileLoad();
        }

        private async Task BtnCheckOut()
        {
            await UiAction.Instance.ExecuteAsync(async () =>
            {
                var result = MessageBox.Show(
                    "퇴근 하시겠습니까?",
                    "퇴근",
                    MessageBoxButton.YesNo, MessageBoxImage.Information);

                if (result != MessageBoxResult.Yes)
                {
                    return;
                }

                var req = new { employee_id = base.CurrentUser.Id };
                var db_result = await HTTP_Server.API.HttpSendAsync<M_DB_Result>("/employee/attendance/update", HTTP_Server.Method.PUT, req);
                if (db_result is null)
                {
                    // 출근 X
                }
                else
                {
                    // 출근 ok. 
                }
            });

            await ProfileLoad();
        }

        /// <summary>
        /// 공지사항 더보기
        /// </summary>
        /// <returns></returns>
        private async Task BtnGoNoticePosts()
        {
            this.OnQuickView?.Invoke(0);
        }

        /// <summary>
        /// 최근 게시물 더보기
        /// </summary>
        /// <returns></returns>
        private async Task BtnGoRecentPosts()
        {
            this.OnQuickView?.Invoke(1);
        }

        /// <summary>
        /// 최근 프로젝트 더보기
        /// </summary>
        /// <returns></returns>
        private async Task BtnGoProjects()
        {
            this.OnQuickView?.Invoke(2);
        }
    }
}
