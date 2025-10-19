using System;
using System.Windows;
using System.Windows.Controls;
using System.Windows.Media.Animation;

namespace community.View_Controls
{
    public class U_LinePoint_ProgressBar : ProgressBar
    {
        private FrameworkElement _trackFill;
        private FrameworkElement _thumb;

        public override void OnApplyTemplate()
        {
            base.OnApplyTemplate();

            _trackFill = GetTemplateChild("TrackFill") as FrameworkElement;
            _thumb = GetTemplateChild("Thumb") as FrameworkElement;

            SizeChanged += (sender, e) => AnimateTo(Value);

            AnimateTo(Value);
        }

        protected override void OnValueChanged(double oldValue, double newValue)
        {
            base.OnValueChanged(oldValue, newValue);
            AnimateTo(newValue);
        }

        // 프로그래스바 시각적 업데이트 (애니메이션 없이 즉시 반영)
        //private void UpdateVisual()
        //{
        //    if (_trackFill == null || _thumb == null || ActualWidth == 0 || Maximum == 0)
        //        return;

        //    // 0~100 고정
        //    // double ratio = Value / 100.0;
        //    // 최소~최대 범위
        //    double ratio = (Value - Minimum) / (Maximum - Minimum);

        //    double maxThumbX = ActualWidth - _thumb.Width / 2;
        //    double thumbX = ActualWidth * ratio;

        //    if (thumbX > maxThumbX)
        //        thumbX = maxThumbX;

        //    _trackFill.Width = thumbX + _thumb.Width / 2;
        //    _thumb.Margin = new Thickness(thumbX - _thumb.Width / 2, 0, 0, 0);
        //}

        // 프로그래스바 시각적 업데이트 (애니메이션 포함)
        private void AnimateTo(double targetValue)
        {
            if (_trackFill == null || _thumb == null || ActualWidth == 0 || Maximum == 0)
                return;

            // 비율 계산 (0~1)
            double ratio = (targetValue - Minimum) / (Maximum - Minimum);

            // Thumb이 짤리지 않도록 최대 위치 보정
            double maxThumbX = ActualWidth - (_thumb.Width / 2);
            double thumbX = ActualWidth * ratio;

            if (thumbX > maxThumbX)
                thumbX = maxThumbX;

            double trackWidth = thumbX + (_thumb.Width / 2);
            var easing = new QuadraticEase { EasingMode = EasingMode.EaseOut };

            // TrackFill 애니메이션
            var trackAnim = new DoubleAnimation
            {
                To = trackWidth,
                Duration = TimeSpan.FromSeconds(0.8),
                EasingFunction = easing
            };
            _trackFill.BeginAnimation(FrameworkElement.WidthProperty, trackAnim);

            // Thumb 위치 애니메이션
            var thumbAnim = new ThicknessAnimation
            {
                To = new Thickness(thumbX - (_thumb.Width / 2), 0, 0, 0),
                Duration = TimeSpan.FromSeconds(0.8),
                EasingFunction = easing
            };
            _thumb.BeginAnimation(FrameworkElement.MarginProperty, thumbAnim);
        }
    }
}
