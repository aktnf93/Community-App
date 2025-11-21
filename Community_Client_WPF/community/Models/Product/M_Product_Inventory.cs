using System;
using System.Runtime.Serialization;
using community.Common;

namespace community.Models
{
    [DataContract]
    public class M_Product_Inventory : Notify
    {
        private int id;
        private int product_id;
        private int from_employee_id;
        private int to_employee_id;
        private string movement_type;
        private int movement_count;
        private string content;
        private DateTime created_at;
        private DateTime updated_at;

        [DataMember(Name = "id")]
        public int Id
        {
            get => this.id;
            set => base.OnPropertyChanged(ref this.id, value);
        }

        [DataMember(Name = "product_id")]
        public int Product_Id
        {
            get => this.product_id;
            set => base.OnPropertyChanged(ref this.product_id, value);
        }

        [DataMember(Name = "from_employee_id")]
        public int From_Employee_Id
        {
            get => this.from_employee_id;
            set => base.OnPropertyChanged(ref this.from_employee_id, value);
        }

        [DataMember(Name = "to_employee_id")]
        public int To_Employee_Id
        {
            get => this.to_employee_id;
            set => base.OnPropertyChanged(ref this.to_employee_id, value);
        }

        [DataMember(Name = "movement_type")]
        public string Movement_Type
        {
            get => this.movement_type;
            set => base.OnPropertyChanged(ref this.movement_type, value);
        }

        [DataMember(Name = "movement_count")]
        public int Movement_Count
        {
            get => this.movement_count;
            set => base.OnPropertyChanged(ref this.movement_count, value);
        }

        [DataMember(Name = "content")]
        public string Content
        {
            get => this.content;
            set => base.OnPropertyChanged(ref this.content, value);
        }

        [DataMember(Name = "created_at")]
        public DateTime Created_At
        {
            get => this.created_at;
            set => base.OnPropertyChanged(ref this.created_at, value);
        }

        [DataMember(Name = "updated_at")]
        public DateTime Updated_At
        {
            get => this.updated_at;
            set => base.OnPropertyChanged(ref this.updated_at, value);
        }
    }
}
