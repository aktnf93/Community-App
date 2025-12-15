using System;
using System.Collections.ObjectModel;
using System.Threading.Tasks;
using System.Windows;
using System.Windows.Controls;
using community.Common;
using community.Models;

namespace community.ViewModels
{
    public class VM_System : ViewModelBase
    {
        private bool _ChkSystemListView = true;
        private bool _ChkSystemPostView = false;
        private bool _ChkSystemEmployeeView = false;

        public bool ChkSystemListView
        {
            get => this._ChkSystemListView;
            set => base.OnPropertyChanged(ref this._ChkSystemListView, value);
        }

        public bool ChkSystemPostView
        {
            get => this._ChkSystemPostView;
            set => base.OnPropertyChanged(ref this._ChkSystemPostView, value);
        }

        public bool ChkSystemEmployeeView
        {
            get => this._ChkSystemEmployeeView;
            set => base.OnPropertyChanged(ref this._ChkSystemEmployeeView, value);
        }

        public ObservableCollection<M_System_Log> SystemLogs { get; set; } = new ObservableCollection<M_System_Log>();
        public ObservableCollection<M_System_Config> SystemConfigs { get; set; } = new ObservableCollection<M_System_Config>();
        
        public ObservableCollection<M_Post_Category> PostCategoryParentList { get; set; } = new ObservableCollection<M_Post_Category>();
        public M_Post_Category _PostCategoryParentSelected = new M_Post_Category();
        public M_Post_Category PostCategoryParentSelected
        {
            get => this._PostCategoryParentSelected;
            set
            {
                if (value is null)
                {
                    this._PostCategoryParentSelected = new M_Post_Category();
                }
                else
                {
                    this._PostCategoryParentSelected = Utility.DeepCopy<M_Post_Category>(value);

                    this.PostCategorySearch(value.Id);
                }

                base.OnPropertyChanged(nameof(this.PostCategoryParentSelected));
            }
        }

        public ObservableCollection<M_Post_Category> PostCategoryList { get; set; } = new ObservableCollection<M_Post_Category>();
        public M_Post_Category _PostCategorySelected = new M_Post_Category();
        public M_Post_Category PostCategorySelected
        {
            get => this._PostCategorySelected;
            set
            {
                if (value is null)
                {
                    this._PostCategorySelected = new M_Post_Category();
                }
                else
                {
                    this._PostCategorySelected = Utility.DeepCopy<M_Post_Category>(value); ;
                }

                base.OnPropertyChanged(nameof(this.PostCategorySelected));
            }
        }

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

        private async Task Loaded()
        {
            Console.WriteLine("VM_System Loaded");

            await SysTemLogSearch();
            await SystemConfigSearch();

            await PostCategorySearch(0);

            await CompanySearch();
            await RankSearch();
            await PositionSearch();
            await RoleSearch();
        }

        private async Task SysTemLogSearch()
        {
            var logs = await HTTP_Server.API.HttpSendAsync<M_System_Log[]>("/system/log/select", HTTP_Server.Method.POST, null);
            this.SystemLogs.Clear();
            if (logs != null)
            {
                foreach (var c in logs)
                {
                    this.SystemLogs.Add(c);
                }
            }
        }
        private async Task SystemConfigSearch()
        {
            var configs = await HTTP_Server.API.HttpSendAsync<M_System_Config[]>("/system/config/select", HTTP_Server.Method.POST, null);
            this.SystemConfigs.Clear();
            if (configs != null)
            {
                foreach (var c in configs)
                {
                    this.SystemConfigs.Add(c);
                }
            }
        }


