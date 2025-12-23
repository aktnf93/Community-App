using community.Common;
using System;
using System.Collections.Generic;
using System.Timers;
using System.Windows;

namespace community.ViewModels
{
    public class VM_MainViewModel : ViewModelBase
    {
        private Dictionary<int, ViewModelBase> viewModels = new Dictionary<int, ViewModelBase>()
        {
            { 0, new VM_Login() }, // 로그인
            { 1, new VM_Home() }, // 홈
            { 2, new VM_Post() }, // 게시글
            { 3, new VM_Chat() }, // 채팅방
            { 4, new VM_Project() }, // 프로젝트 관리
            { 5, new VM_Customer() }, // 고객 관리
            { 6, new VM_Product() }, // 제품 관리
            { 7, new VM_Employee() }, // 직원 관리
            { 8, new VM_System() }, // 시스템
            { 9, new VM_Test() },    // TEST
            { 11, new VM_Schedule() },
            { 12, new VM_Approval() }
        };

        private ViewModelBase currentViewModel = null;
        private int menuSelected = 0;

        public ViewModelBase CurrentViewModel
        {
            get => this.currentViewModel;
            set => base.OnPropertyChanged(ref this.currentViewModel, value);
        }
        
        public int MenuSelected
        {
            get => this.menuSelected;
            set
            {
                base.OnPropertyChanged(ref this.menuSelected, value);

                if (viewModels.TryGetValue(value, out var vm))
                {
                    this.CurrentViewModel = vm;
                }
                else
                {
                    this.CurrentViewModel = null;
                    MessageBox.Show($"메뉴화면 코드 에러 \"{value}\"", "메뉴화면 에러", MessageBoxButton.OK, MessageBoxImage.Error);
                }
            }
        }

        public VM_MainViewModel()
        {
            EnvConfig.Load();


            this.MenuSelected = 0; // 프로그램 초기 실행 시 Login 화면으로.

            // 로그인 화면 이벤트 처리 __________________________________
            if (this.viewModels[0] is VM_Login v_login)
            {
                v_login.LoginEvent += async (loginUser) =>
                {
                    GD.Instance.LoginUser = loginUser;

                    await GD.Instance.LoadBaseCode();

                    CurrentUser = loginUser;

                    foreach (var vm in viewModels)
                    {
                        vm.Value.CurrentUser = loginUser;
                    }

                    MenuSelected = 1; // 로그인 시 Home 화면으로.
                };
            }

            // 홈 화면 이벤트 처리 __________________________________
            if (this.viewModels[1] is VM_Home v_home)
            {
                v_home.OnQuickView += (index) =>
                {
                    switch (index)
                    {
                        default:
                        case 0: // 게시글
                            var post_vm = this.viewModels[2] as VM_Post;
                            this.MenuSelected = 2;
                            break;

                        case 2: // 프로젝트
                            this.MenuSelected = 4;
                            break;

                    }
                };
            }

            Timer t = new Timer(1000);
            t.Elapsed += (sender, e) =>
            {
                if (App.Current != null)
                {
                    App.Current.Dispatcher.Invoke(() =>
                    {
                        if (currentViewModel is VM_Home h)
                            h.CurrentAt = DateTime.Now;
                    });
                }
            };
            t.Start();
        }
    }
}
