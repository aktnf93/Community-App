using System;
using System.Runtime.Serialization;
using community.Common;

namespace community.Models
{
    [DataContract]
    public class M_Project_Task_Member : Notify
    {
        private int id;
        private int project_task_id;
        private int project_member_id;
        private DateTime created_at;

        [DataMember(Name = "id")]
        public int Id
        {
            get => this.id;
            set => base.OnPropertyChanged(ref this.id, value);
        }

        [DataMember(Name = "project_task_id")]
        public int Project_Task_Id
        {
            get => this.project_task_id;
            set => base.OnPropertyChanged(ref this.project_task_id, value);
        }

        [DataMember(Name = "project_member_id")]
        public int Project_Member_Id
        {
            get => this.project_member_id;
            set => base.OnPropertyChanged(ref this.project_member_id, value);
        }

        [DataMember(Name = "created_at")]
        public DateTime Created_At
        {
            get => this.created_at;
            set => base.OnPropertyChanged(ref this.created_at, value);
        }
    }
}
