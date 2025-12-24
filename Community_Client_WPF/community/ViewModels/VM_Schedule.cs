using community.Common;
using community.Models;
using community.Views;
using System;
using System.Collections.ObjectModel;
using System.Linq;
using System.Threading.Tasks;
using System.Windows;
using System.Windows.Controls;

namespace community.ViewModels
{
    public class VM_Schedule : ViewModelBase
    {
        public event ActionHandler OnScheduleViewChanged;

        /// <summary>
        /// 왼쪽 일정 리스트
        /// </summary>
        public ObservableCollection<M_Schedule> ScheduleList { get; set; } 
            = new ObservableCollection<M_Schedule>();

        /// <summary>
        /// 캘린더에 표시될 일정 리스트
        /// </summary>
        public ObservableCollection<M_DaySchedule> ScheduleView { get; set; } 
            = new ObservableCollection<M_DaySchedule>();

        private async Task Loaded()
        {
            Console.WriteLine("VM_Schedule");

            Console.WriteLine("Loaded 호출");
            this.DisplayDate = DateTime.Now;
        }

        private async Task CalendarLoad(DateTime toDay)
        {
            var holidays = await HTTP_Server.API.GetHolidays(toDay);

            int year        = toDay.Year;
            int month       = toDay.Month;
            int daysInMonth = DateTime.DaysInMonth(year, month);

            for (int day = 1; day <= daysInMonth; day++)
            {
                var d = new M_DaySchedule();
                d.Date = new DateTime(year, month, day);

                foreach (var h in holidays)
                {
                    if (h.Date.Date == d.Date.Date)
                    {
                        d.Title = h.Name;
                        break;
                    }
                }

                this.ScheduleView.Add(d);
            }
        }

        private async Task ScheduleLoad(DateTime date)
        {
            await UiAction.Instance.ExecuteAsync(async () =>
            {
                this.ScheduleList.Clear();
                this.ScheduleView.Clear();

                await this.CalendarLoad(date); // 달력 생성.

                var req = new 
                { 
                    start_year = date.Year, 
                    start_month = date.Month,
                    end_year = date.Year,
                    end_month = date.Month
                };
                var schedules = await HTTP_Server.API.HttpSendAsync<M_Schedule[]>("/schedule/select", HTTP_Server.Method.POST, req);
                schedules = schedules.OrderBy(x => x.Start_At).ToArray();

                if (schedules != null)
                {
                    // 일정 리스트 생성
                    foreach (var s in schedules)
                    {
                        s.SelectEvent += this.ScheduleShow;
                        this.ScheduleList.Add(s);
                    }

                    // 달력 내에 일정 삽입
                    foreach (var v in this.ScheduleView)
                    {
                        // 일자 별 일정 등록
                        foreach (var s in schedules)
                        {
                            if (s.Start_At.Date <= v.Date.Date && v.Date.Date <= s.End_At.Date)
                            {
                                v.Items.Add(s);
                            }
                        }
                    }
                }
                else
                {
                    Console.WriteLine("ScheduleLoad 실패");
                }

                // Task.Delay(5).Wait();
                this.OnScheduleViewChanged?.Invoke();

                // this.OnScheduleViewChanged?.GetInvocationList()
                // .ToList()
                // .ForEach(d =>
                // {
                //     try { d.DynamicInvoke(); }
                //     catch (Exception ex) { Console.WriteLine(ex); }
                // });
            });
        }

        private async Task BtnScheduleAdd()
        {
            var display = this.DisplayDate;
            var current = DateTime.Now;

            var start = (display.Year == current.Year && display.Month == current.Month) ? current : display;

            this.ScheduleShow(new M_Schedule() { Title = "새 일정", Start_At = start, End_At = start });
        }