        // PostCategory
        private async Task PostCategorySearch(int parent_id)
        {
            if (parent_id > 0)
            {
                var req = new { select_type = "child", parent_id = parent_id };
                var result = await HTTP_Server.API.HttpSendAsync<M_Post_Category[]>("/post/category/select", HTTP_Server.Method.POST, req);

                this.PostCategoryList = new ObservableCollection<M_Post_Category>(result);
                base.OnPropertyChanged(nameof(this.PostCategoryList));
            }
            else
            {
                var req = new { select_type = "parent", parent_id = parent_id };
                var result = await HTTP_Server.API.HttpSendAsync<M_Post_Category[]>("/post/category/select", HTTP_Server.Method.POST, req);

                this.PostCategoryParentList = new ObservableCollection<M_Post_Category>(result);
                base.OnPropertyChanged(nameof(this.PostCategoryParentList));
            }
        }
        private async Task PostCategoryAdd(object sender, RoutedEventArgs e)
        {
            await UiAction.Instance.ExecuteAsync(async () =>
            {
                if (sender is Button btn)
                {
                    if (btn.Uid == "parent")
                    {
                        var selected = this.PostCategoryParentSelected;

                        if (string.IsNullOrEmpty(selected.Name))
                        {
                            MessageBox.Show("추가할 카테고리 이름이 없습니다.\n이름을 입력해주세요.", "상위 카테고리 추가", MessageBoxButton.OK, MessageBoxImage.Error);
                            return;
                        }

                        var req = new { selected.Name, selected.Description };
                        var result = await HTTP_Server.API.HttpSendAsync<M_DB_Result>("/post/category/insert", HTTP_Server.Method.POST, req);
                        if (result != null && result.InsertId > 0)
                        {
                            await PostCategorySearch(0);
                        }
                    }
                    else
                    {
                        var selected = this.PostCategorySelected;

                        if (selected.Parent_Id is null || selected.Parent_Id == 0)
                        {
                            MessageBox.Show("선택된 상위 카테고리가 없습니다.\n상위 카테고리를 선택해주세요.", "하위 카테고리 추가", MessageBoxButton.OK, MessageBoxImage.Error);
                            return;
                        }

                        if (string.IsNullOrEmpty(selected.Name))
                        {
                            MessageBox.Show("추가할 카테고리 이름이 없습니다.\n이름을 입력해주세요.", "하위 카테고리 추가", MessageBoxButton.OK, MessageBoxImage.Error);
                            return;
                        }

                        var req = new { selected.Name, selected.Description, selected.Parent_Id };
                        var result = await HTTP_Server.API.HttpSendAsync<M_DB_Result>("/post/category/insert", HTTP_Server.Method.POST, req);
                        if (result != null && result.InsertId > 0)
                        {
                            await PostCategorySearch(selected.Parent_Id.Value);
                        }
                    }
                }
            });
        }
        private async Task PostCategoryEdit(object sender, RoutedEventArgs e)
        {
            await UiAction.Instance.ExecuteAsync(async () =>
            {
                if (sender is Button btn)
                {
                    if (btn.Uid == "parent")
                    {
                        var selected = this.PostCategoryParentSelected;

                        if (selected.Id == 0)
                        {
                            MessageBox.Show("수정할 카테고리를 선택해주세요.", "상위 카테고리 수정", MessageBoxButton.OK, MessageBoxImage.Error);
                            return;
                        }

                        if (string.IsNullOrEmpty(selected.Name))
                        {
                            MessageBox.Show("수정할 카테고리 이름이 없습니다.\n이름을 입력해주세요.", "상위 카테고리 수정", MessageBoxButton.OK, MessageBoxImage.Error);
                            return;
                        }

                        var req = new { id = selected.Id, name = selected.Name, description = selected.Description };
                        var result = HTTP_Server.API.HttpSend<M_DB_Result>("/post/category/update", HTTP_Server.Method.PUT, req);
                        if (result != null && result.AffectedRows > 0)
                        {
                            await PostCategorySearch(0);
                        }
                    }
                    else
                    {
                        var selected = this.PostCategorySelected;

                        if (selected.Id == 0)
                        {
                            MessageBox.Show("수정할 카테고리를 선택해주세요.", "하위 카테고리 수정", MessageBoxButton.OK, MessageBoxImage.Error);
                            return;
                        }

                        if (string.IsNullOrEmpty(selected.Name))
                        {
                            MessageBox.Show("수정할 카테고리 이름이 없습니다.\n이름을 입력해주세요.", "하위 카테고리 수정", MessageBoxButton.OK, MessageBoxImage.Error);
                            return;
                        }

                        var req = new { id = selected.Id, name = selected.Name, description = selected.Description };
                        var result = HTTP_Server.API.HttpSend<M_DB_Result>("/post/category/update", HTTP_Server.Method.PUT, req);
                        if (result != null && result.AffectedRows > 0)
                        {
                            await PostCategorySearch(selected.Parent_Id.Value);
                        }
                    }
                }
            });
        }
        private async Task PostCategoryDelete(object sender, RoutedEventArgs e)
        {
            await UiAction.Instance.ExecuteAsync(async () =>
            {
                if (sender is Button btn)
                {
                    if (btn.Uid == "parent")
                    {
                        var selected = this.PostCategoryParentSelected;
                        if (selected.Id == 0)
                        {
                            MessageBox.Show("삭제할 카테고리를 선택해주세요.", "상위 카테고리 삭제", MessageBoxButton.OK, MessageBoxImage.Error);
                            return;
                        }

                        var req = new { id = selected.Id };
                        var result = await HTTP_Server.API.HttpSendAsync<M_DB_Result>("/post/category/delete", HTTP_Server.Method.DELETE, req);
                        if (result != null && result.AffectedRows > 0)
                        {
                            await PostCategorySearch(0);
                        }
                    }
                    else
                    {
                        var selected = this.PostCategorySelected;
                        if (selected.Id == 0)
                        {
                            MessageBox.Show("삭제할 카테고리를 선택해주세요.", "하위 카테고리 삭제", MessageBoxButton.OK, MessageBoxImage.Error);
                            return;
                        }

                        var req = new { id = selected.Id };
                        var result = await HTTP_Server.API.HttpSendAsync<M_DB_Result>("/post/category/delete", HTTP_Server.Method.DELETE, req);
                        if (result != null && result.AffectedRows > 0)
                        {
                            await PostCategorySearch(selected.Parent_Id.Value);
                        }
                    }
                }
            });
        }

