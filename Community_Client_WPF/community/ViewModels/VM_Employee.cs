using community.Common;
using community.Models;
using System;
using System.Collections.Generic;
using System.Collections.ObjectModel;
using System.ComponentModel;
using System.Linq;
using System.Text;
using System.Threading;
using System.Threading.Tasks;
using System.Windows;
using System.Windows.Controls;
using System.Windows.Data;
using System.Windows.Documents;

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

        // "재직", "휴가", "정직", "퇴직", "대기", "계약해지"
        private bool chkSearchAll;
        private bool chkSearchIn;
        private bool chkSearchLeave;
        private bool chkSearchStop;
        private bool chkSearchOut;
        private bool chkSearchWate;
        private bool chkSearchOutContract;

        /// <summary>
        /// 필터: 전체
        /// </summary>
        public bool ChkSearchAll
        {
            get => this.chkSearchAll;
            set
            {
                if (!this.ChkSearchIn && !this.ChkSearchLeave && !this.ChkSearchStop && 
                    !this.ChkSearchOut && !this.ChkSearchWate && !this.ChkSearchOutContract)
                {
                    value = true;
                }

                base.OnPropertyChanged(ref this.chkSearchAll, value);
                if (value)
                {
                    this.chkSearchIn           = false;
                    this.chkSearchLeave        = false;
                    this.chkSearchStop         = false;
                    this.chkSearchOut          = false;
                    this.chkSearchWate         = false;
                    this.chkSearchOutContract  = false;
                    base.OnPropertyChanged("ChkSearchIn");
                    base.OnPropertyChanged("ChkSearchLeave");
                    base.OnPropertyChanged("ChkSearchStop");
                    base.OnPropertyChanged("ChkSearchOut");
                    base.OnPropertyChanged("ChkSearchWate");
                    base.OnPropertyChanged("ChkSearchOutContract");

                    this.EmployeeView.Refresh();
                }
                else
                {
                    this.EmployeeView.Refresh();
                }
            }
        }

        /// <summary>
        /// 필터: 재직
        /// </summary>
        public bool ChkSearchIn
        {
            get => this.chkSearchIn;
            set
            {
                base.OnPropertyChanged(ref this.chkSearchIn, value);
                this.ChkSearchAll = false;
            }
        }

        /// <summary>
        /// 필터: 휴가
        /// </summary>
        public bool ChkSearchLeave
        {
            get => this.chkSearchLeave;
            set
            {
                base.OnPropertyChanged(ref this.chkSearchLeave, value);
                this.ChkSearchAll = false;
            }
        }

        /// <summary>
        /// 필터: 정직
        /// </summary>
        public bool ChkSearchStop
        {
            get => this.chkSearchStop;
            set
            {
                base.OnPropertyChanged(ref this.chkSearchStop, value);
                this.ChkSearchAll = false;
            }
        }

        /// <summary>
        /// 필터: 퇴직
        /// </summary>
        public bool ChkSearchOut
        {
            get => this.chkSearchOut;
            set
            {
                base.OnPropertyChanged(ref this.chkSearchOut, value);
                this.ChkSearchAll = false;
            }
        }

        /// <summary>
        /// 필터: 대기
        /// </summary>
        public bool ChkSearchWate
        {
            get => this.chkSearchWate;
            set
            {
                base.OnPropertyChanged(ref this.chkSearchWate, value);
                this.ChkSearchAll = false;
            }
        }

        /// <summary>
        /// 필터: 계약종료 
        /// </summary>
        public bool ChkSearchOutContract
        {
            get => this.chkSearchOutContract;
            set
            {
                base.OnPropertyChanged(ref this.chkSearchOutContract, value);
                this.ChkSearchAll = false;
            }
        }

        public ObservableCollection<string> CboSearchType { get; set; }
            = new ObservableCollection<string>()
            {
                "ID", "사원번호", "이름"
            };

        private string cboSearchTypeSelected = "ID";
        public string CboSearchTypeSelected
        {
            get => this.cboSearchTypeSelected;
            set => base.OnPropertyChanged(ref this.cboSearchTypeSelected, value);
        }

        private string txtSearchValue;
        public string TxtSearchValue
        {
            get => this.txtSearchValue;
            set => base.OnPropertyChanged(ref this.txtSearchValue, value);
        }

        // 성별
        public ObservableCollection<string> E_GanderList { get; set; }
            = new ObservableCollection<string>()
            {
                "남", "여", "기타"
            };
        // 회사
        public ObservableCollection<M_Organization_Company> E_CompanyList { get; set; }
            = new ObservableCollection<M_Organization_Company>();
        // 부서
        public ObservableCollection<M_Organization_Department> E_DepartmentList { get; set; }
            = new ObservableCollection<M_Organization_Department>();
        // 팀
        public ObservableCollection<M_Organization_Team> E_TeamList { get; set; }
            = new ObservableCollection<M_Organization_Team>();
        // 직급
        public ObservableCollection<M_Organization_Rank> E_RankList { get; set; }
            = new ObservableCollection<M_Organization_Rank>();
        // 직책
        public ObservableCollection<M_Organization_Position> E_PositionList { get; set; }
            = new ObservableCollection<M_Organization_Position>();
        // 담당
        public ObservableCollection<M_Organization_Role> E_RoleList { get; set; }
            = new ObservableCollection<M_Organization_Role>();
        // 권한
        public ObservableCollection<M_Organization_Privilege> E_PrivilegesList { get; set; }
            = new ObservableCollection<M_Organization_Privilege>();
        // 상태
        public ObservableCollection<string> E_StatusList { get; set; }
            = new ObservableCollection<string>()
            {
                "재직", "휴가", "정직", "퇴직", "대기", "계약해지"
            };
        // 계약유형
        public ObservableCollection<string> E_ContractTypeList { get; set; }
            = new ObservableCollection<string>()
            {
                "정규직", "계약직", "인턴", "무기계약직", "파트타임", "파견직", "아르바이트", "프리랜서", "외주"
            };
        // 계정상태
        public ObservableCollection<string> E_AccountStatusList { get; set; }
            = new ObservableCollection<string>()
            {
                "Y", "N"
            };

        public ObservableCollection<M_Employee> EmployeeList { get; set; }
            = new ObservableCollection<M_Employee>();

        private M_Employee employeeSelected;
        public M_Employee EmployeeSelected
        {
            get => this.employeeSelected;
            set
            {
                var copy = Utility.DeepCopy<M_Employee>(value);
                copy.Login_Pw_Check = copy.Login_Pw;
                this.employeeSelected = copy;

                base.OnPropertyChanged(nameof(employeeSelected));
            }
        }

        public ICollectionView EmployeeView { get; set; }


        private async void Loaded()
        {
            Console.WriteLine("VM_Employee Loaded");

            this.EmployeeView = CollectionViewSource.GetDefaultView(EmployeeList);
            this.EmployeeView.Filter = (e) =>
            {
                var result = false;
                var employee = e as M_Employee;

                if (employee == null)
                    return false;

                if (this.ChkSearchAll)
                {
                    // 전체 검색
                    result = true;
                }
                else
                {
                    if (this.ChkSearchIn && employee.Status == "재직")
                        result = true;

                    if (this.ChkSearchLeave && employee.Status == "휴가")
                        result = true;

                    if (this.ChkSearchStop && employee.Status == "정직")
                        result = true;

                    if (this.ChkSearchOut && employee.Status == "퇴직")
                        result = true;

                    if (this.ChkSearchWate && employee.Status == "대기")
                        result = true;

                    if (this.ChkSearchOutContract && employee.Status == "계약종료")
                        result = true;
                }

                return result;
            };
            this.EmployeeView.Refresh();

            this.ChkListView = true;
            this.ChkSearchAll = true;

            this.E_CompanyList      = new ObservableCollection<M_Organization_Company>(GD.Instance.Companies);
            this.E_RankList         = new ObservableCollection<M_Organization_Rank>(GD.Instance.Ranks);
            this.E_PositionList     = new ObservableCollection<M_Organization_Position>(GD.Instance.Positions);
            this.E_RoleList         = new ObservableCollection<M_Organization_Role>(GD.Instance.Roles);
            this.E_PrivilegesList   = new ObservableCollection<M_Organization_Privilege>(GD.Instance.Privileges);

            base.OnPropertyChanged(nameof(this.E_CompanyList));
            base.OnPropertyChanged(nameof(this.E_RankList));
            base.OnPropertyChanged(nameof(this.E_PositionList));
            base.OnPropertyChanged(nameof(this.E_RoleList));
            base.OnPropertyChanged(nameof(this.E_PrivilegesList));

            LoadCategory(); // 소속 카테고리
        }

        private async void LoadCategory()
        {
            await UiAction.Instance.ExecuteAsync(async () =>
            {
                var teams = await HTTP_Server.API.HttpSendAsync<M_TeamTree[]>("/organization/team/tree", HTTP_Server.Method.POST, null);
                this.TeamTreeList.Clear();
                if (teams != null)
                {
                    this.TeamTreeList = new ObservableCollection<M_TeamTree>(BuildTree(teams));
                    base.OnPropertyChanged(nameof(this.TeamTreeList));
                }
            });

            if (this.TeamTreeList.Count > 0)
            {
                this.TeamTreeSelected = this.TeamTreeList[0];
                this.TeamTreeList[0].IsSelected = true;
            }
        }

        private List<M_TeamTree> BuildTree(M_TeamTree[] flatList)
        {
            var rootList = new List<M_TeamTree>();
            var lookup = flatList.ToDictionary(c => c.Id);

            foreach (var tree in flatList)
            {
                if (tree.Depth == 0 || tree.Depth == 1)
                    tree.IsExpanded = true;

                tree.OnSelected += async (t) =>
                {
                    this.TeamTreeSelected = t;

                    await UiAction.Instance.ExecuteAsync(async () =>
                    {
                        this.EmployeeList.Clear();
                        this.EmployeeSelected = new M_Employee();

                        object req = null;
                        if (t.Depth == 1) req = new { company_id    = t.Origin_Id };
                        if (t.Depth == 2) req = new { department_id = t.Origin_Id };
                        if (t.Depth == 3) req = new { team_id       = t.Origin_Id };

                        var employeeList = await HTTP_Server.API.HttpSendAsync<M_Employee[]>("/employee/list/select", HTTP_Server.Method.POST, req);
                        if (employeeList != null)
                        {
                            foreach (var e in employeeList)
                            {
                                e.OnEmployeeSelect += (select) =>
                                {
                                    this.EmployeeSelected = select; // 리스트에서 선택 시, 편집 패널로 복사.
                                };

                                this.EmployeeList.Add(e);
                            }
                        }

                        this.EmployeeView.Refresh();
                    });
                };

                if (tree.Parent_Id == null)
                {
                    // 최상위 노드 (회사)
                    rootList.Add(tree);
                }
                else if (lookup.TryGetValue(tree.Parent_Id.Value, out var parent))
                {
                    // 부모 노드의 SubTree에 추가 (부서 → 팀)
                    parent.SubTree.Add(tree);
                }
            }

            return rootList;
        }

        private async void CboGroupSelected(object sender, RoutedEventArgs e)
        {
            var cbo = sender as ComboBox;
            if (cbo is null)
            {
                // 직원 편집 객체가 변경됨.
                return;
            }

            if (!int.TryParse(Convert.ToString(cbo.SelectedValue), out int selected_id))
            {
                // SelectedValue가 사라짐.
                return;
            }

            switch (cbo.Uid)
            {
                case "Company":
                    {
                        var d = GD.Instance.Departments.Where(x => x.Company_Id == selected_id).ToList();
                        this.E_DepartmentList = new ObservableCollection<M_Organization_Department>(d);
                        base.OnPropertyChanged(nameof(this.E_DepartmentList));
                    }
                    break;

                case "Department":
                    {
                        var t = GD.Instance.Teams.Where(x => x.Department_Id == selected_id).ToList();
                        this.E_TeamList = new ObservableCollection<M_Organization_Team>(t);
                        base.OnPropertyChanged(nameof(this.E_TeamList));
                    }
                    break;

                case "Team":
                default:
                    // MessageBox.Show("소속정보 선택 에러가 발생했습니다.", "직원 관리", MessageBoxButton.OK, MessageBoxImage.Error);
                    break;
            }
        }


        private async void BtnEmployeeSearch()
        {
            await UiAction.Instance.ExecuteAsync(async () =>
            {
                var tree = this.TeamTreeSelected;
                var selected = this.CboSearchTypeSelected;
                var txtValue = this.TxtSearchValue;
                var employees = new M_Employee[0];
                var req = new Dictionary<string, object>();

                if (tree != null)
                {
                    if (tree.Depth == 1) req.Add("company_id", tree.Origin_Id);
                    if (tree.Depth == 2) req.Add("department_id", tree.Origin_Id);
                    if (tree.Depth == 3) req.Add("team_id", tree.Origin_Id);
                }

                if (string.IsNullOrEmpty(selected))
                {
                    // 전체 검색
                    employees = await HTTP_Server.API.HttpSendAsync<M_Employee[]>("/employee/list/select", HTTP_Server.Method.POST, null);
                }
                else
                {
                    if (selected == "ID")
                        req.Add("id", txtValue);
                    if (selected == "사원번호")
                        req.Add("employee_code", txtValue);
                    if (selected == "이름")
                        req.Add("name", txtValue);

                    employees = await HTTP_Server.API.HttpSendAsync<M_Employee[]>("/employee/list/select", HTTP_Server.Method.POST, req);
                }

                this.EmployeeList.Clear();
                foreach (var e in employees)
                {
                    e.OnEmployeeSelect += (select) =>
                    {
                        this.EmployeeSelected = select; // 리스트에서 선택 시, 편집 패널로 복사.
                    };

                    this.EmployeeList.Add(e);
                }

                this.EmployeeView.Refresh();
            });
        }

        private async void BtnEmployeeNewEdit()
        {
            await UiAction.Instance.ExecuteAsync(async () =>
            {
                var result = MessageBox.Show(
                    "새로 입력 하시겠습니까?\n(작성 중이던 내용이 지워집니다)", 
                    "새로 입력하기 (신규 직원)", 
                    MessageBoxButton.YesNoCancel, MessageBoxImage.Question);

                if (result == MessageBoxResult.Yes)
                {
                    this.EmployeeSelected = new M_Employee();
                }
            });
        }

        private async void BtnEmployeeSave()
        {
            bool isReload = false;

            await UiAction.Instance.ExecuteAsync(async () =>
            {
                MessageBoxResult result = MessageBoxResult.None;
                M_Employee e = this.EmployeeSelected;

                // 직원 편집 정보가 없음.
                if (e is null)
                {
                    MessageBox.Show(
                        "입력된 직원 정보가 없습니다.",
                        "직원 정보 저장",
                        MessageBoxButton.OK, MessageBoxImage.Information);
                    return;
                }

                // 비밀번호와 비밀번호 확인이 맞지 않음.
                if (e.Login_Pw != e.Login_Pw_Check)
                {
                    result = MessageBox.Show(
                        "입력된 로그인 비밀번호가 맞지 않습니다\n비밀번호를 공백으로 두시겠습니까?\n비밀번호가 공백이면 로그인 할 수 없습니다.",
                        "직원 정보 저장",
                        MessageBoxButton.YesNoCancel, MessageBoxImage.Question);

                    if (result == MessageBoxResult.Yes)
                    {
                        e.Login_Pw = "";
                        e.Login_Pw_Check = "";
                    }
                    else
                    {
                        return;
                    }
                }

                // 신규 등록인지 기존 직원 편집인지?
                if (e.Id == 0)
                {
                    // 신규 등록
                    result = MessageBox.Show(
                        "이대로 신규 직원을 추가 하시겠습니까?",
                        "직원 정보 저장",
                        MessageBoxButton.YesNoCancel, MessageBoxImage.Question);

                    if (result == MessageBoxResult.Yes)
                    {
                        var db_result = await HTTP_Server.API.HttpSendAsync<M_DB_Result>("/employee/list/insert", HTTP_Server.Method.POST, e);
                        if (db_result is null)
                        {
                            // 서버 통신 에러
                            MessageBox.Show(
                                "신규 직원을 추가하지 못했습니다.", 
                                "직원 정보 저장",
                                MessageBoxButton.OK, MessageBoxImage.Error);
                            return;
                        }

                        if (db_result.InsertId < 1)
                        {
                            // DB에 등록되지 않음.
                            MessageBox.Show(
                                "신규 직원을 추가하지 못했습니다.",
                                "직원 정보 저장",
                                MessageBoxButton.OK, MessageBoxImage.Error);
                            return;
                        }

                        // 성공
                        isReload = true;
                    }
                }
                else
                {
                    // 기존 직원 편집
                    result = MessageBox.Show(
                        "이대로 기존 직원 정보를 변경 하시겠습니까?",
                        "직원 정보 저장",
                        MessageBoxButton.YesNoCancel, MessageBoxImage.Question);

                    if (result == MessageBoxResult.Yes)
                    {
                        var db_result = await HTTP_Server.API.HttpSendAsync<M_DB_Result>("/employee/list/update", HTTP_Server.Method.PUT, e);
                        if (db_result is null)
                        {
                            // 서버 통신 에러
                            MessageBox.Show(
                                "기존 직원 정보를 변경 하지 못했습니다.",
                                "직원 정보 저장",
                                MessageBoxButton.OK, MessageBoxImage.Error);
                            return;
                        }

                        if (db_result.AffectedRows < 1)
                        {
                            // DB에 등록되지 않음.
                            MessageBox.Show(
                                "기존 직원 정보를 변경 하지 못했습니다.",
                                "직원 정보 저장",
                                MessageBoxButton.OK, MessageBoxImage.Error);
                            return;
                        }

                        // 성공
                        isReload = true;
                    }
                }
            });

            if (isReload)
            {
                if (this.TeamTreeList.Count > 0)
                {
                    this.TeamTreeSelected = this.TeamTreeList[0];
                    this.TeamTreeList[0].IsSelected = true;
                }
            }
        }

        private async void BtnEmployeeDelete()
        {
            await UiAction.Instance.ExecuteAsync(async () =>
            {
                M_Employee e = this.EmployeeSelected;

                if (e is null)
                {
                    MessageBox.Show(
                        "삭제할 직원 정보가 선택되지 않았습니다.",
                        "직원 정보 삭제",
                        MessageBoxButton.OK, MessageBoxImage.Error);

                    return;
                }

                if (e.Id == 0)
                {
                    MessageBox.Show(
                        "삭제할 직원 정보가 선택되지 않았습니다.",
                        "직원 정보 삭제",
                        MessageBoxButton.OK, MessageBoxImage.Error);

                    return;
                }

                var result = MessageBox.Show(
                    "직원 정보를 삭제 하시겠습니까?\n*주의 복원되지 않습니다.",
                    "직원 정보 삭제", 
                    MessageBoxButton.YesNoCancel, MessageBoxImage.Warning);

                if (result == MessageBoxResult.Yes)
                {
                    var req = new { id = e.Id };
                    var db_result = await HTTP_Server.API.HttpSendAsync<M_DB_Result>("/employee/list/delete", HTTP_Server.Method.DELETE, req);
                    if (db_result is null)
                    {
                        return;
                    }

                    if (db_result.AffectedRows > 0)
                    {
                        return;
                    }

                    // 성공
                }
            });

            if (this.TeamTreeList.Count > 0)
            {
                this.TeamTreeSelected = this.TeamTreeList[0];
                this.TeamTreeList[0].IsSelected = true;
            }
        }
    }
}
