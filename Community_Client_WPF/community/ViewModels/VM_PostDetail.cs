using community.Common;
using community.Models;
using System;
using System.Collections.Generic;
using System.Collections.ObjectModel;
using System.ComponentModel;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows;

namespace community.ViewModels
{
    public class VM_PostDetail : Notify
    {
        public event ActionHandler<VM_PostDetail> OnSave;

        public M_Employee CurrentUser { get; set; }
        public ICollectionView CategoryList { get; set; }
        public M_Post_Category CategorySelected { get; set; }
        public M_Post PostEdit { get; set; }
        public M_Post_Comment CommentEdit { get; set; }

        public Dictionary<string, int?> PostLevelList { get; set; } = new Dictionary<string, int?>()
        {
            { "-", null },
            { "시스템 공지", 0 },
            { "게시판 전체 공지", 1 },
            { "게시판 그룹 공지", 2 },
            { "게시판 공지", 3 }
        };

        private async Task Loaded()
        {
            if (PostEdit.Id > 0)
            {
                await this.SearchPost();
            }


            await this.SearchComments(); // 댓글 조회
        }

        private async Task SearchPost()
        {
            var req = new { id = PostEdit.Id, view_count = 1 };
            var db_result = await HTTP_Server.API.HttpSendAsync<M_DB_Result>("/post/list/update", HTTP_Server.Method.PUT, req);
        }


        /// <summary>
        /// 게시글 저장
        /// </summary>
        private async Task BtnPostSave()
        {
            await UiAction.Instance.ExecuteAsync(async () =>
            {
                var user = this.CurrentUser;
                var category = this.CategorySelected;
                var post = this.PostEdit;

                if (post.Id == 0) // 새 게시글
                {
                    var req = new
                    {
                        post_category_id = post.Post_Category_Id,
                        employee_id = user.Id,
                        title = post.Title,
                        content = post.Content,
                        post_level = post.Post_Level
                    };

                    var result = await HTTP_Server.API.HttpSendAsync<M_DB_Result>("/post/list/insert", HTTP_Server.Method.POST, req);
                    if (result != null && result.InsertId > 0)
                    {
                    }
                }
                else // 기존 게시글 편집
                {
                    var req = new
                    {
                        id = post.Id,
                        post_category_id = post.Post_Category_Id,
                        employee_id = user.Id,
                        title = post.Title,
                        content = post.Content,
                        post_level = post.Post_Level
                    };

                    var result = await HTTP_Server.API.HttpSendAsync<M_DB_Result>("/post/list/update", HTTP_Server.Method.PUT, req);
                    if (result != null && result.InsertId > 0)
                    {
                    }
                }

                this.OnSave?.Invoke(this);
            });
        }

        /// <summary>
        /// 댓글 목록 조회
        /// </summary>
        private async Task SearchComments()
        {
            var post = this.PostEdit;

            var req = new { post_id = post.Id };
            var commentList = await HTTP_Server.API.HttpSendAsync<M_Post_Comment[]>("/post/comment/select", HTTP_Server.Method.POST, req);

            post.CommentList.Clear();
            if (commentList != null && commentList.Length > 0)
            {
                foreach (var comment in commentList)
                {
                    post.CommentList.Add(comment);
                }
            }
        }

        /// <summary>
        /// 댓글 추가 > 댓글 목록 조회
        /// </summary>
        private async Task BtnCommentSave()
        {
            await UiAction.Instance.ExecuteAsync(async () =>
            {
                var post = this.PostEdit;
                var user = this.CurrentUser;
                var cmt = this.CommentEdit;

                var req = new { post_id = post.Id, employee_id = user.Id, content = cmt.Content };
                M_DB_Result result = await HTTP_Server.API.HttpSendAsync<M_DB_Result>("/post/comment/insert", HTTP_Server.Method.POST, req);

                if (result != null && result.InsertId > 0)
                {
                    await this.SearchComments();
                }
            });
        }
    }
}
