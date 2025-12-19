using community.Common;
using community.Models;
using community.Views;
using System;
using System.Collections;
using System.Collections.Generic;
using System.Collections.ObjectModel;
using System.ComponentModel;
using System.Linq;
using System.Threading.Tasks;
using System.Windows.Data;

namespace community.ViewModels
{
    public class VM_Post : ViewModelBase
    {
        public class CodeComparer : IComparer
        {
            public int Compare(object x, object y)
            {
                var postX = x as M_Post;
                var postY = y as M_Post;

                int orderX = GetOrder(postX?.Post_Level);
                int orderY = GetOrder(postY?.Post_Level);

                return orderX.CompareTo(orderY);
            }

            private int GetOrder(int? code)
            {
                if (code == null) return int.MaxValue; // null은 맨 뒤

                switch (code)
                {
                    case 1: return 1;
                    // case 2: return 2;
                    // case 3: return 3;
                    // case 4: return 4;
                    default: return 1000 + code.Value;
                }
            }
        }


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

        public List<M_Post_Category> CategoryList { get; set; } = new List<M_Post_Category>();
        public ObservableCollection<M_Post_Category> CategoryTree { get; set; } = new ObservableCollection<M_Post_Category>();

        public M_Post_Category CategorySelected { get; set; } = null;

        public ObservableCollection<M_Post> PostList { get; set; } = new ObservableCollection<M_Post>();
        public ICollectionView PostView { get; set; }

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
            set => base.OnPropertyChanged(ref this._listTabIndex, value);
        }

        private async Task Loaded()
        {
            Console.WriteLine("VM_Posts Loaded");

            await LoadCategory();
        }

        private async Task LoadCategory()
        {
            await UiAction.Instance.ExecuteAsync(async () =>
            {
                this.CategoryList = await HTTP_Server.API.HttpSendAsync<List<M_Post_Category>>("/post/category/select", HTTP_Server.Method.POST, null);

                this.CategoryTree.Clear();
                if (this.CategoryList != null)
                {
                    var _categorys = BuildTree(this.CategoryList);

                    foreach (var c in _categorys)
                    {
                        this.CategoryTree.Add(c);
                    }
                }
            });

            if (this.CategoryTree.Count > 0)
                this.CategoryTree[0].IsSelected = true;
        }

        List<M_Post_Category> BuildTree(List<M_Post_Category> flatList)
        {
            var rootList = new List<M_Post_Category>();
            var lookup = flatList.ToDictionary(c => c.Id);

            for (int i = 0; i < flatList.Count; i++)
            {
                var category = flatList[i];

                category.SelectEvent += (c) =>
                {
                    this.TxtListSearch = string.Empty;
                    this.CategorySelected = c;

                    if (c.Id == 0)
                    {
                        this.SearchPosts(null);
                    }
                    else
                    {
                        var req = new { post_category_id = c.Id };
                        this.SearchPosts(req);
                    }
                };

                if (category.Parent_Id == null)
                {
                    rootList.Add(category);
                }
                else if (lookup.TryGetValue(category.Parent_Id.Value, out var parent))
                {
                    parent.SubTree.Add(category);
                }
            }

            return rootList;
        }

        /// <summary>
        /// 게시글 목록 조회
        /// </summary>
        /// <param name="req"></param>
        private void SearchPosts(object req)
        {
            var postList = HTTP_Server.API.HttpSend<List<M_Post>>("/post/list/select", HTTP_Server.Method.POST, req);
            this.PostList.Clear();
            if (postList != null)
            {
                foreach (var post in postList)
                {
                    post.SelectedEvent += (p) =>
                    {
                        this.WinPostShow(p);
                    };

                    this.PostList.Add(post);
                }
            }

            this.PostView = CollectionViewSource.GetDefaultView(this.PostList);
            if (this.PostView is ListCollectionView listView)
            {
                listView.CustomSort = new CodeComparer();
            }
            base.OnPropertyChanged(nameof(this.PostView));
        }

        /// <summary>
        /// 제목 or 본문 검색 > 게시글 목록 조회
        /// </summary>
        private void BtnListSearch()
        {
            int category        = this.CategorySelected.Id;
            string searchTxt    = this.TxtListSearch;
            string searchType   = this.CboListSearchSelected;
            var req = new Dictionary<string, object>();

            if (category != 0)
            {
                req.Add("post_category_id", category);
            }

            if (!string.IsNullOrEmpty(searchTxt))
            {
                if (searchType == "제목")
                {
                    req.Add("title", searchTxt);
                }
                else
                {
                    req.Add("content", searchTxt);
                }
            }

            this.SearchPosts(req);
        }

        private void BtnPostAdd()
        {
            var post = new M_Post();
            post.Post_Category_Id = CategorySelected.Id;
            this.WinPostShow(post);
        }

        private void WinPostShow(M_Post p)
        {
            var win = new V_PostDetail();

            var context = new VM_PostDetail();
            context.CurrentUser = base.CurrentUser;
            context.CategoryList = CollectionViewSource.GetDefaultView(this.CategoryList);
            context.CategoryList.Filter += (category) => (((M_Post_Category)category).Id != 0);
            context.CategoryList.Refresh();

            context.CategorySelected = this.CategorySelected;
            context.PostEdit = p;
            context.CommentEdit = new M_Post_Comment();
            context.OnSave += (vm) => win.Close();

            win.DataContext = context;
            win.ShowDialog();

            this.CategorySelected.IsSelected = true;
        }
    }
}
