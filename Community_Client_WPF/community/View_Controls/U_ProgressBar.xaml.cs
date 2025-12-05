using System;
using System.Windows;
using System.Windows.Controls;

namespace community.View_Controls
{
    /// <summary>
    /// U_ProgressBar.xaml에 대한 상호 작용 논리
    /// </summary>
    public partial class U_ProgressBar : UserControl
    {
        public U_ProgressBar()
        {
            InitializeComponent();
            this.SizeChanged += UpdateProgress;

        }

        public static readonly DependencyProperty ValueProperty   = DependencyProperty.Register("Value", typeof(double), typeof(U_ProgressBar), new PropertyMetadata(0.0, OnValueChanged));
        public static readonly DependencyProperty MinimumProperty = DependencyProperty.Register("Minimum", typeof(double), typeof(U_ProgressBar), new PropertyMetadata(0.0, OnValueChanged));
        public static readonly DependencyProperty MaximumProperty = DependencyProperty.Register("Maximum", typeof(double), typeof(U_ProgressBar), new PropertyMetadata(0.0, OnValueChanged));

        public double Value
        {
            get => (double)GetValue(ValueProperty);
            set => SetValue(ValueProperty, value);
        }

        public double Minimum
        {
            get => (double)GetValue(MinimumProperty);
            set => SetValue(MinimumProperty, value);
        }

        public double Maximum
        {
            get => (double)GetValue(MaximumProperty);
            set => SetValue(MaximumProperty, value);
        }

        private static void OnValueChanged(DependencyObject d, DependencyPropertyChangedEventArgs e)
        {
            var control = d as U_ProgressBar;
            control?.UpdateProgress(null, null);
        }

        private void UpdateProgress(object sender, RoutedEventArgs e)
        {
            try
            {
                // 레이아웃 준비 안됐으면 반환
                // if (!IsLoaded) return;
                if (Root == null || Thumb == null || TrackFill == null) return;

                // 실제 너비가 유효한지 확인
                if (double.IsNaN(Root.ActualWidth) || Root.ActualWidth <= 0) return;
                if (double.IsNaN(Thumb.Width) || Thumb.Width <= 0) Thumb.Width = 25; // 기본값 가드

                // 값 클램프
                double min = Minimum;
                double max = Maximum;
                double val = Value;

                if (double.IsNaN(min)) min = 0;
                if (double.IsNaN(max) || max < min) max = min + 1; // 최소한의 범위 확보
                if (double.IsNaN(val)) val = min;

                val = Math.Max(min, Math.Min(max, val));

                // 분모 0 방지
                double range = max - min;
                double ratio = range == 0 ? 0 : (val - min) / range;

                // ratio 범위 보호
                if (double.IsNaN(ratio) || double.IsInfinity(ratio)) ratio = 0;
                ratio = Math.Max(0, Math.Min(1, ratio));

                // 계산
                double rootWidth = Root.ActualWidth;
                double thumbHalf = Thumb.Width / 2.0;

                // 이동 가능한 최대 X
                double maxThumbX = Math.Max(0, rootWidth - thumbHalf);

                // 25는 좌/우 패딩 또는 최소 여유라면 상수 대신 바인딩/속성화 권장
                double thumbX = (Math.Max(0, rootWidth - 25)) * ratio;

                // 상한 적용
                thumbX = Math.Min(thumbX, maxThumbX);
                thumbX = Math.Max(0, thumbX);

                // TrackFill 너비: 음수 방지
                double fillWidth = Math.Max(0, thumbX + thumbHalf);
                if (double.IsNaN(fillWidth) || double.IsInfinity(fillWidth)) fillWidth = 0;
                TrackFill.Width = fillWidth;

                // 썸 위치: Left margin만 사용, 음수 방지
                double left = Math.Max(0, thumbX - thumbHalf);
                Thumb.Margin = new Thickness(left, 0, 0, 0);
            }
            catch (Exception ex)
            {
                Console.WriteLine(ex);
            }
        }

    }
}
