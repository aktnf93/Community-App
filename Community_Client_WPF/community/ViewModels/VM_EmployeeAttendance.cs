using System;
using System.Collections.Generic;
using System.Collections.ObjectModel;
using System.Linq;
using System.Threading.Tasks;
using community.Common;
using community.Models;

namespace community.ViewModels
{
    public class VM_EmployeeAttendance : ViewModelBase
    {
        public M_Card[] Cards { get; set; } = { new M_Card(), new M_Card(), new M_Card(), new M_Card() };

        public ObservableCollection<M_TeamTree> TeamTreeList { get; set; } = new ObservableCollection<M_TeamTree>();

        public M_TeamTree TeamTreeSelected { get; set; }

        public ObservableCollection<M_Employee_Attendance> AttendanceList { get; set; } = new ObservableCollection<M_Employee_Attendance>();

        private DateTime attendanceToDay;
        public DateTime AttendanceToDay
        {
            get => this.attendanceToDay;
            set => base.OnPropertyChanged(ref this.attendanceToDay, value);
        }

        private async Task Loaded()
        {
            // 오늘 날짜로 갱신
            this.AttendanceToDay = DateTime.Now;
            await LoadAttendanceList();

            // 소속 불러오기
            await LoadTeam();
        }

        private async Task LoadAttendanceList()
        {
            var req = new { select_type = "day_time", date = this.AttendanceToDay.ToString("yyyy-MM-dd") };
            var result = await HTTP_Server.API.HttpSendAsync<M_Employee_Attendance[]>("/employee/attendance/select", HTTP_Server.Method.POST, req);
            this.AttendanceList.Clear();

            int totalCount = 0;
            int inCount = 0;
            int outCount = 0;

            if (result != null)
            {
                totalCount = result.Length;


                foreach (var r in result)
                {
                    r.SelectedDate = this.AttendanceToDay;

                    if (r.Status == "정상근무")
                        inCount++;
                    else
                        outCount++;

                    this.AttendanceList.Add(r);
                }
            }

            Cards[0].Content = totalCount.ToString();
            Cards[1].Content = inCount.ToString();
            Cards[2].Content = outCount.ToString();
            Cards[3].Content = 0.ToString();
        }

        private async Task LoadTeam()
        {
            var teams = await HTTP_Server.API.HttpSendAsync<M_TeamTree[]>("/organization/team/tree", HTTP_Server.Method.POST, null);
            this.TeamTreeList.Clear();
            if (teams != null)
            {
                this.TeamTreeList = new ObservableCollection<M_TeamTree>(BuildTree(teams));
                base.OnPropertyChanged(nameof(this.TeamTreeList));

                if (this.TeamTreeList.Count > 0)
                {
                    this.TeamTreeSelected = this.TeamTreeList[0];
                    this.TeamTreeList[0].IsSelected = true;
                }
            }
        }

        private List<M_TeamTree> BuildTree(M_TeamTree[] flatList)
        {
            var rootList = new List<M_TeamTree>();
            var lookup = flatList.ToDictionary(c => c.Id);

            foreach (var item in flatList)
            {
                if (item.Depth == 0 || item.Depth == 1)
                    item.IsExpanded = true;

                if (item.Parent_Id == null)
                {
                    // 최상위 노드 (회사)
                    rootList.Add(item);
                }
                else if (lookup.TryGetValue(item.Parent_Id.Value, out var parent))
                {
                    // 부모 노드의 SubTree에 추가 (부서 → 팀)
                    parent.SubTree.Add(item);
                }
            }

            return rootList;
        }

        private async Task BtnToDayDown()
        {
            await UiAction.Instance.ExecuteAsync(async () =>
            {
                if (this.AttendanceToDay != null)
                {
                    this.AttendanceToDay = this.AttendanceToDay.AddDays(-1);
                    await LoadAttendanceList();
                }
            });
        }

        private async Task BtnToDayUp()
        {
            await UiAction.Instance.ExecuteAsync(async () =>
            {
                if (this.AttendanceToDay != null)
                {
                    this.AttendanceToDay = this.AttendanceToDay.AddDays(+1);
                    await LoadAttendanceList();
                }
            });
        }
    }
}
