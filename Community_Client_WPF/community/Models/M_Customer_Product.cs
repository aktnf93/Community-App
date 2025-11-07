using System;
using System.Runtime.Serialization;
using community.Common;

namespace community.Models
{
    [DataContract]
    public class M_Customer_Product : Notify
    {
        private int id;
        private int customer_id;
        private int product_id;
        private DateTime created_at;

        [DataMember(Name = "id")]
        public int Id
        {
            get => this.id;
            set => base.OnPropertyChanged(ref this.id, value);
        }

        [DataMember(Name = "customer_id")]
        public int Customer_Id
        {
            get => this.customer_id;
            set => base.OnPropertyChanged(ref this.customer_id, value);
        }

        [DataMember(Name = "product_id")]
        public int Product_Id
        {
            get => this.product_id;
            set => base.OnPropertyChanged(ref this.product_id, value);
        }

        [DataMember(Name = "created_at")]
        public DateTime Created_At
        {
            get => this.created_at;
            set => base.OnPropertyChanged(ref this.created_at, value);
        }
    }
}
