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
            { 9, new VM_Test() }    // TEST
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

        public DateTime _CurrentDateTime;
        public DateTime CurrentDateTime
        {
            get => this._CurrentDateTime;
            set => base.OnPropertyChanged(ref _CurrentDateTime, value);
        }

        public VM_MainViewModel()
        {
            var login = this.viewModels[0] as VM_Login;
            login.LoginEvent += (loginUser) =>
            {
                CurrentUser = loginUser;

                foreach (var vm in viewModels)
                {
                    vm.Value.CurrentUser = loginUser;
                }

                MenuSelected = 1; // 로그인 시 Home 화면으로.
            };

            this.MenuSelected = 0; // 프로그램 초기 실행 시 Login 화면으로.

            Timer t = new Timer(1000);
            t.Elapsed += (sender, e) =>
            {
                App.Current.Dispatcher.Invoke(() =>
                {
                    this.CurrentDateTime = DateTime.Now;
                });
            };
            t.Start();
        }
    }
}
