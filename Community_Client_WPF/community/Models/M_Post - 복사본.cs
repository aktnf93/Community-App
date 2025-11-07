using community.Common;
using Mysqlx.Crud;
using System;
using System.Collections.Generic;
using System.Collections.ObjectModel;
using System.Linq;
using System.Runtime.Serialization;
using System.Text;
using System.Threading.Tasks;
using System.Windows;

namespace community.Models
{
    [DataContract]
    public class M_Post : Notify
    {
        public event NormalHandler<M_Post> BoardShowEvent;
        public event NormalHandler BoardCloseEvent;
        public event NormalHandler BoardNewCommitEvent;
        public event NormalHandler BoardEditCommitEvent;
        public event NormalHandler<M_Post> NewCommentCommitEvent;
        public event NormalHandler<M_Post> BoardDeleteCommitEvent;

        #region Binding Properties

        private int id;
        private int user_id;
        private string nickname;
        private string title;
        private string content;
        private DateTime created_dt;
        private DateTime updated_dt;
        private int comments;

        private string new_comment_text = "";


        [DataMember(Name = "id")]
        public int Id
        {
            get => this.id;
            set => base.OnPropertyChanged(ref this.id, value);
        }

        [DataMember(Name = "user_id")]
        public int User_Id
        {
            get => this.user_id;
            set => base.OnPropertyChanged(ref this.user_id, value);
        }

        [DataMember(Name = "nickname")]
        public string Nickname
        {
            get => this.nickname;
            set => base.OnPropertyChanged(ref this.nickname, value);
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

        [DataMember(Name = "create_dt")]
        public DateTime Created_Dt
        {
            get => this.created_dt;
            set => base.OnPropertyChanged(ref this.created_dt, value);
        }

        [DataMember(Name = "update_dt")]
        public DateTime Updated_Dt
        {
            get => this.updated_dt;
            set => base.OnPropertyChanged(ref this.updated_dt, value);
        }

        [DataMember(Name = "comments")]
        public int Comments
        {
            get => this.comments;
            set => base.OnPropertyChanged(ref this.comments, value);
        }

        public string New_Comment_Text
        {
            get => this.new_comment_text;
            set => base.OnPropertyChanged(ref this.new_comment_text, value);
        }

        public Visibility Show_Edit_Mode
        {
            get
            {
                if (this.Id != 0)
                    return Visibility.Visible;
                else
                    return Visibility.Collapsed;
            }
        }

        public Visibility Show_New_Mode
        {
            get
            {
                if (this.Id == 0)
                    return Visibility.Visible;
                else
                    return Visibility.Collapsed;
            }
        }


        public ObservableCollection<M_Comment> Comment_List { get; set; } = new ObservableCollection<M_Comment>();

        #endregion

        public void Update_Show_Mode()
        {
            base.OnPropertyChanged(nameof(Show_Edit_Mode));
            base.OnPropertyChanged(nameof(Show_New_Mode));
        }

        private void BoardShow()
        {
            this.BoardShowEvent?.Invoke(this);
        }

        private void BoardClose()
        {
            this.BoardCloseEvent?.Invoke();
        }

        private void BoardNewCommit()
        {
            this.BoardNewCommitEvent?.Invoke();
        }

        private void BoardEditCommit()
        {
            this.BoardEditCommitEvent?.Invoke();
        }

        private void NewCommentCommit()
        {
            this.NewCommentCommitEvent?.Invoke(this);
        }

        private void BoardDeleteCommit()
        {
            this.BoardDeleteCommitEvent?.Invoke(this);
        }
    }
}
