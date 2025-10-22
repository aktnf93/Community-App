using community.Common;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Runtime.Serialization;
using System.Text;
using System.Threading.Tasks;

namespace community.Models
{
    [DataContract]
    public class M_User : Notify
    {
        private int id;
        private string login_id = "Admin987";
        private string login_pw = "Admin987";
        private string nickname;
        private DateTime created_dt;
        private DateTime updated_dt;

        [DataMember(Name = "id")]
        public int Id
        {
            get => this.id;
            set => base.OnPropertyChanged(ref this.id, value);
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

        [DataMember(Name = "nickname")]
        public string Nickname
        {
            get => this.nickname;
            set => base.OnPropertyChanged(ref this.nickname, value);
        }

        [DataMember(Name = "created_dt")]
        public DateTime Created_Dt
        {
            get => this.created_dt;
            set => base.OnPropertyChanged(ref this.created_dt, value);
        }

        [DataMember(Name = "updated_dt")]
        public DateTime Updated_Dt
        {
            get => this.updated_dt;
            set => base.OnPropertyChanged(ref this.updated_dt, value);
        }
    }
}
