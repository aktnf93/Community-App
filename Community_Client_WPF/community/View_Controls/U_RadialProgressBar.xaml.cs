using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows;
using System.Windows.Controls;
using System.Windows.Data;
using System.Windows.Documents;
using System.Windows.Input;
using System.Windows.Media;
using System.Windows.Media.Imaging;
using System.Windows.Navigation;
using System.Windows.Shapes;

namespace community.View_Controls
{
    /// <summary>
    /// U_RadialProgressBar.xaml에 대한 상호 작용 논리
    /// </summary>
    public partial class U_RadialProgressBar : UserControl
    {
        public U_RadialProgressBar()
        {
            InitializeComponent();
            SizeChanged += (_, __) => UpdateArc();
        }

        public static readonly DependencyProperty MinimumProperty =
            DependencyProperty.Register(nameof(Minimum), typeof(double), typeof(U_RadialProgressBar),
                new PropertyMetadata(0d, OnPropsChanged));

        public static readonly DependencyProperty MaximumProperty =
            DependencyProperty.Register(nameof(Maximum), typeof(double), typeof(U_RadialProgressBar),
                new PropertyMetadata(100d, OnPropsChanged));

        public static readonly DependencyProperty ValueProperty =
            DependencyProperty.Register(nameof(Value), typeof(double), typeof(U_RadialProgressBar),
                new PropertyMetadata(0d, OnPropsChanged));

        public static readonly DependencyProperty StrokeThicknessProperty =
            DependencyProperty.Register(nameof(StrokeThickness), typeof(double), typeof(U_RadialProgressBar),
                new PropertyMetadata(10d, OnPropsChanged));

        public static readonly DependencyProperty ProgressBrushProperty =
            DependencyProperty.Register(nameof(ProgressBrush), typeof(Brush), typeof(U_RadialProgressBar),
                new PropertyMetadata(new SolidColorBrush(Color.FromRgb(59, 130, 246)), OnPropsChanged)); // #3B82F6

        public static readonly DependencyProperty ProgressBackgroundProperty =
            DependencyProperty.Register(nameof(ProgressBackground), typeof(Brush), typeof(U_RadialProgressBar),
                new PropertyMetadata(new SolidColorBrush(Color.FromRgb(59, 130, 246)), OnPropsChanged)); // #3B82F6

        public double Minimum { get => (double)GetValue(MinimumProperty); set => SetValue(MinimumProperty, value); }
        public double Maximum { get => (double)GetValue(MaximumProperty); set => SetValue(MaximumProperty, value); }
        public double Value { get => (double)GetValue(ValueProperty); set => SetValue(ValueProperty, value); }
        public double StrokeThickness { get => (double)GetValue(StrokeThicknessProperty); set => SetValue(StrokeThicknessProperty, value); }
        public Brush ProgressBrush { get => (Brush)GetValue(ProgressBrushProperty); set => SetValue(ProgressBrushProperty, value); }
        public Brush ProgressBackground { get => (Brush)GetValue(ProgressBackgroundProperty); set => SetValue(ProgressBackgroundProperty, value); }

        private static void OnPropsChanged(DependencyObject d, DependencyPropertyChangedEventArgs e)
        {
            ((U_RadialProgressBar)d).UpdateArc();
        }

        private void UpdateArc()
        {
            double w = ActualWidth;
            double h = ActualHeight;
            if (w <= 0 || h <= 0) return;

            double radius = Math.Min(w, h) / 2 - StrokeThickness / 2;
            Point center = new Point(w / 2, h / 2);

            // 진행 각도 계산 (0~360)
            double clamped = Math.Max(Minimum, Math.Min(Value, Maximum));
            double pct = (clamped - Minimum) / (Maximum - Minimum);
            double angle = pct * 360.0;

            // 시작점: 위쪽(12시 방향)에서 시작
            Point start = PointOnCircle(center, radius, -90);
            Point end = PointOnCircle(center, radius, -90 + angle);

            // 큰 호 여부
            bool isLargeArc = angle > 180.0;

            // PathGeometry 구성
            var figure = new PathFigure { StartPoint = start, IsFilled = false, IsClosed = false };
            var arc = new ArcSegment
            {
                Point = end,
                Size = new Size(radius, radius),
                IsLargeArc = isLargeArc,
                SweepDirection = SweepDirection.Clockwise
            };
            figure.Segments.Clear();
            figure.Segments.Add(arc);

            var geometry = new PathGeometry();
            geometry.Figures.Add(figure);
            ProgressArc.Data = geometry;
        }

        private static Point PointOnCircle(Point center, double radius, double degrees)
        {
            double rad = degrees * Math.PI / 180.0;
            return new Point(center.X + radius * Math.Cos(rad),
                             center.Y + radius * Math.Sin(rad));
        }

    }
}
