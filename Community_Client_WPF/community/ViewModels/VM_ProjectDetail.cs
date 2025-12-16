using community.Common;
using community.Models;
using System;
using System.Collections.Generic;
using System.Collections.ObjectModel;
using System.Linq;
using System.Runtime.Remoting.Proxies;
using System.Text;
using System.Threading.Tasks;
using System.Windows;
using System.Xml.Linq;

namespace community.ViewModels
{
    public class VM_ProjectDetail : Notify
    {
        public event ActionHandler OnClose;

        private int projectId;
        private int customerId;
        private string projectName;
        private string projectDescription;
        private int projectProgress;
        private DateTime? projectStartDate;
        private DateTime? projectEndDate;
        private string projectStatus;

        public int ProjectId
        {
            get => this.projectId;
            set => base.OnPropertyChanged(ref this.projectId, value);
        }

        public int CustomerId
        {
            get => this.customerId;
            set => base.OnPropertyChanged(ref this.customerId, value);
        }

        public string ProjectName
        {
            get => this.projectName;
            set => base.OnPropertyChanged(ref this.projectName, value);
        }

        public string ProjectDescription
        {
            get => this.projectDescription;
            set => base.OnPropertyChanged(ref this.projectDescription, value);
        }

        public int ProjectProgress
        {
            get => this.projectProgress;
            set
            {
                if (value >= 100)
                {
                    value = 100;
                }
                else if (value <= 0)
                {
                    value = 0;
                }

                base.OnPropertyChanged(ref this.projectProgress, value);
            }
        }

        public DateTime? ProjectStartDate
        {
            get => this.projectStartDate;
            set => base.OnPropertyChanged(ref this.projectStartDate, value);
        }

        public DateTime? ProjectEndDate
        {
            get => this.projectEndDate;
            set => base.OnPropertyChanged(ref this.projectEndDate, value);
        }

        public string ProjectStatus
        {
            get => this.projectStatus;
            set => base.OnPropertyChanged(ref this.projectStatus, value);
        }

        public ObservableCollection<M_Employee> ProjectMembers { get; set; }
            = new ObservableCollection<M_Employee>();

        public ObservableCollection<M_Project_Task> ProjectTasks { get; set; }
            = new ObservableCollection<M_Project_Task>();


        // items -----------------------
        public ObservableCollection<M_Customer> CboCustomerList { get; set; }
            = new ObservableCollection<M_Customer>();
        public string[] CboStatusList { get; set; } = { "대기", "진행", "완료", "취소", "보류" };
        public ObservableCollection<M_Employee> CboMemberList { get; set; }
            = new ObservableCollection<M_Employee>();

        public M_Employee CboProjectMemberSelected { get; set; }
        // -----------------------------


        public VM_ProjectDetail()
        {

        }

        private void Loaded()
        {
            Console.WriteLine("VM_ProjectDetail");



            LoadCustomer(); // 선택 가능한 고객사 불러오기
            LoadEmployee(); // 선택 가능한 직원 불러오기

            if (this.ProjectId != 0)
            {
                // 기존 프로젝트 업데이트

                // 기존 고객사 및 직원, 작업 리스트 불러오기
                // 

            }
        }

        /// <summary>
        /// 고객사 정보 불러오기
        /// </summary>
        private void LoadCustomer()
        {
            var customers = HTTP_Server.API.HttpSend<M_Customer[]>("/customer/list/select");

            this.CboCustomerList.Clear();
            if (customers != null)
            {
                foreach (var c in customers)
                {
                    this.CboCustomerList.Add(c);
                }
            }
        }

        /// <summary>
        /// 직원 정보 불러오기
        /// </summary>
        private void LoadEmployee()
        {
            var employees = HTTP_Server.API.HttpSend<M_Employee[]>("/employee/list/select");

            this.CboMemberList.Clear();
            if (employees != null)
            {
                foreach (var e in employees)
                {
                    e.OnEmployeeDelete += (_e) =>
                    {
                        this.ProjectMembers.Remove(_e);
                    };

                    this.CboMemberList.Add(e);
                }
            }
        }

