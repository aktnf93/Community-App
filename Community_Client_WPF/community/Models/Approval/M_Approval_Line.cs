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
    public class M_Approval_Line : Notify
    {
        private int id;
        private int approval_id;
        private int employee_id;
        private int step_order;
        private string status;
        private DateTime created_at;

        [DataMember(Name = "id")]
        public int Id
        {
            get => this.id;
            set => base.OnPropertyChanged(ref this.id, value);
        }
        
        [DataMember(Name = "approval_id")]
        public int Approval_Id
        {
            get => this.approval_id;
            set => base.OnPropertyChanged(ref this.approval_id, value);
        }

        [DataMember(Name = "employee_id")]
        public int Employee_Id
        {
            get => this.employee_id;
            set => base.OnPropertyChanged(ref this.employee_id, value);
        }

        [DataMember(Name = "step_order")]
        public int Step_Order
        {
            get => this.step_order;
            set => base.OnPropertyChanged(ref this.step_order, value);
        }

        [DataMember(Name = "status")]
        public string Status
        {
            get => this.status;
            set => base.OnPropertyChanged(ref this.status, value);
        }

        [DataMember(Name = "created_at")]
        public DateTime Created_At
        {
            get => this.created_at;
            set => base.OnPropertyChanged(ref this.created_at, value);
        }
    }
}
