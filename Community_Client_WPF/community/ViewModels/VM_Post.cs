using community.Common;
using community.Models;
using System;
using System.Collections.Generic;
using System.Collections.ObjectModel;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows;

namespace community.ViewModels
{
    public class VM_Post : ViewModelBase
    {
        public M_Card BannerCard { get; set; } = new M_Card()
        {
            Title = "게시판"
        };

        public M_Card[] DashboardCard { get; set; } =
        {
            new M_Card() { Title = "전체 게시글", Content = "1260", Description = "오늘 10" },
            new M_Card() { Title = "전체 댓글", Content = "1092", Description = "오늘 3" },
            new M_Card() { Title = "전체 조회수", Content = "6103", Description = "오늘 16" },
            new M_Card() { Title = "", Content = "", Description = "" },
            new M_Card() { Title = "", Content = "", Description = "" },
        };

        private string _txtCategorySearch = string.Empty;
        public string TxtCategorySearch
        {
            get => this._txtCategorySearch;
            set => base.OnPropertyChanged(ref this._txtCategorySearch, value);
        }

        private string _txtListSearch = string.Empty;
        public string TxtListSearch
        {
            get => this._txtListSearch;
            set => base.OnPropertyChanged(ref this._txtListSearch, value);
        }

        public string[] CboListSearch { get; set; } = { "제목", "내용" };
        public string CboListSearchSelected { get; set; } = "제목";

        public ObservableCollection<M_Post_Category> CategoryList { get; set; } = new ObservableCollection<M_Post_Category>();

        public M_Post_Category CategorySelected { get; set; } = null;

        public ObservableCollection<M_Post> PostList { get; set; } = new ObservableCollection<M_Post>();

        private M_Post _postAdd = new M_Post();
        public M_Post PostAdd
        {
            get => this._postAdd;
            set => base.OnPropertyChanged(ref this._postAdd, value);
        }


        private M_Post _postSelected = null;
        public M_Post PostSelected
        {
            get => this._postSelected;
            set => base.OnPropertyChanged(ref this._postSelected, value);
        }

        private M_Post_Comment _commentAdd = null;
        public M_Post_Comment CommentAdd
        {
            get => this._commentAdd;
            set => base.OnPropertyChanged(ref this._commentAdd, value);
        }

        private int _listTabIndex = 0;
        public int ListTabIndex
        {
            get => this._listTabIndex;
            set
            {
                // Console.WriteLine("Tab Index: {0} > {1}", _listTabIndex, value);
                base.OnPropertyChanged(ref this._listTabIndex, value);
            }
        }

        public VM_Post()
        {

        }

        private void Loaded()
        {
            Console.WriteLine("VM_Board Loaded");

            // Category Load
            var categorys = HTTP_Server.API.HttpSend<M_Post_Category[]>("/post/category/select");
            this.CategoryList.Clear();

            if (categorys != null)
            {
                this.CategoryList = new ObservableCollection<M_Post_Category>(BuildTree(categorys));
                base.OnPropertyChanged(nameof(CategoryList));
            }

            // Post Load
            var posts = HTTP_Server.API.HttpSend<M_Post[]>("/post/list/select");
            this.PostList.Clear();
            if (posts != null)
            {
                foreach (var p in posts)
                {
                    p.SelectedEvent += (item) =>
                    {
                        this.PostSelected = item;
                        this.CommentAdd = new M_Post_Comment() { Post_Id = item.Id, Employee_Id = CurrentUser.Id };
                        this.ListTabIndex = 2;
                        BtnCommentSearch();
                    };

                    this.PostList.Add(p);
                }
            }
        }

        private void BtnCategorySearch()
        {
            var obj = new { name = this.TxtCategorySearch };
            var categorys = HTTP_Server.API.HttpSend<M_Post_Category[]>("/post/category/select", data: obj);
            this.CategoryList.Clear();

            if (categorys != null)
            {
                this.CategoryList = new ObservableCollection<M_Post_Category>(BuildTree(categorys));
                base.OnPropertyChanged(nameof(CategoryList));
            }
        }
        
