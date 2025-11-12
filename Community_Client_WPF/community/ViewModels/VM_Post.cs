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

        public ObservableCollection<M_Post_Category> CategoryList { get; set; }
            = new ObservableCollection<M_Post_Category>();

        public ObservableCollection<M_Post> PostList { get; set; }
            = new ObservableCollection<M_Post>();

        private M_Post postSelected = null;
        public M_Post PostSelected
        {
            get => this.postSelected;
            set => base.OnPropertyChanged(ref this.postSelected, value);
        }

        public VM_Post()
        {

        }

        private void Loaded()
        {
            Console.WriteLine("VM_Board Loaded");

            // category
            var categorys = Server.API.HttpSend<M_Post_Category[]>("/post/category/select");
            this.CategoryList.Clear();

            if (categorys is null)
            {
                return;
            }

            this.CategoryList = new ObservableCollection<M_Post_Category>(BuildTree(categorys));
            base.OnPropertyChanged(nameof(CategoryList));

            if (this.CategoryList.Count > 0)
            {
                this.CategoryList[0].IsSelected = true;

                object obj = new { category_id = this.CategoryList[0].Id };
                var posts = Server.API.HttpSend<M_Post[]>("/post/list/select", Server.Method.POST, obj);
                this.PostList.Clear();
                foreach (var p in posts)
                {
                    this.PostList.Add(p);
                }
            }
        }

        private void CategorySelected(M_Post_Category category)
        {
            object obj = new { category_id = category.Id };
            var posts = Server.API.HttpSend<M_Post[]>("/post/list/select", Server.Method.POST, obj);
            this.PostList.Clear();
            foreach (var p in posts)
            {
                this.PostList.Add(p);
            }
        }

        private void AddPost()
        {
            M_Post post = new M_Post()
            {
                Employee_Id = CurrentUser.Id,
                Post_Category_Id = this.CategoryList[0].Id,
                Title = "새 글",
                Content = "본문"
            };
            M_DB_Result result = Server.API.HttpSend<M_DB_Result>("/post/list/insert", Server.Method.POST, post);

            if (result != null && result.InsertId > 0)
            {
                // ok
                this.PostList.Insert(0, post);
            }
            else
            {
                Console.WriteLine("error");
            }
        }

        List<M_Post_Category> BuildTree(M_Post_Category[] flatList)
        {
            var rootList = new List<M_Post_Category>();

            var lookup = flatList.ToDictionary(c => c.Id);

            foreach (var category in flatList)
            {
                category.Image_Path = "..\\Images\\menu_post_64px.png";

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
