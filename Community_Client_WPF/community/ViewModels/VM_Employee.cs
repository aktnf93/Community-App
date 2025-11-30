using community.Common;
using community.Models;
using System;
using System.Collections.Generic;
using System.Collections.ObjectModel;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace community.ViewModels
{
    public class VM_Employee : ViewModelBase
    {
        public M_Card BannerCard { get; set; } = new M_Card()
        {
            Title = "직원관리"
        };

        public M_Card[] DashboardCard { get; set; } =
        {
            new M_Card() { Title = "총 직원", Content = "", Description = "" },
            new M_Card() { Title = "출근", Content = "", Description = "" },
            new M_Card() { Title = "퇴근", Content = "", Description = "" },
            new M_Card() { Title = "휴가", Content = "", Description = "" },
            new M_Card() { Title = "외주", Content = "", Description = "" },
        };

        public ObservableCollection<M_TeamTree> TeamTreeList { get; set; }
            = new ObservableCollection<M_TeamTree>();

        public M_TeamTree TeamTreeSelected { get; set; }

        public ObservableCollection<M_Employee> EmployeeList { get; set; }
            = new ObservableCollection<M_Employee>();

        private void Loaded()
        {
            Console.WriteLine("VM_Employee Loaded");

            var teams = HTTP_Server.API.HttpSend<M_TeamTree[]>("/organization/team/tree");
            this.TeamTreeList.Clear();
            if (teams != null)
            {
                this.TeamTreeList = new ObservableCollection<M_TeamTree>(BuildTree(teams));
                base.OnPropertyChanged(nameof(this.TeamTreeList));
            }
        }

        public List<M_TeamTree> BuildTree(M_TeamTree[] flatList)
        {
            var rootList = new List<M_TeamTree>();
            var lookup = flatList.ToDictionary(c => c.Id);

            foreach (var item in flatList)
            {
                item.OnSelected += (t) =>
                {
                    var employeeList = HTTP_Server.API.HttpSend<M_Employee[]>("/employee/list/select");
                    this.EmployeeList = new ObservableCollection<M_Employee>(employeeList);
                    base.OnPropertyChanged(nameof(this.EmployeeList));
                };

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
    }
}
