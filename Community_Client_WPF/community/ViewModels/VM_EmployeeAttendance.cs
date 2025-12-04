using community.Common;
using community.Models;
using System;
using System.Collections.Generic;
using System.Collections.ObjectModel;
using System.Data;
using System.Linq;
using System.Runtime.Serialization;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Documents;
using System.Xml.Schema;

namespace community.ViewModels
{
    public class VM_EmployeeAttendance : ViewModelBase
    {
        public M_Card[] Cards { get; set; } =
        {
            new M_Card(), 
            new M_Card(), 
            new M_Card(),
            new M_Card()
        };

        public ObservableCollection<M_TeamTree> TeamTreeList { get; set; }
            = new ObservableCollection<M_TeamTree>();

        public M_TeamTree TeamTreeSelected { get; set; }

        public ObservableCollection<M_Employee_Attendance> AttendanceList { get; set; }
            = new ObservableCollection<M_Employee_Attendance>();

        private DateTime attendanceToDay;
        public DateTime AttendanceToDay
        {
            get => this.attendanceToDay;
            set
            {
                base.OnPropertyChanged(ref this.attendanceToDay, value);

                // 근태 집계 불러오기
                // LoadAttendanceTotal("date", "y", this.attendanceToDay);

                // 근태 목록 불러오기
                LoadAttendanceList("date", "n", this.attendanceToDay);
            }
        }

        private void Loaded()
        {
            // 오늘 날짜로 갱신
            this.AttendanceToDay = DateTime.Now;

            // 소속 불러오기
            LoadTeam();
        }

        private void LoadAttendanceTotal(string select_type, string select_total, DateTime date)
        {
            var req = new { select_type, select_total, date };
            var result = HTTP_Server.API.HttpSend<DataTable>("/employee/attendance/select", HTTP_Server.Method.POST, req);
            if (result != null)
            {
                Cards[0].Content = string.Format("{0}", result.Rows[0]["total"]);
                Cards[1].Content = string.Format("{0}", result.Rows[0]["check_in"]);
                Cards[2].Content = string.Format("{0}", result.Rows[0]["check_out"]);
            }
        }

        private void LoadAttendanceList(string select_type, string select_total, DateTime date)
        {
            var req = new { select_type, select_total, date };
            var result = HTTP_Server.API.HttpSend<M_Employee_Attendance[]>("/employee/attendance/select", HTTP_Server.Method.POST, req);
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

        private void LoadTeam()
        {
            var teams = HTTP_Server.API.HttpSend<M_TeamTree[]>("/organization/team/tree");
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
                if (item.Depth == 0)
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

        private void BtnToDayDown()
        {
            if (this.AttendanceToDay != null)
            {
                this.AttendanceToDay = this.AttendanceToDay.AddDays(-1);
            }
        }

        private void BtnToDayUp()
        {
            if (this.AttendanceToDay != null)
            {
                this.AttendanceToDay = this.AttendanceToDay.AddDays(+1);
            }
        }
    }
}