        /// <summary>
        /// 진행률 업
        /// </summary>
        private void BtnProgressUp()
        {
            this.ProjectProgress++;
        }

        /// <summary>
        /// 진행률 다운
        /// </summary>
        private void BtnProgressDown()
        {
            this.ProjectProgress--;
        }

        /// <summary>
        /// 프로젝트 멤버 추가
        /// </summary>
        private void BtnProjectMemberAdd()
        {
            var member = this.CboProjectMemberSelected;

            if (member != null)
            {
                if (this.ProjectMembers.Any(x => x.Id == member.Id))
                {
                    // 이미 등록됨.
                }
                else
                {
                    this.ProjectMembers.Add(member);
                }
            }
            else
            {
                MessageBox.Show("프로젝트 멤버를 선택해주세요", "멤버 추가",
                    MessageBoxButton.OK, MessageBoxImage.Warning);
            }
        }

        /// <summary>
        /// 프로젝트 내 작업 추가
        /// </summary>
        private void BtnTaskAdd()
        {
            var task = new M_Project_Task();
            task.Name = "새 작업";
            task.Progress = 0;
            task.Start_Date = DateTime.Now;
            task.End_Date = DateTime.Now;
            task.OnTaskDelete += (_t) =>
            {
                this.ProjectTasks.Remove(_t);
            };

            this.ProjectTasks.Add(task);
        }

        /// <summary>
        /// 프로젝트 신규 생성
        /// </summary>
        private void BtnProjectAdd()
        {
            if (string.IsNullOrEmpty(this.ProjectName))
            {
                MessageBox.Show("프로젝트 이름을 입력해주세요.", "프로젝트 생성 실패",
                    MessageBoxButton.OK, MessageBoxImage.Warning);
                return;
            }

            var result = MessageBox.Show("해당 내용으로 프로젝트를 생성 하시겠습니까?", "프로젝트 생성 확인",
                MessageBoxButton.YesNo, MessageBoxImage.Question);

            if (result == MessageBoxResult.Yes)
            {
                // 프로젝트 생성 성공 후 창 닫기

                var project_box = new
                {
                    // 프로젝트 내용
                    project = new
                    {
                        id          = this.ProjectId,
                        customer_id = this.CustomerId,
                        name        = this.ProjectName,
                        description = this.ProjectDescription,
                        progress    = this.ProjectProgress,
                        start_date  = this.ProjectStartDate.Value.ToString("yyyy-MM-dd"),
                        end_date    = this.ProjectEndDate.Value.ToString("yyyy-MM-dd"),
                        status      = this.ProjectStatus
                    },

                    // 프로젝트 멤버
                    members = this.ProjectMembers.Select(x => new 
                    {
                        employee_id = x.Id
                    
                    }).ToArray(),

                    // 프로젝트 작업
                    tasks = this.ProjectTasks.Select(x => new
                    {
                        // id          = x.Id,
                        project_id  = x.Project_Id,
                        task_no     = x.Task_No,
                        name        = x.Name,
                        description = x.Description,
                        progress    = x.Progress,
                        start_date  = x.Start_Date.Value.ToString("yyyy-MM-dd"),
                        end_date    = x.End_Date.Value.ToString("yyyy-MM-dd"),
                        status      = x.Status,

                        // 프로젝트 작업 멤버
                        member      = (x.TaskMember != null) ? (object)x.TaskMember.Id : (object)null

                    }).ToArray()
                };
                
                var db_result = HTTP_Server.API.HttpSend<M_DB_Result>("/project/list/insert", data: project_box);

                if (db_result != null && db_result.InsertId > 0)
                {
                    this.OnClose?.Invoke();
                }
                else
                {
                    MessageBox.Show("프로젝트 생성에 실패하였습니다.", "프로젝트 생성 실패",
                        MessageBoxButton.OK, MessageBoxImage.Error);
                }
            }
        }

        /// <summary>
        /// 기존 프로젝트 업데이트
        /// </summary>
        private void BtnProjectUpdate()
        {

        }
    }
}
