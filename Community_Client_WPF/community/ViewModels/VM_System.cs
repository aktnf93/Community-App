using community.Common;
using community.Models;
using Mysqlx.Session;
using MySqlX.XDevAPI.Common;
using System;
using System.Collections.Generic;
using System.Collections.ObjectModel;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows;
using System.Windows.Controls;

namespace community.ViewModels
{
    public class VM_System : ViewModelBase
    {
        public M_Card BannerCard { get; set; } = new M_Card()
        {
            Title = "환경설정"
        };

        public M_Card[] DashboardCard { get; set; } =
        {
            new M_Card() { Title = "게시판", Content = "", Description = "2025-11-13 20:29" },
            new M_Card() { Title = "채팅방", Content = "", Description = "2025-11-13 20:29" },
            new M_Card() { Title = "프로젝트", Content = "", Description = "2025-11-13 20:29" },
            new M_Card() { Title = "고객사", Content = "", Description = "2025-11-13 20:29" },
            new M_Card() { Title = "재고", Content = "", Description = "2025-11-13 20:29" },
        };

        public ObservableCollection<M_System_Config> SystemConfigs { get; set; } = new ObservableCollection<M_System_Config>();
        public ObservableCollection<M_Organization_Company> CompanyList { get; set; } = new ObservableCollection<M_Organization_Company>();
        public ObservableCollection<M_Organization_Department> DepartmentList { get; set; } = new ObservableCollection<M_Organization_Department>();
        public ObservableCollection<M_Organization_Team> TeamList { get; set; } = new ObservableCollection<M_Organization_Team>();
        public ObservableCollection<M_Organization_Rank> RankList { get; set; } = new ObservableCollection<M_Organization_Rank>();
        public ObservableCollection<M_Organization_Position> PositionList { get; set; } = new ObservableCollection<M_Organization_Position>();
        public ObservableCollection<M_Organization_Role> RoleList { get; set; } = new ObservableCollection<M_Organization_Role>();

        private M_Organization_Company _CompanySelected = new M_Organization_Company();
        public M_Organization_Company CompanySelected
        {
            get => this._CompanySelected;
            set
            {
                this._CompanySelected = new M_Organization_Company();

                if (value != null)
                {
                    this._CompanySelected.Id = value.Id;
                    this._CompanySelected.Name = value.Name;
                    this._CompanySelected.Description = value.Description;

                    DepartmentSearch();
                }
                
                base.OnPropertyChanged(nameof(CompanySelected));
            }
        }

        private M_Organization_Department _DepartmentSelected = new M_Organization_Department();
        public M_Organization_Department DepartmentSelected
        {
            get => this._DepartmentSelected;
            set
            {
                this._DepartmentSelected = new M_Organization_Department();

                if (value != null)
                {
                    this._DepartmentSelected.Id = value.Id;
                    this._DepartmentSelected.Name = value.Name;
                    this._DepartmentSelected.Description = value.Description;
                    this._DepartmentSelected.Company_Id = value.Company_Id;

                    TeamSearch();
                }
                
                base.OnPropertyChanged(nameof(DepartmentSelected));
            }
        }

        private M_Organization_Team _TeamSelected = new M_Organization_Team();
        public M_Organization_Team TeamSelected
        {
            get => this._TeamSelected;
            set
            {
                this._TeamSelected = new M_Organization_Team();

                if (value != null)
                {
                    this._TeamSelected.Id = value.Id;
                    this._TeamSelected.Name = value.Name;
                    this._TeamSelected.Description = value.Description;
                    this._TeamSelected.Department_Id = value.Department_Id;
                }

                base.OnPropertyChanged(nameof(TeamSelected));
            }
        }
        
        private M_Organization_Rank _RankSelected = new M_Organization_Rank();
        public M_Organization_Rank RankSelected
        {
            get => this._RankSelected;
            set
            {
                this._RankSelected = new M_Organization_Rank();

                if (value != null)
                {
                    this._RankSelected.Id = value.Id;
                    this._RankSelected.Name = value.Name;
                    this._RankSelected.Description = value.Description;
                }

                base.OnPropertyChanged(nameof(RankSelected));
            }
        }
        
        private M_Organization_Position _PositioSelected = new M_Organization_Position();
        public M_Organization_Position PositioSelected
        {
            get => this._PositioSelected;
            set
            {
                this._PositioSelected = new M_Organization_Position();

                if (value != null)
                {
                    this._PositioSelected.Id = value.Id;
                    this._PositioSelected.Name = value.Name;
                    this._PositioSelected.Description = value.Description;
                }

                base.OnPropertyChanged(nameof(PositioSelected));
            }
        }
        