        // Company
        private async Task CompanySearch()
        {
            var data = await HTTP_Server.API.HttpSendAsync<M_Organization_Company[]>("/organization/company/select", HTTP_Server.Method.POST, null);
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
        private async Task CompanyAdd()
        {
            await UiAction.Instance.ExecuteAsync(async () =>
            {
                var add = this.CompanySelected;
                var data = add;
                var result = await HTTP_Server.API.HttpSendAsync<M_DB_Result>("/organization/company/insert", HTTP_Server.Method.POST, data);
                if (result != null && result.InsertId > 0)
                {
                    await CompanySearch();
                }
            });
        }
        private async Task CompanyEdit()
        {
            await UiAction.Instance.ExecuteAsync(async () =>
            {
                if (this.CompanySelected.Id == 0)
                {
                    MessageBox.Show("수정할 회사를 선택해주세요.", "회사 수정", MessageBoxButton.OK, MessageBoxImage.Warning);
                    return;
                }

                var edit = this.CompanySelected;
                var data = new { id = edit.Id, name = edit.Name, description = edit.Description };
                var result = HTTP_Server.API.HttpSend<M_DB_Result>("/organization/company/update", HTTP_Server.Method.PUT, data);
                if (result != null && result.AffectedRows > 0)
                {
                    await CompanySearch();
                }
            });
        }
        private async Task CompanyDelete()
        {
            await UiAction.Instance.ExecuteAsync(async () =>
            {
                if (this.CompanySelected.Id == 0)
                {
                    MessageBox.Show("삭제할 회사를 선택해주세요.", "회사 삭제", MessageBoxButton.OK, MessageBoxImage.Warning);
                    return;
                }

                var del = this.CompanySelected;
                var data = new { id = del.Id };
                var result = HTTP_Server.API.HttpSend<M_DB_Result>("/organization/company/delete", HTTP_Server.Method.DELETE, data);
                if (result != null && result.AffectedRows > 0)
                {
                    await CompanySearch();
                }
            });
        }

        // Department
        private async Task DepartmentSearch()
        {
            await UiAction.Instance.ExecuteAsync(async () =>
            {
                var ser = this.CompanySelected;
                var data = new { company_id = ser.Id };
                var result = await HTTP_Server.API.HttpSendAsync<M_Organization_Department[]>("/organization/department/select", HTTP_Server.Method.POST, data);
                this.DepartmentList.Clear();
                if (result != null)
                {
                    foreach (var d in result)
                    {
                        this.DepartmentList.Add(d);
                    }
                }
            });
        }
        private async Task DepartmentAdd()
        {
            await UiAction.Instance.ExecuteAsync(async () =>
            {
                if (this.CompanySelected.Id == 0)
                {
                    MessageBox.Show("부서를 추가할 회사를 선택해주세요.", "부서 추가", MessageBoxButton.OK, MessageBoxImage.Warning);
                    return;
                }

                var add = this.DepartmentSelected;
                add.Company_Id = this.CompanySelected.Id;
                var data = add;
                var result = await HTTP_Server.API.HttpSendAsync<M_DB_Result>("/organization/department/insert", HTTP_Server.Method.POST, data);
                if (result != null && result.InsertId > 0)
                {
                    await DepartmentSearch();
                }
            });
        }
        private async Task DepartmentEdit()
        {
            await UiAction.Instance.ExecuteAsync(async () =>
            {
                if (this.DepartmentSelected.Id == 0)
                {
                    MessageBox.Show("수정할 부서를 선택해주세요.", "부서 수정", MessageBoxButton.OK, MessageBoxImage.Warning);
                    return;
                }

                var edit = this.DepartmentSelected;
                var data = new { id = edit.Id, name = edit.Name, description = edit.Description, company_id = edit.Company_Id };
                var result = await HTTP_Server.API.HttpSendAsync<M_DB_Result>("/organization/department/update", HTTP_Server.Method.PUT, data);
                if (result != null && result.AffectedRows > 0)
                {
                    await DepartmentSearch();
                }
            });
        }
        private async Task DepartmentDelete()
        {
            await UiAction.Instance.ExecuteAsync(async () =>
            {
                if (this.DepartmentSelected.Id == 0)
                {
                    MessageBox.Show("삭제할 부서를 선택해주세요.", "부서 삭제", MessageBoxButton.OK, MessageBoxImage.Warning);
                    return;
                }

                var del = this.DepartmentSelected;
                var data = new { id = del.Id };
                var result = await HTTP_Server.API.HttpSendAsync<M_DB_Result>("/organization/department/delete", HTTP_Server.Method.DELETE, data);
                if (result != null && result.AffectedRows > 0)
                {
                    await DepartmentSearch();
                }
            });
        }

        // Team
        private async Task TeamSearch()
        {
            await UiAction.Instance.ExecuteAsync(async () =>
            {
                var ser = this.DepartmentSelected;
                var data = new { department_id = ser.Id };
                var result = await HTTP_Server.API.HttpSendAsync<M_Organization_Team[]>("/organization/team/select", HTTP_Server.Method.POST, data);
                this.TeamList.Clear();
                if (result != null)
                {
                    foreach (var t in result)
                    {
                        this.TeamList.Add(t);
                    }
                }
            });
        }
        private async Task TeamAdd()
        {
            await UiAction.Instance.ExecuteAsync(async () =>
            {
                if (this.DepartmentSelected.Id == 0)
                {
                    MessageBox.Show("부서를 선택해주세요.", "팀 추가", MessageBoxButton.OK, MessageBoxImage.Warning);
                    return;
                }

                var add = this.TeamSelected;
                add.Department_Id = this.DepartmentSelected.Id;
                var data = add;
                var result = HTTP_Server.API.HttpSend<M_DB_Result>("/organization/team/insert", HTTP_Server.Method.POST, data);
                if (result != null && result.InsertId > 0)
                {
                    await TeamSearch();
                }
            });
        }
        private async Task TeamEdit()
        {
            await UiAction.Instance.ExecuteAsync(async () =>
            {
                if (this.TeamSelected.Id == 0)
                {
                    MessageBox.Show("수정할 팀을 선택해주세요.", "팀 수정", MessageBoxButton.OK, MessageBoxImage.Warning);
                    return;
                }

                var edit = this.TeamSelected;
                var data = new { id = edit.Id, name = edit.Name, description = edit.Description, department_id = edit.Department_Id };
                var result = HTTP_Server.API.HttpSend<M_DB_Result>("/organization/team/update", HTTP_Server.Method.PUT, data);
                if (result != null && result.AffectedRows > 0)
                {
                    await TeamSearch();
                }
            });
        }
        private async Task TeamDelete()
        {
            await UiAction.Instance.ExecuteAsync(async () =>
            {
                if (this.TeamSelected.Id == 0)
                {
                    MessageBox.Show("삭제할 팀을 선택해주세요.", "팀 삭제", MessageBoxButton.OK, MessageBoxImage.Warning);
                    return;
                }

                var del = this.TeamSelected;
                var data = new { id = del.Id };
                var result = await HTTP_Server.API.HttpSendAsync<M_DB_Result>("/organization/team/delete", HTTP_Server.Method.DELETE, data);
                if (result != null && result.AffectedRows > 0)
                {
                    await TeamSearch();
                }
            });
        }

        // Rank
        private async Task RankSearch()
        {
            var ser = this.RankSelected;
            var result = await HTTP_Server.API.HttpSendAsync<M_Organization_Rank[]>("/organization/rank/select", HTTP_Server.Method.POST, null);
            this.RankList.Clear();
            if (result != null)
            {
                foreach (var r in result)
                {
                    this.RankList.Add(r);
                }
            }
        }
        private async Task RankAdd()
        {
            await UiAction.Instance.ExecuteAsync(async () =>
            {
                if (this.RankSelected.Name == string.Empty)
                {
                    MessageBox.Show("직급 정보를 입력해주세요.", "직급 추가", MessageBoxButton.OK, MessageBoxImage.Warning);
                    return;
                }

                var add = this.RankSelected;
                var data = add;
                var result = await HTTP_Server.API.HttpSendAsync<M_DB_Result>("/organization/rank/insert", HTTP_Server.Method.POST, data);
                if (result != null && result.InsertId > 0)
                {
                    await RankSearch();
                }
            });
        }
        private async Task RankEdit()
        {
            await UiAction.Instance.ExecuteAsync(async () =>
            {
                if (this.RankSelected.Id == 0)
                {
                    MessageBox.Show("수정할 직급을 선택해주세요.", "직급 수정", MessageBoxButton.OK, MessageBoxImage.Warning);
                    return;
                }

                var edit = this.RankSelected;
                var data = new { id = edit.Id, name = edit.Name, description = edit.Description };
                var result = await HTTP_Server.API.HttpSendAsync<M_DB_Result>("/organization/rank/update", HTTP_Server.Method.PUT, data);
                if (result != null && result.AffectedRows > 0)
                {
                    await RankSearch();
                }
            });
        }
        private async Task RankDelete()
        {
            await UiAction.Instance.ExecuteAsync(async () =>
            {
                if (this.RankSelected.Id == 0)
                {
                    MessageBox.Show("삭제할 직급을 선택해주세요.", "직급 삭제", MessageBoxButton.OK, MessageBoxImage.Warning);
                    return;
                }

                var del = this.RankSelected;
                var data = new { id = del.Id };
                var result = await HTTP_Server.API.HttpSendAsync<M_DB_Result>("/organization/rank/delete", HTTP_Server.Method.DELETE, data);
                if (result != null && result.AffectedRows > 0)
                {
                    await RankSearch();
                }
            });
        }

        // Position
        private async Task PositionSearch()
        {
            var ser = this.PositioSelected;
            var result = await HTTP_Server.API.HttpSendAsync<M_Organization_Position[]>("/organization/position/select", HTTP_Server.Method.POST, null);
            this.PositionList.Clear();
            if (result != null)
            {
                foreach (var p in result)
                {
                    this.PositionList.Add(p);
                }
            }
        }
        private async Task PositionAdd()
        {
            await UiAction.Instance.ExecuteAsync(async () =>
            {
                if (this.PositioSelected.Name == string.Empty)
                {
                    MessageBox.Show("직책 정보를 입력해주세요.", "직책 추가", MessageBoxButton.OK, MessageBoxImage.Warning);
                    return;
                }

                var add = this.PositioSelected;
                var data = add;
                var result = await HTTP_Server.API.HttpSendAsync<M_DB_Result>("/organization/position/insert", HTTP_Server.Method.POST, data);
                if (result != null && result.InsertId > 0)
                {
                    await PositionSearch();
                }
            });
        }
        private async Task PositionEdit()
        {
            await UiAction.Instance.ExecuteAsync(async () =>
            {
                if (this.PositioSelected.Id == 0)
                {
                    MessageBox.Show("수정할 직책을 선택해주세요.", "직책 수정", MessageBoxButton.OK, MessageBoxImage.Warning);
                    return;
                }

                var edit = this.PositioSelected;
                var data = new { id = edit.Id, name = edit.Name, description = edit.Description };
                var result = await HTTP_Server.API.HttpSendAsync<M_DB_Result>("/organization/position/update", HTTP_Server.Method.PUT, data);
                if (result != null && result.AffectedRows > 0)
                {
                    await PositionSearch();
                }
            });
        }
        private async Task PositionDelete()
        {
            await UiAction.Instance.ExecuteAsync(async () =>
            {
                if (this.PositioSelected.Id == 0)
                {
                    MessageBox.Show("삭제할 직책을 선택해주세요.", "직책 삭제", MessageBoxButton.OK, MessageBoxImage.Warning);
                    return;
                }

                var del = this.PositioSelected;
                var data = new { id = del.Id };
                var result = await HTTP_Server.API.HttpSendAsync<M_DB_Result>("/organization/position/delete", HTTP_Server.Method.DELETE, data);
                if (result != null && result.AffectedRows > 0)
                {
                    await PositionSearch();
                }
            });
        }

        // Role
        private async Task RoleSearch()
        {
            var ser = this.RoleSelected;
            var result = await HTTP_Server.API.HttpSendAsync<M_Organization_Role[]>("/organization/role/select", HTTP_Server.Method.POST, null);
            this.RoleList.Clear();
            if (result != null)
            {
                foreach (var r in result)
                {
                    this.RoleList.Add(r);
                }
            }
        }
        private async Task RoleAdd()
        {
            await UiAction.Instance.ExecuteAsync(async () =>
            {
                if (this.RoleSelected.Name == string.Empty)
                {
                    MessageBox.Show("담당 정보를 입력해주세요.", "담당 추가", MessageBoxButton.OK, MessageBoxImage.Warning);
                    return;
                }

                var add = this.RoleSelected;
                var data = add;
                var result = await HTTP_Server.API.HttpSendAsync<M_DB_Result>("/organization/role/insert", HTTP_Server.Method.POST, data);
                if (result != null && result.InsertId > 0)
                {
                    await RoleSearch();
                }
            });
        }
        private async Task RoleEdit()
        {
            await UiAction.Instance.ExecuteAsync(async () =>
            {
                if (this.RoleSelected.Id == 0)
                {
                    MessageBox.Show("수정할 담당을 선택해주세요.", "담당 수정", MessageBoxButton.OK, MessageBoxImage.Warning);
                    return;
                }

                var edit = this.RoleSelected;
                var data = new { id = edit.Id, name = edit.Name, description = edit.Description };
                var result = await HTTP_Server.API.HttpSendAsync<M_DB_Result>("/organization/role/update", HTTP_Server.Method.PUT, data);
                if (result != null && result.AffectedRows > 0)
                {
                    await RoleSearch();
                }
            });
        }
        private async Task RoleDelete()
        {
            await UiAction.Instance.ExecuteAsync(async () =>
            {
                if (this.RoleSelected.Id == 0)
                {
                    MessageBox.Show("삭제할 담당을 선택해주세요.", "담당 삭제", MessageBoxButton.OK, MessageBoxImage.Warning);
                    return;
                }

                var del = this.RoleSelected;
                var data = new { id = del.Id };
                var result = await HTTP_Server.API.HttpSendAsync<M_DB_Result>("/organization/role/delete", HTTP_Server.Method.DELETE, data);
                if (result != null && result.AffectedRows > 0)
                {
                    await RoleSearch();
                }
            });
        }
    }
}
