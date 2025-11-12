using System;
using System.Runtime.Serialization;
using community.Common;

namespace community.Models
{
    [DataContract]
    public class M_Post : Notify
    {
        private int id;
        private int post_category_id;
        private string post_category_name;
        private int employee_id;
        private string employee_name;
        private string title;
        private string content;
        private int view_count;
        private int comments;
        private DateTime? comment_at;
        private DateTime created_at;
        private DateTime updated_at;
        private DateTime? deleted_at;

        [DataMember(Name = "id")]
        public int Id
        {
            get => this.id;
            set => base.OnPropertyChanged(ref this.id, value);
        }

        [DataMember(Name = "post_category_id")]
        public int Post_Category_Id
        {
            get => this.post_category_id;
            set => base.OnPropertyChanged(ref this.post_category_id, value);
        }

        [DataMember(Name = "post_category_name")]
        public string Post_Category_Name
        {
            get => this.post_category_name;
            set => base.OnPropertyChanged(ref this.post_category_name, value);
        }

        [DataMember(Name = "employee_id")]
        public int Employee_Id
        {
            get => this.employee_id;
            set => base.OnPropertyChanged(ref this.employee_id, value);
        }

        [DataMember(Name = "employee_name")]
        public string Employee_Name
        {
            get => this.employee_name;
            set => base.OnPropertyChanged(ref this.employee_name, value);
        }

        [DataMember(Name = "title")]
        public string Title
        {
            get => this.title;
            set => base.OnPropertyChanged(ref this.title, value);
        }

        [DataMember(Name = "content")]
        public string Content
        {
            get => this.content;
            set => base.OnPropertyChanged(ref this.content, value);
        }

        [DataMember(Name = "view_count")]
        public int View_Count
        {
            get => this.view_count;
            set => base.OnPropertyChanged(ref this.view_count, value);
        }

        [DataMember(Name = "comments")]
        public int Comments
        {
            get => this.comments;
            set => base.OnPropertyChanged(ref this.comments, value);
        }

        [DataMember(Name = "comment_at")]
        public DateTime? Comment_At
        {
            get => this.comment_at;
            set => base.OnPropertyChanged(ref this.comment_at, value);
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

        [DataMember(Name = "deleted_at")]
        public DateTime? Deleted_At
        {
            get => this.deleted_at;
            set => base.OnPropertyChanged(ref this.deleted_at, value);
        }
    }
}