        private M_Organization_Role _RoleSelected = new M_Organization_Role();
        public M_Organization_Role RoleSelected
        {
            get => this._RoleSelected;
            set
            {
                this._RoleSelected = new M_Organization_Role();

                if (value != null)
                {
                    this._RoleSelected.Id = value.Id;
                    this._RoleSelected.Name = value.Name;
                    this._RoleSelected.Description = value.Description;
                }

                base.OnPropertyChanged(nameof(RoleSelected));
            }
        }

        private void Loaded()
        {
            Console.WriteLine("VM_System Loaded");

            SystemConfigSearch();
            CompanySearch();
            RankSearch();
            PositionSearch();
            RoleSearch();
        }

        private void SystemConfigSearch()
        {
            var configs = Server.API.HttpSend<M_System_Config[]>("/system/config/select");
            this.SystemConfigs.Clear();
            if (configs != null)
            {
                foreach (var c in configs)
                {
                    this.SystemConfigs.Add(c);
                }
            }
        }

        // Company
        private void CompanySearch()
        {
            var data = Server.API.HttpSend<M_Organization_Company[]>("/organization/company/select", Server.Method.POST);
            this.CompanyList.Clear();
            this.DepartmentList.Clear();
            this.TeamList.Clear();
            if (data != null)
            {
                foreach (var d in data)
                {
                    this.CompanyList.Add(d);
                }
            }
        }

        private void CompanyAdd()
        {
            var add = this.CompanySelected;
            var data = add;
            var result = Server.API.HttpSend<M_DB_Result>("/organization/company/insert", Server.Method.POST, data);
            if (result != null && result.InsertId > 0)
            {
                CompanySearch();
            }
        }

        private void CompanyEdit()
        {
            if (this.CompanySelected.Id == 0)
            {
                MessageBox.Show("수정할 회사를 선택해주세요.", "회사 수정", MessageBoxButton.OK, MessageBoxImage.Warning);
                return;
            }

            var edit = this.CompanySelected;
            var data = new { id = edit.Id, name = edit.Name, description = edit.Description };
            var result = Server.API.HttpSend<M_DB_Result>("/organization/company/update", Server.Method.PUT, data);
            if (result != null && result.AffectedRows > 0)
            {
                CompanySearch();
            }
        }

        private void CompanyDelete()
        {
            if (this.CompanySelected.Id == 0)
            {
                MessageBox.Show("삭제할 회사를 선택해주세요.", "회사 삭제", MessageBoxButton.OK, MessageBoxImage.Warning);
                return;
            }

            var del = this.CompanySelected;
            var data = new { id = del.Id };
            var result = Server.API.HttpSend<M_DB_Result>("/organization/company/delete", Server.Method.DELETE, data);
            if (result != null && result.AffectedRows > 0)
            {
                CompanySearch();
            }
        }

        // Department
        private void DepartmentSearch()
        {
            var ser = this.CompanySelected;
            var data = new { company_id = ser.Id };
            var result = Server.API.HttpSend<M_Organization_Department[]>("/organization/department/select", Server.Method.POST, data);
            this.DepartmentList.Clear();
            if (result != null)
            {
                foreach (var d in result)
                {
                    this.DepartmentList.Add(d);
                }
            }
        }
        private void DepartmentAdd()
        {
            if (this.CompanySelected.Id == 0)
            {
                MessageBox.Show("부서를 추가할 회사를 선택해주세요.", "부서 추가", MessageBoxButton.OK, MessageBoxImage.Warning);
                return;
            }

            var add = this.DepartmentSelected;
            add.Company_Id = this.CompanySelected.Id;
            var data = add;
            var result = Server.API.HttpSend<M_DB_Result>("/organization/department/insert", Server.Method.POST, data);
            if (result != null && result.InsertId > 0)
            {
                DepartmentSearch();
            }
        }
        private void DepartmentEdit()
        {
            if (this.DepartmentSelected.Id == 0)
            {
                MessageBox.Show("수정할 부서를 선택해주세요.", "부서 수정", MessageBoxButton.OK, MessageBoxImage.Warning);
                return;
            }

            var edit = this.DepartmentSelected;
            var data = new { id = edit.Id, name = edit.Name, description = edit.Description, company_id = edit.Company_Id };
            var result = Server.API.HttpSend<M_DB_Result>("/organization/department/update", Server.Method.PUT, data);
            if (result != null && result.AffectedRows > 0)
            {
                DepartmentSearch();
            }
        }
        private void DepartmentDelete()
        {
            if (this.DepartmentSelected.Id == 0)
            {
                MessageBox.Show("삭제할 부서를 선택해주세요.", "부서 삭제", MessageBoxButton.OK, MessageBoxImage.Warning);
                return;
            }

            var del = this.DepartmentSelected;
            var data = new { id = del.Id };
            var result = Server.API.HttpSend<M_DB_Result>("/organization/department/delete", Server.Method.DELETE, data);
            if (result != null && result.AffectedRows > 0)
            {
                DepartmentSearch();
            }
        }

