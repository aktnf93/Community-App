using community.Common;
using Microsoft.Win32;
using System;
using System.Windows;
using System.Windows.Input;
using System.Windows.Media;

namespace community.Views
{
    /// <summary>
    /// V_MainWindow.xaml에 대한 상호 작용 논리
    /// </summary>
    public partial class V_MainWindow : Window
    {
        public V_MainWindow()
        {
            InitializeComponent();

            this.WindowState = WindowState.Maximized;

            // this.Closing += (sender, e) =>
            // {
            //     Server_REST_API.Instance.Dispose();
            //     Application.Current.Shutdown();
            // };

            this.Closed += (sender, e) =>
            {
                Application.Current.Shutdown();
            };

            // 최대화 시 작업표시줄을 가리지 않게 최대 사이즈 설정.
            // this.MaxWidth = SystemParameters.WorkArea.Width + 7;
            this.MaxHeight = SystemParameters.WorkArea.Height + 7;
            // MaxWidth = "1920" MaxHeight = "1040"
        }

        private bool isHandlingStateChange = false;
        private bool isMinimized = false;
        private bool isMaximized = false;
        private Rect normalSize;

        private void Window_OnStateChanged(object sender, EventArgs e)
        {
            if (isHandlingStateChange)
                return;

            isHandlingStateChange = true;

            try
            {
                if (this.WindowState == WindowState.Minimized)
                {
                    isMinimized = true;
                    return;
                }

                if (isMinimized)
                {
                    isMaximized = !isMaximized;
                    isMinimized = false;
                }

                if (isMaximized)
                {
                    // 복원
                    this.Top = normalSize.Top;
                    this.Left = normalSize.Left;
                    this.Width = normalSize.Width;
                    this.Height = normalSize.Height;

                    this.WindowState = WindowState.Normal;
                    isMaximized = false;
                }
                else
                {
                    // 최대화
                    normalSize = new Rect(this.Left, this.Top, this.Width, this.Height);
                    // Console.WriteLine("[StateChanged] 창 크기 백업 > {0}", normalSize.ToString());
                    var workArea = SystemParameters.WorkArea;

                    this.Top = workArea.Top;
                    this.Left = workArea.Left;
                    this.Width = workArea.Width;
                    this.Height = workArea.Height;

                    this.WindowState = WindowState.Normal;
                    isMaximized = true;
                }
            }
            finally
            {
                isHandlingStateChange = false;
            }

        }

        private void Window_OnSizeChanged(object sender, SizeChangedEventArgs e)
        {
            //double scaleX = e.NewSize.Width / 1920;
            //double scaleY = e.NewSize.Height / 1040;

            //RootScale.ScaleX = scaleX;
            //RootScale.ScaleY = scaleY;
            // ___________________________________________________________


            if (isHandlingStateChange)
                return;

            normalSize = new Rect(this.Left, this.Top, this.Width, this.Height);
            // Console.WriteLine("[SizeChanged] 창 크기 백업 > {0}", normalSize.ToString());
        }

        /// <summary>
        /// 타이틀바 드래그 시
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        private void Window_OnMove(object sender, MouseButtonEventArgs e)
        {
            // 최대화 상태에서 드래그 시 원래 크기로 변경
            if (isMaximized)
            {
                isHandlingStateChange = true;

                // 마우스 위치 (스크린 기준)
                var mousePos = PointToScreen(e.GetPosition(this));

                // 복원
                this.WindowState = WindowState.Normal;

                // 창 크기 복원
                this.Width = normalSize.Width;
                this.Height = normalSize.Height;

                // 화면 크기 (작업표시줄 제외)
                var workArea = SystemParameters.WorkArea;

                // 마우스 기준으로 창 가운데 정렬
                double targetLeft = mousePos.X - (this.Width / 2);
                double targetTop = mousePos.Y - 15; // 타이틀바 보정

                // 화면 경계 보정
                targetLeft = Math.Max(workArea.Left, Math.Min(targetLeft, workArea.Right - this.Width));
                targetTop = Math.Max(workArea.Top, Math.Min(targetTop, workArea.Bottom - this.Height));

                // 위치 적용
                this.Left = targetLeft;
                this.Top = targetTop;

                isMaximized = false;
                isHandlingStateChange = false;

                // 위치와 크기 적용 후 DragMove 실행
                this.Dispatcher.BeginInvoke(new Action(() =>
                {
                    try
                    {
                        this.DragMove();
                    }
                    catch (Exception ex)
                    {
                        Console.WriteLine("창 이동 오류 > {0}", ex.Message);

                        // MessageBox.Show(ex.Message, "창 이동 오류",
                        //     MessageBoxButton.OK, MessageBoxImage.Error);
                    }
                }), System.Windows.Threading.DispatcherPriority.ApplicationIdle);

            }
            else
            {
                this.DragMove();
            }
        }

        /// <summary>
        /// 타이틀바 더블클릭 시
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        private void Window_OnResize(object sender, MouseButtonEventArgs e)
        {
            if (e.ClickCount > 1)
            {
                Window_OnMaximize(null, null);
            }
        }

        private void Window_OnMinimize(object sender, RoutedEventArgs e)
        {
            this.WindowState = WindowState.Minimized;
        }

        private void Window_OnMaximize(object sender, RoutedEventArgs e)
        {
            // this.WindowState = (this.WindowState == WindowState.Maximized) ? WindowState.Normal : WindowState.Maximized;

            Window_OnStateChanged(null, null);
        }

        private void Window_OnClose(object sender, RoutedEventArgs e)
        {
            this.Close();
        }

        private void Button_Click(object sender, RoutedEventArgs e)
        {
            OpenFileDialog openFileDialog = new OpenFileDialog();
            openFileDialog.Title = "이미지 파일 선택";
            openFileDialog.Filter = "이미지 파일 (*.png;*.jpg;*.jpeg;*.bmp)|*.png;*.jpg;*.jpeg;*.bmp";

            if (openFileDialog.ShowDialog() == true)
            {
                string imagePath = openFileDialog.FileName;
                HTTP_Server.API.UploadImageSync(imagePath);

                // 예: 이미지 컨트롤에 표시
                // myImage.Source = new BitmapImage(new Uri(imagePath));
            }
        }
    }
}
