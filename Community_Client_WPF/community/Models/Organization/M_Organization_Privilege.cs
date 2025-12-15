using System;
using System.Runtime.Serialization;
using community.Common;

namespace community.Models
{
    [DataContract]
    public class M_Organization_Privilege : Notify
    {
        private int id;
        private string name;
        private int auth_level;
        private string auth_post;
        private string auth_chat;
        private string auth_project;
        private string auth_customer;
        private string auth_product;
        private string auth_employee;
        private string auth_system;
        private string description;
        private DateTime created_at;
        private DateTime updated_at;

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

        [DataMember(Name = "auth_level")]
        public int Auth_Level
        {
            get => this.auth_level;
            set => base.OnPropertyChanged(ref this.auth_level, value);
        }

        [DataMember(Name = "auth_post")]
        public string Auth_Post
        {
            get => this.auth_post;
            set => base.OnPropertyChanged(ref this.auth_post, value);
        }

        [DataMember(Name = "auth_chat")]
        public string Auth_Chat
        {
            get => this.auth_chat;
            set => base.OnPropertyChanged(ref this.auth_chat, value);
        }

        [DataMember(Name = "auth_project")]
        public string Auth_Project
        {
            get => this.auth_project;
            set => base.OnPropertyChanged(ref this.auth_project, value);
        }

        [DataMember(Name = "auth_customer")]
        public string Auth_Customer
        {
            get => this.auth_customer;
            set => base.OnPropertyChanged(ref this.auth_customer, value);
        }

        [DataMember(Name = "auth_product")]
        public string Auth_Product
        {
            get => this.auth_product;
            set => base.OnPropertyChanged(ref this.auth_product, value);
        }

        [DataMember(Name = "auth_employee")]
        public string Auth_Employee
        {
            get => this.auth_employee;
            set => base.OnPropertyChanged(ref this.auth_employee, value);
        }

        [DataMember(Name = "auth_system")]
        public string Auth_System
        {
            get => this.auth_system;
            set => base.OnPropertyChanged(ref this.auth_system, value);
        }

        [DataMember(Name = "description")]
        public string Description
        {
            get => this.description;
            set => base.OnPropertyChanged(ref this.description, value);
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