        /// <summary>
        /// 카테고리 불러오거나 선택할 때.
        /// 게시글 추가하거나 수정할 때.
        /// </summary>
        private void Category_PostsBtnListSearch()
        {
            Dictionary<string, object> obj = new Dictionary<string, object>();
            obj.Add("post_category_id", this.CategorySelected.Id);

            var posts = HTTP_Server.API.HttpSend<M_Post[]>("/post/list/select", HTTP_Server.Method.POST, obj);
            this.PostList.Clear();
            if (posts != null)
            {
                foreach (var p in posts)
                {
                    p.SelectedEvent += (item) =>
                    {
                        this.PostSelected = item;
                        this.CommentAdd = new M_Post_Comment() { Post_Id = item.Id, Employee_Id = CurrentUser.Id };
                        this.ListTabIndex = 2;
                        BtnCommentSearch();
                    };

                    this.PostList.Add(p);
                }
            }
        }

        private void BtnListSearch()
        {
            Dictionary<string, object> obj = new Dictionary<string, object>();
            obj.Add("post_category_id", this.CategorySelected.Id);

            if (CboListSearchSelected == "제목")
            {
                if (!string.IsNullOrEmpty(this.TxtListSearch))
                {
                    obj.Add("title", this.TxtListSearch);
                }
            }
            else
            {
                if (!string.IsNullOrEmpty(this.TxtListSearch))
                {
                    obj.Add("content", this.TxtListSearch);
                }
            }



            var posts = HTTP_Server.API.HttpSend<M_Post[]>("/post/list/select", HTTP_Server.Method.POST, obj);
            this.PostList.Clear();
            if (posts != null)
            {
                foreach (var p in posts)
                {
                    p.SelectedEvent += (item) =>
                    {
                        this.PostSelected = item;
                        this.CommentAdd = new M_Post_Comment() { Post_Id = item.Id, Employee_Id = CurrentUser.Id };
                        this.ListTabIndex = 2;
                        BtnCommentSearch();
                    };

                    this.PostList.Add(p);
                }
            }
        }

        private void AddPost()
        {
            this.PostAdd.Post_Category_Id = this.CategorySelected.Id;
            this.PostAdd.Employee_Id = CurrentUser.Id;

            M_DB_Result result = HTTP_Server.API.HttpSend<M_DB_Result>("/post/list/insert", HTTP_Server.Method.POST, this.PostAdd);

            if (result != null && result.InsertId > 0)
            {
                this.PostAdd.Title = string.Empty;
                this.PostAdd.Content = string.Empty;

                Category_PostsBtnListSearch();
                ListTabIndex = 0;
            }
            else
            {
                Console.WriteLine("error");
            }
        }

        private void BtnPostEdit()
        {
            var p = this.PostSelected;

            if (p != null)
            {
                M_DB_Result result = HTTP_Server.API.HttpSend<M_DB_Result>("/post/list/update", HTTP_Server.Method.PUT, p);

                if (result != null && result.InsertId > 0)
                {
                    this.PostSelected = null;

                    Category_PostsBtnListSearch();
                    ListTabIndex = 0;
                }
                else
                {
                    Console.WriteLine("error");
                }
            }
        }

        private void BtnCommentSearch()
        {
            var p = this.PostSelected;

            if (p != null)
            {
                var obj = new { post_id = p.Id };
                var getComments = HTTP_Server.API.HttpSend<M_Post_Comment[]>("/post/comment/select", HTTP_Server.Method.POST, obj);

                p.CommentList.Clear();
                if (getComments != null && getComments.Length > 0)
                {
                    foreach (var comment in getComments)
                    {
                        p.CommentList.Add(comment);
                    }
                }
            }
        }

        private void BtnCommentAdd()
        {
            var p = this.PostSelected;

            if (p != null)
            {
                var obj = new { post_id = p.Id, employee_id = CurrentUser.Id, content = CommentAdd.Content };
                M_DB_Result result = HTTP_Server.API.HttpSend<M_DB_Result>("/post/comment/insert", HTTP_Server.Method.POST, obj);

                if (result != null && result.InsertId > 0)
                {
                    BtnCommentSearch();
                }
            }
        }

        List<M_Post_Category> BuildTree(M_Post_Category[] flatList)
        {
            var rootList = new List<M_Post_Category>();
            var lookup = flatList.ToDictionary(c => c.Id);

            for (int i = 0; i < flatList.Length; i++)
            {
                var category = flatList[i];
                
                category.Image_Path = "..\\Images\\menu_post_64px.png";
                category.SelectEvent += (item) =>
                {
                    this.TxtListSearch = string.Empty;
                    this.CategorySelected = item;
                    this.Category_PostsBtnListSearch();
                };

                if (category.Parent_Id == null)
                {
                    rootList.Add(category);
                }
                else if (lookup.TryGetValue(category.Parent_Id.Value, out var parent))
                {
                    parent.SubCategory.Add(category);
                }
            }

            return rootList;
        }
    }
}
