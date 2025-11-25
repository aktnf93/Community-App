using community.Common;
using community.Models;
using System;
using System.Collections.Generic;
using System.Collections.ObjectModel;
using System.Linq;
using System.Runtime.Remoting.Proxies;
using System.Text;
using System.Threading.Tasks;

namespace community.ViewModels
{
    public class VM_ProjectDetail : Notify
    {
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

        //public string ProjectDescription
        //{
        //    get => 
        //}
        public int ProjectProgress { get; set; }
        public DateTime? ProjectStartDate { get; set; }
        public DateTime? ProjectEndDate { get; set; }
        public string ProjectStatus { get; set; }
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
        // -----------------------------


        public VM_ProjectDetail()
        {
            
        }

        private void LoadEmployee()
        {

        }

        private void LoadCustomer()
        {

        }


        private void BtnProgressUp()
        {

        }

        private void BtnProgressDown()
        {

        }

        private void BtnProjectAdd()
        {

        }

        private void BtnProjectUpdate()
        {

        }

        private void BtnTaskAdd()
        {

        }
    }
}