        // Team
        private void TeamSearch()
        {
            var ser = this.DepartmentSelected;
            var data = new { department_id = ser.Id };
            var result = Server.API.HttpSend<M_Organization_Team[]>("/organization/team/select", Server.Method.POST, data);
            this.TeamList.Clear();
            if (result != null)
            {
                foreach (var t in result)
                {
                    this.TeamList.Add(t);
                }
            }
        }
        private void TeamAdd()
        {
            if (this.DepartmentSelected.Id == 0)
            {
                MessageBox.Show("부서를 선택해주세요.", "팀 추가", MessageBoxButton.OK, MessageBoxImage.Warning);
                return;
            }

            var add = this.TeamSelected;
            add.Department_Id = this.DepartmentSelected.Id;
            var data = add;
            var result = Server.API.HttpSend<M_DB_Result>("/organization/team/insert", Server.Method.POST, data);
            if (result != null && result.InsertId > 0)
            {
                TeamSearch();
            }
        }
        private void TeamEdit()
        {
            if (this.TeamSelected.Id == 0)
            {
                MessageBox.Show("수정할 팀을 선택해주세요.", "팀 수정", MessageBoxButton.OK, MessageBoxImage.Warning);
                return;
            }

            var edit = this.TeamSelected;
            var data = new { id = edit.Id, name = edit.Name, description = edit.Description, department_id = edit.Department_Id };
            var result = Server.API.HttpSend<M_DB_Result>("/organization/team/update", Server.Method.PUT, data);
            if (result != null && result.AffectedRows > 0)
            {
                TeamSearch();
            }
        }
        private void TeamDelete()
        {
            if (this.TeamSelected.Id == 0)
            {
                MessageBox.Show("삭제할 팀을 선택해주세요.", "팀 삭제", MessageBoxButton.OK, MessageBoxImage.Warning);
                return;
            }

            var del = this.TeamSelected;
            var data = new { id = del.Id };
            var result = Server.API.HttpSend<M_DB_Result>("/organization/team/delete", Server.Method.DELETE, data);
            if (result != null && result.AffectedRows > 0)
            {
                TeamSearch();
            }
        }

        // Rank
        private void RankSearch()
        {
            var ser = this.RankSelected;
            var result = Server.API.HttpSend<M_Organization_Rank[]>("/organization/rank/select", Server.Method.POST);
            this.RankList.Clear();
            if (result != null)
            {
                foreach (var r in result)
                {
                    this.RankList.Add(r);
                }
            }
        }
        private void RankAdd()
        {
            if (this.RankSelected.Name == string.Empty)
            {
                MessageBox.Show("직급 정보를 입력해주세요.", "직급 추가", MessageBoxButton.OK, MessageBoxImage.Warning);
                return;
            }

            var add = this.RankSelected;
            var data = add;
            var result = Server.API.HttpSend<M_DB_Result>("/organization/rank/insert", Server.Method.POST, data);
            if (result != null && result.InsertId > 0)
            {
                RankSearch();
            }
        }
        private void RankEdit()
        {
            if (this.RankSelected.Id == 0)
            {
                MessageBox.Show("수정할 직급을 선택해주세요.", "직급 수정", MessageBoxButton.OK, MessageBoxImage.Warning);
                return;
            }

            var edit = this.RankSelected;
            var data = new { id = edit.Id, name = edit.Name, description = edit.Description };
            var result = Server.API.HttpSend<M_DB_Result>("/organization/rank/update", Server.Method.PUT, data);
            if (result != null && result.AffectedRows > 0)
            {
                RankSearch();
            }
        }
        private void RankDelete()
        {
            if (this.RankSelected.Id == 0)
            {
                MessageBox.Show("삭제할 직급을 선택해주세요.", "직급 삭제", MessageBoxButton.OK, MessageBoxImage.Warning);
                return;
            }

            var del = this.RankSelected;
            var data = new { id = del.Id };
            var result = Server.API.HttpSend<M_DB_Result>("/organization/rank/delete", Server.Method.DELETE, data);
            if (result != null && result.AffectedRows > 0)
            {
                RankSearch();
            }
        }

