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
    /// U_ProgressBar.xaml에 대한 상호 작용 논리
    /// </summary>
    public partial class U_ProgressBar : UserControl
    {
        public U_ProgressBar()
        {
            InitializeComponent();
            this.SizeChanged += UpdateProgress;

        }

        public static readonly DependencyProperty ValueProperty = DependencyProperty.Register("Value", typeof(double), typeof(U_ProgressBar), new PropertyMetadata(0.0, OnValueChanged));
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
                // 0~100 고정
                // double ratio = Value / 100.0;
                // 최소~최대 범위
                double ratio = (Value - Minimum) / (Maximum - Minimum);

                double maxThumbX = this.ActualWidth - Thumb.Width / 2;
                double thumbX = this.ActualWidth * ratio;

                if (thumbX > maxThumbX)
                    thumbX = maxThumbX;

                TrackFill.Width = thumbX + Thumb.Width / 2;
                Thumb.Margin = new Thickness(thumbX - Thumb.Width / 2, 0, 0, 0);
            }
            catch (Exception ex)
            {
                Console.WriteLine(ex.ToString());
            }
        }
    }
}