        private void ScheduleShow(M_Schedule schedule)
        {
            var win = new V_ScheduleDetail();
            var context = new VM_ScheduleDetail();
            context.Schedule = schedule;

            context.SaveEvent += async (s) =>
            {
                var msg_result = MessageBox.Show($"해당 일정을 저장 하시겠습니까?\n{s.StartEnd} - {s.Title}", "일정 저장", MessageBoxButton.YesNo, MessageBoxImage.Question);
                if (msg_result != MessageBoxResult.Yes)
                {
                    return;
                }

                await UiAction.Instance.ExecuteAsync(async () =>
                {
                    // 일정 등록
                    var req = new
                    {
                        id          = s.Id,
                        employee_id = GD.Instance.LoginUser.Id,
                        title       = s.Title,
                        start_at    = s.Start_At.ToString("yyyy-MM-dd"),
                        end_at      = s.End_At.ToString("yyyy-MM-dd"),
                        color_code  = s.Color_Code
                    };

                    if (s.Id == 0)
                    {
                        M_DB_Result db_result = await HTTP_Server.API.HttpSendAsync<M_DB_Result>("/schedule/insert", HTTP_Server.Method.POST, req);
                        if (db_result != null && db_result.InsertId > 0)
                        {
                            // 성공
                            MessageBox.Show("일정 저장 성공", "일정 저장", MessageBoxButton.OK, MessageBoxImage.Information);
                            win.Close();
                        }
                        else
                        {
                            // 실패
                            MessageBox.Show("일정 저장 실패", "일정 저장", MessageBoxButton.OK, MessageBoxImage.Error);
                        }
                    }
                    else
                    {
                        M_DB_Result db_result = await HTTP_Server.API.HttpSendAsync<M_DB_Result>("/schedule/update", HTTP_Server.Method.PUT, req);
                        if (db_result != null && db_result.AffectedRows > 0)
                        {
                            // 성공
                            MessageBox.Show("일정 저장 성공", "일정 저장", MessageBoxButton.OK, MessageBoxImage.Information);
                            win.Close();
                        }
                        else
                        {
                            // 실패
                            MessageBox.Show("일정 저장 실패", "일정 저장", MessageBoxButton.OK, MessageBoxImage.Error);
                        }
                    }
                });

                // await this.ScheduleLoad(this.DisplayDate); // 일정 저장
                Console.WriteLine("SaveEvent 호출");
                this.DisplayDate = s.Start_At;
            };

            context.DeleteEvent += async (s) =>
            {
                var msg_result = MessageBox.Show($"해당 일정을 삭제 하시겠습니까?\n{s.StartEnd} - {s.Title}", "일정 삭제", MessageBoxButton.YesNo, MessageBoxImage.Warning);
                if (msg_result != MessageBoxResult.Yes)
                {
                    return;
                }

                await UiAction.Instance.ExecuteAsync(async () =>
                {
                    var req = new { id = s.Id };
                    var db_result = await HTTP_Server.API.HttpSendAsync<M_DB_Result>("/schedule/delete", HTTP_Server.Method.DELETE, req);
                    if (db_result != null && db_result.AffectedRows > 0)
                    {
                        // 성공
                        // MessageBox.Show("일정 삭제 성공");
                        win.Close();
                    }
                    else
                    {
                        // 실패
                        MessageBox.Show("일정 삭제 실패", "일정 삭제", MessageBoxButton.OK, MessageBoxImage.Error);
                    }
                });

                // await this.ScheduleLoad(this.DisplayDate); // 일정 삭제
                Console.WriteLine("DeleteEvent 호출");
                this.DisplayDate = s.Start_At;
            };

            win.DataContext = context;
            win.ShowDialog();
        }

        private async Task BtnToDay()
        {
            this.DisplayDate = DateTime.Now;
        }

        private DateTime displayDate;
        public DateTime DisplayDate
        {
            get => this.displayDate;
            set
            {
                base.OnPropertyChanged(ref this.displayDate, value);
                if (this.DisplayMode == CalendarMode.Month)
                {
                    Console.WriteLine("DisplayDate 프로퍼티 호출");
                    _ = this.ScheduleLoad(this.DisplayDate); // DisplayDate
                }
            }
        }

        private CalendarMode displayMode;
        public CalendarMode DisplayMode
        {
            get => this.displayMode;
            set
            {
                base.OnPropertyChanged(ref this.displayMode, value);
                if (this.DisplayMode == CalendarMode.Month)
                {
                    Console.WriteLine("DisplayMode 프로퍼티 호출");
                    this.DisplayDate = this.DisplayDate;
                }
            }
        }
    }
}