        // Position
        private void PositionSearch()
        {
            var ser = this.PositioSelected;
            var result = Server.API.HttpSend<M_Organization_Position[]>("/organization/position/select", Server.Method.POST);
            this.PositionList.Clear();
            if (result != null)
            {
                foreach (var p in result)
                {
                    this.PositionList.Add(p);
                }
            }
        }
        private void PositionAdd()
        {
            if (this.PositioSelected.Name == string.Empty)
            {
                MessageBox.Show("직책 정보를 입력해주세요.", "직책 추가", MessageBoxButton.OK, MessageBoxImage.Warning);
                return;
            }

            var add = this.PositioSelected;
            var data = add;
            var result = Server.API.HttpSend<M_DB_Result>("/organization/position/insert", Server.Method.POST, data);
            if (result != null && result.InsertId > 0)
            {
                PositionSearch();
            }
        }
        private void PositionEdit()
        {
            if (this.PositioSelected.Id == 0)
            {
                MessageBox.Show("수정할 직책을 선택해주세요.", "직책 수정", MessageBoxButton.OK, MessageBoxImage.Warning);
                return;
            }

            var edit = this.PositioSelected;
            var data = new { id = edit.Id, name = edit.Name, description = edit.Description };
            var result = Server.API.HttpSend<M_DB_Result>("/organization/position/update", Server.Method.PUT, data);
            if (result != null && result.AffectedRows > 0)
            {
                PositionSearch();
            }
        }
        private void PositionDelete()
        {
            if (this.PositioSelected.Id == 0)
            {
                MessageBox.Show("삭제할 직책을 선택해주세요.", "직책 삭제", MessageBoxButton.OK, MessageBoxImage.Warning);
                return;
            }

            var del = this.PositioSelected;
            var data = new { id = del.Id };
            var result = Server.API.HttpSend<M_DB_Result>("/organization/position/delete", Server.Method.DELETE, data);
            if (result != null && result.AffectedRows > 0)
            {
                PositionSearch();
            }
        }

        // Role
        private void RoleSearch()
        {
            var ser = this.RoleSelected;
            var result = Server.API.HttpSend<M_Organization_Role[]>("/organization/role/select", Server.Method.POST);
            this.RoleList.Clear();
            if (result != null)
            {
                foreach (var r in result)
                {
                    this.RoleList.Add(r);
                }
            }
        }
        private void RoleAdd()
        {
            if (this.RoleSelected.Name == string.Empty)
            {
                MessageBox.Show("담당 정보를 입력해주세요.", "담당 추가", MessageBoxButton.OK, MessageBoxImage.Warning);
                return;
            }

            var add = this.RoleSelected;
            var data = add;
            var result = Server.API.HttpSend<M_DB_Result>("/organization/role/insert", Server.Method.POST, data);
            if (result != null && result.InsertId > 0)
            {
                RoleSearch();
            }
        }
        private void RoleEdit()
        {
            if (this.RoleSelected.Id == 0)
            {
                MessageBox.Show("수정할 담당을 선택해주세요.", "담당 수정", MessageBoxButton.OK, MessageBoxImage.Warning);
                return;
            }

            var edit = this.RoleSelected;
            var data = new { id = edit.Id, name = edit.Name, description = edit.Description };
            var result = Server.API.HttpSend<M_DB_Result>("/organization/role/update", Server.Method.PUT, data);
            if (result != null && result.AffectedRows > 0)
            {
                RoleSearch();
            }
        }
        private void RoleDelete()
        {
            if (this.RoleSelected.Id == 0)
            {
                MessageBox.Show("삭제할 담당을 선택해주세요.", "담당 삭제", MessageBoxButton.OK, MessageBoxImage.Warning);
                return;
            }

            var del = this.RoleSelected;
            var data = new { id = del.Id };
            var result = Server.API.HttpSend<M_DB_Result>("/organization/role/delete", Server.Method.DELETE, data);
            if (result != null && result.AffectedRows > 0)
            {
                RoleSearch();
            }
        }
    }
}
