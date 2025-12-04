using community.Common;
using Newtonsoft.Json;
using System;
using System.Runtime.Serialization;

namespace community.Models
{
    [DataContract]
    public class M_Employee : Notify
    {
        public event ActionHandler<M_Employee> OnEmployeeSelect;
        public event ActionHandler<M_Employee> OnEmployeeDelete;

        private int id;
        private string name;
        private string description;
        private string employee_code;
        private string gender;
        private DateTime? birth_date;
        private string email;
        private string phone;
        private string address;
        private string image_path;
        private string status;
        private DateTime? joined_at;
        private DateTime? resigned_at;
        private int? company_id;
        private string company_name;
        private int? department_id;
        private string department_name;
        private int? team_id;
        private string team_name;
        private int? rank_id;
        private string rank_name;
        private int? position_id;
        private string position_name;
        private int? role_id;
        private string role_name;
        private int? privilege_id;
        private string privilege_name;
        private string login_id = string.Empty;
        private string login_pw = string.Empty;
        private string login_pw_check = string.Empty;
        private string is_active;
        private DateTime created_at;
        private DateTime updated_at;
        private DateTime? deleted_at;

        [DataMember(Name = "id")]
        public int Id
        {
            get => this.id;
            set => base.OnPropertyChanged(ref this.id, value);
        }

        [DataMember(Name = "name")]
        public string Name
        {
            get => this.name;
            set => base.OnPropertyChanged(ref this.name, value);
        }

        [DataMember(Name = "description")]
        public string Description
        {
            get => this.description;
            set => base.OnPropertyChanged(ref this.description, value);
        }

        [DataMember(Name = "employee_code")]
        public string Employee_Code
        {
            get => this.employee_code;
            set => base.OnPropertyChanged(ref this.employee_code, value);
        }

        [DataMember(Name = "gender")]
        public string Gender
        {
            get => this.gender;
            set => base.OnPropertyChanged(ref this.gender, value);
        }

        [DataMember(Name = "birth_date")]
        public DateTime? Birth_Date
        {
            get => this.birth_date;
            set => base.OnPropertyChanged(ref this.birth_date, value);
        }

        [DataMember(Name = "email")]
        public string Email
        {
            get => this.email;
            set => base.OnPropertyChanged(ref this.email, value);
        }

        [DataMember(Name = "phone")]
        public string Phone
        {
            get => this.phone;
            set => base.OnPropertyChanged(ref this.phone, value);
        }

        [DataMember(Name = "address")]
        public string Address
        {
            get => this.address;
            set => base.OnPropertyChanged(ref this.address, value);
        }

        [DataMember(Name = "image_path")]
        public string Image_Path
        {
            get => this.image_path;
            set
            {
                base.OnPropertyChanged(ref this.image_path, value);
                base.OnPropertyChanged(nameof(Image_FullPath));
            }
        }

        /// <summary>
        /// 화면 바인딩
        /// </summary>
        public string Image_FullPath
        {
            get => HTTP_Server.API.BaseUrl + this.Image_Path;
        }

        [DataMember(Name = "status")]
        public string Status
        {
            get => this.status;
            set => base.OnPropertyChanged(ref this.status, value);
        }

        [DataMember(Name = "joined_at")]
        public DateTime? Joined_At
        {
            get => this.joined_at;
            set => base.OnPropertyChanged(ref this.joined_at, value);
        }

        [DataMember(Name = "resigned_at")]
        public DateTime? Resigned_At
        {
            get => this.resigned_at;
            set => base.OnPropertyChanged(ref this.resigned_at, value);
        }

        [DataMember(Name = "company_id")]
        public int? Company_Id
        {
            get => this.company_id;
            set => base.OnPropertyChanged(ref this.company_id, value);
        }

        [DataMember(Name = "company_name")]
        public string Company_Name
        {
            get => this.company_name;
            set => base.OnPropertyChanged(ref this.company_name, value);
        }

        [DataMember(Name = "department_id")]
        public int? Department_Id
        {
            get => this.department_id;
            set => base.OnPropertyChanged(ref this.department_id, value);
        }

        [DataMember(Name = "department_name")]
        public string Department_Name
        {
            get => this.department_name;
            set => base.OnPropertyChanged(ref this.department_name, value);
        }

        [DataMember(Name = "team_id")]
        public int? Team_Id
        {
            get => this.team_id;
            set => base.OnPropertyChanged(ref this.team_id, value);
        }

        [DataMember(Name = "team_name")]
        public string Team_Name
        {
            get => this.team_name;
            set => base.OnPropertyChanged(ref this.team_name, value);
        }

        [DataMember(Name = "rank_id")]
        public int? Rank_Id
        {
            get => this.rank_id;
            set => base.OnPropertyChanged(ref this.rank_id, value);
        }

        [DataMember(Name = "rank_name")]
        public string Rank_Name
        {
            get => this.rank_name;
            set => base.OnPropertyChanged(ref this.rank_name, value);
        }

        [DataMember(Name = "position_id")]
        public int? Position_Id
        {
            get => this.position_id;
            set => base.OnPropertyChanged(ref this.position_id, value);
        }

        [DataMember(Name = "position_name")]
        public string Position_Name
        {
            get => this.position_name;
            set => base.OnPropertyChanged(ref this.position_name, value);
        }

        [DataMember(Name = "role_id")]
        public int? Role_id
        {
            get => this.role_id;
            set => base.OnPropertyChanged(ref this.role_id, value);
        }

        [DataMember(Name = "role_name")]
        public string Role_Name
        {
            get => this.role_name;
            set => base.OnPropertyChanged(ref this.role_name, value);
        }

        [DataMember(Name = "privilege_id")]
        public int? Privilege_id
        {
            get => this.privilege_id;
            set => base.OnPropertyChanged(ref this.privilege_id, value);
        }

        [DataMember(Name = "privilege_name")]
        public string Privilege_Name
        {
            get => this.privilege_name;
            set => base.OnPropertyChanged(ref this.privilege_name, value);
        }

        [DataMember(Name = "login_id")]
        public string Login_Id
        {
            get => this.login_id;
            set => base.OnPropertyChanged(ref this.login_id, value);
        }

        [DataMember(Name = "login_pw")]
        public string Login_Pw
        {
            get => this.login_pw;
            set => base.OnPropertyChanged(ref this.login_pw, value);
        }

        /// <summary>
        /// 화면 회원가입 시 비밀번호 체크용
        /// </summary>
        public string Login_Pw_Check
        {
            get => this.login_pw_check;
            set => base.OnPropertyChanged(ref this.login_pw_check, value);
        }

        [DataMember(Name = "is_active")]
        public string Is_Active
        {
            get => this.is_active;
            set => base.OnPropertyChanged(ref this.is_active, value);
        }

        [DataMember(Name = "created_at")]
        public DateTime Created_At
        {
            get => this.created_at;
            set => base.OnPropertyChanged(ref this.created_at, value);
        }

        [DataMember(Name = "updated_at")]
        public DateTime Updated_Dt
        {
            get => this.updated_at;
            set => base.OnPropertyChanged(ref this.updated_at, value);
        }

        [DataMember(Name = "deleted_at")]
        public DateTime? Deleted_At
        {
            get => this.deleted_at;
            set => base.OnPropertyChanged(ref this.deleted_at, value);
        }

        private void OnSelect()
        {
            this.OnEmployeeSelect?.Invoke(this);
        }

        private void OnDelete()
        {
            this.OnEmployeeDelete?.Invoke(this);
        }
    }
}
