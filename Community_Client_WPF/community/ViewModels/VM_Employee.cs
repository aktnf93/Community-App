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
        public ObservableCollection<M_TeamTree> TeamTreeList { get; set; }
            = new ObservableCollection<M_TeamTree>();

        public M_TeamTree TeamTreeSelected { get; set; }

        private bool chkListView;
        private bool chkAtteendanceView;
        private bool chkScheduleView;
        private bool chkLeaveView;
        private bool chkReviewView;
        public bool ChkListView
        {
            get => this.chkListView;
            set => base.OnPropertyChanged(ref this.chkListView, value);
        }
        public bool ChkAtteendanceView
        {
            get => this.chkAtteendanceView;
            set => base.OnPropertyChanged(ref this.chkAtteendanceView, value);
        }
        public bool ChkScheduleView
        {
            get => this.chkScheduleView;
            set => base.OnPropertyChanged(ref this.chkScheduleView, value);
        }
        public bool ChkLeaveView
        {
            get => this.chkLeaveView;
            set => base.OnPropertyChanged(ref this.chkLeaveView, value);
        }
        public bool ChkReviewView
        {
            get => this.chkReviewView;
            set => base.OnPropertyChanged(ref this.chkReviewView, value);
        }


        public ObservableCollection<M_Employee> EmployeeList { get; set; }
            = new ObservableCollection<M_Employee>();

        private M_Employee employeeSelected;
        public M_Employee EmployeeSelected
        {
            get => this.employeeSelected;
            set
            {
                var copy = Utility.DeepCopy<M_Employee>(value);
                this.employeeSelected = copy;

                base.OnPropertyChanged(nameof(employeeSelected));
            }
        }

        private void Loaded()
        {
            Console.WriteLine("VM_Employee Loaded");

            ChkListView = true;

            LoadTeam();

            var employeeList = HTTP_Server.API.HttpSend<M_Employee[]>("/employee/list/select");
            this.EmployeeList.Clear();

            if (employeeList != null)
            {
                foreach (var e in employeeList)
                {
                    e.OnEmployeeSelect += (select) =>
                    {
                        this.EmployeeSelected = select;
                    };
                    this.EmployeeList.Add(e);
                }
            }
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

                item.OnSelected += (t) =>
                {
                    var employeeList = HTTP_Server.API.HttpSend<M_Employee[]>("/employee/list/select");
                    this.EmployeeList.Clear();

                    if (employeeList != null)
                    {
                        foreach (var e in employeeList)
                        {
                            e.OnEmployeeSelect += (select) =>
                            {
                                this.EmployeeSelected = select;
                            };
                            this.EmployeeList.Add(e);
                        }
                    }
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
