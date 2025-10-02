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
    public class VM_Moard : Notify
    {
        public ObservableCollection<M_ComboItem<int>> SearchConditions { get; set; } = new ObservableCollection<M_ComboItem<int>>()
        {
            new M_ComboItem<int>() { Value = 0, Display = "전체" },
            new M_ComboItem<int>() { Value = 1, Display = "제목/내용" },
            new M_ComboItem<int>() { Value = 2, Display = "제목" },
            new M_ComboItem<int>() { Value = 3, Display = "내용" },
            new M_ComboItem<int>() { Value = 4, Display = "글쓴이" },
            new M_ComboItem<int>() { Value = 5, Display = "댓글" }
        };

        public M_ComboItem<int> SelectedSearchCondition { get; set; } = null;

        private string _searchText = string.Empty;
        public string SearchText
        {
            get => _searchText;
            set
            {
                if (_searchText != value)
                {
                    _searchText = value;
                    base.OnPropertyChanged(nameof(SearchText));
                    // // 검색어가 변경될 때마다 페이지를 1로 초기화하고 업데이트
                    // CurrentPage = 1;
                    // UpdatePage();
                }
            }
        }

        public int Login_User_Id { get; set; } = 0;

        private int _currentPage = 1;
        public int CurrentPage
        {
            get => _currentPage;
            set
            {
                if (_currentPage != value)
                {
                    _currentPage = value;
                    base.OnPropertyChanged(nameof(CurrentPage));
                    UpdatePage();
                }
            }
        }

        public int PageSize { get; } = 14;
        public int TotalPages => (int)Math.Ceiling((double)All_Board_Posts.Count / PageSize);

        public ObservableCollection<int> PageNumbers { get; set; } = new ObservableCollection<int>();

        public RelayCommand<int> GoToPageCommand { get; }
        // -------------------------------------------------------------


        public ObservableCollection<M_Board> All_Board_Posts { get; set; } = new ObservableCollection<M_Board>();

        public ObservableCollection<M_Board> Board_Posts { get; set; } = new ObservableCollection<M_Board>();


        public M_Board Board_New_Add { get; set; } = new M_Board();
        public RelayCommand NewBoardShow { get; set; }

        private Visibility newBoard = Visibility.Collapsed;
        private Visibility editBoard = Visibility.Collapsed;
        public Visibility NewBoard
        {
            get => this.newBoard;
            set => base.OnPropertyChanged(ref this.newBoard, value);
        }

        public Visibility EditBoard
        {
            get => this.editBoard;
            set => base.OnPropertyChanged(ref this.editBoard, value);
        }

        public VM_Moard()
        {
            this.Board_New_Add.BoardShowEvent += (e) => this.NewBoard = Visibility.Visible;
            this.Board_New_Add.BoardCloseEvent += () => this.NewBoard = Visibility.Collapsed;


            this.NewBoardShow = new RelayCommand(New_Board);

            this.GoToPageCommand = new RelayCommand<int>(page =>
            {
                if (page >= 1 && page <= TotalPages)
                    CurrentPage = page;
            });

            Home_LoadBoards();
        }

        /// <summary>
        /// 새 보드 열기
        /// </summary>
        private void New_Board()
        {
            // this.Board_New_Add = new M_Board();

            var b = this.Board_New_Add;
            b.Id = 0;
            b.User_Id = Login_User_Id;
            b.Nickname = string.Empty;
            b.Title = string.Empty;
            b.Content = string.Empty;
            b.Created_Dt = DateTime.Now;
            b.Updated_Dt = DateTime.Now;
            b.Comments = 0;
            b.Comment_List.Clear();
            b.New_Comment_Text = "";

            b.BoardNewCommitEvent -= New_Board_Commit;
            b.BoardNewCommitEvent += New_Board_Commit;

            b.Update_Show_Mode();

            // base.OnPropertyChanged(nameof(Board_New_Add));

            this.NewBoard = Visibility.Visible;
        }

        /// <summary>
        /// 새 보드 등록
        /// </summary>
        private void New_Board_Commit()
        {
            var b = this.Board_New_Add;
            Server_REST_API.Instance.Post_Insert_Board(b);
            this.NewBoard = Visibility.Collapsed;
            Home_LoadBoards();
        }

        /// <summary>
        /// 기존 보드 수정
        /// </summary>
        private void Edit_Board_Commit()
        {
            var b = this.Board_New_Add;
            Server_REST_API.Instance.Put_Update_Board(b);
            this.NewBoard = Visibility.Collapsed;
            Home_LoadBoards();
        }

        /// <summary>
        /// 보드 삭제
        /// </summary>
        private void Delete_Board_Commit(M_Board board)
        {
            var result = MessageBox.Show("정말로 삭제하시겠습니까?", "삭제 확인", MessageBoxButton.YesNo, MessageBoxImage.Warning);
            if (result == MessageBoxResult.No)
                return;

            Server_REST_API.Instance.Put_Delete_Board(board.Id);
            Home_LoadBoards();
        }


        /// <summary>
        /// 보드 편집 열기
        /// </summary>
        /// <param name="board"></param>
        private void Show_Board_Edit(M_Board board)
        {
            var edit = this.Board_New_Add;
            edit.Id = board.Id;
            edit.User_Id = board.User_Id;
            edit.Nickname = board.Nickname;
            edit.Title = board.Title;
            edit.Content = board.Content;
            edit.Created_Dt = board.Created_Dt;
            edit.Updated_Dt = board.Updated_Dt;
            edit.Comments = board.Comments;
            edit.Comment_List.Clear();
            edit.New_Comment_Text = "";
            var comments = Server_REST_API.Instance.GetComments(board.Id);
            foreach (var c in comments)
            {
                edit.Comment_List.Add(c);
            }


            edit.BoardEditCommitEvent -= Edit_Board_Commit;
            edit.BoardEditCommitEvent += Edit_Board_Commit;

            // 댓글달기
            edit.NewCommentCommitEvent -= New_Comment_Add;
            edit.NewCommentCommitEvent += New_Comment_Add;



            edit.Update_Show_Mode();

            this.NewBoard = Visibility.Visible;
        }

        /// <summary>
        /// 보드 댓글 등록
        /// </summary>
        /// <param name="b"></param>
        private void New_Comment_Add(M_Board b)
        {
            var comments = Server_REST_API.Instance.PostComment(b.Id, Login_User_Id, b.New_Comment_Text);
            b.New_Comment_Text = "";

            // var comments = Server_REST_API.Instance.GetComments(b.Id);
            b.Comment_List.Clear();
            foreach (var c in comments)
            {
                b.Comment_List.Add(c);
            }

            b.Comments = b.Comment_List.Count;

            var board_post = All_Board_Posts.FirstOrDefault(x => x.Id == b.Id);
            board_post.Comments = b.Comments;
        }

        // --------------------------------------------------------------------------------

        /// <summary>
        /// 모든 보드 불러오기
        /// </summary>
        private void Home_LoadBoards()
        {
            try
            {
                All_Board_Posts.Clear();
                var boards = Server_REST_API.Instance.GetBoards();

                foreach (var b in boards)
                {
                    // 보드 편집모드 열기
                    b.BoardShowEvent -= Show_Board_Edit;
                    b.BoardShowEvent += Show_Board_Edit;

                    // 보드 삭제
                    b.BoardDeleteCommitEvent -= Delete_Board_Commit;
                    b.BoardDeleteCommitEvent += Delete_Board_Commit;

                    All_Board_Posts.Add(b);
                }

                UpdatePage();
            }
            catch (Exception ex)
            {
                MessageBox.Show(ex.Message, "[0001] 오류");
            }
        }

        /// <summary>
        /// 보드 페이지 업데이트
        /// </summary>
        private void UpdatePage()
        {
            // UpdatePagedPosts
            Board_Posts.Clear();
            var paged = All_Board_Posts.Skip((CurrentPage - 1) * PageSize).Take(PageSize);
            foreach (var b in paged)
                Board_Posts.Add(b);

            OnPropertyChanged(nameof(TotalPages));

            // UpdatePageNumbers
            PageNumbers.Clear();
            if (TotalPages == 0)
                return;

            UpdatePageNumbers(CurrentPage, TotalPages);
        }

        public void UpdatePageNumbers(int currentPage, int totalPages)
        {
            PageNumbers.Clear();

            if (totalPages < 1)
                return;

            // 1. 최소 페이지
            PageNumbers.Add(1);
            // PageNumbers.Add(-1);

            // 2. -10 페이지 (조건: 1 < currentPage - 10)
            int minus10 = currentPage - 10;
            if (minus10 > 1)
            {
                // PageNumbers.Add(minus10);
                // PageNumbers.Add(-2);
            }

            // 3. 중심 페이지 5개 (±2 기준, 범위 조정)
            int start = Math.Max(2, currentPage - 2);
            int end = Math.Min(totalPages - 1, currentPage + 2);

            // 중심 범위가 5개보다 적으면 보정
            while (end - start + 1 < 5)
            {
                if (start > 2)
                    start--;
                else if (end < totalPages - 1)
                    end++;
                else
                    break;
            }

            for (int i = start; i <= end; i++)
            {
                if (i != 1 && i != totalPages) // 중복 방지
                    PageNumbers.Add(i);
            }

            // 4. +10 페이지 (조건: currentPage + 10 < totalPages)
            int plus10 = currentPage + 10;
            if (plus10 < totalPages)
            {
                // PageNumbers.Add(-3);
                // PageNumbers.Add(plus10);
            }

            // 5. 최대 페이지
            if (totalPages > 1)
            {
                // PageNumbers.Add(-1);
                PageNumbers.Add(totalPages);
            }
        }

        public void BoardSearch()
        {
            var condition = SelectedSearchCondition?.Value ?? 0;
            var text = SearchText?.Trim() ?? string.Empty;




            // IEnumerable<M_Board> filtered = All_Board_Posts;
            // if (!string.IsNullOrEmpty(text))
            // {
            //     switch (condition)
            //     {
            //         case 1: // 제목
            //             filtered = All_Board_Posts.Where(b => b.Title.Contains(text, StringComparison.OrdinalIgnoreCase));
            //             break;
            //         case 2: // 내용
            //             filtered = All_Board_Posts.Where(b => b.Content.Contains(text, StringComparison.OrdinalIgnoreCase));
            //             break;
            //         case 3: // 작성자
            //             filtered = All_Board_Posts.Where(b => b.Nickname.Contains(text, StringComparison.OrdinalIgnoreCase));
            //             break;
            //         default: // 전체
            //             filtered = All_Board_Posts.Where(b =>
            //                 b.Title.Contains(text, StringComparison.OrdinalIgnoreCase) ||
            //                 b.Content.Contains(text, StringComparison.OrdinalIgnoreCase) ||
            //                 b.Nickname.Contains(text, StringComparison.OrdinalIgnoreCase));
            //             break;
            //     }
            // }
            // All_Board_Posts.Clear();
            // foreach (var b in filtered)
            //     All_Board_Posts.Add(b);
            // CurrentPage = 1;
            // UpdatePage();
        }
    }
}
