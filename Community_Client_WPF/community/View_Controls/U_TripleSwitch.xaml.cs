using System;
using System.Windows.Controls;
using System.Windows.Input;
using System.Windows.Media;
using System.Windows.Media.Animation;

namespace community.View_Controls
{
    /// <summary>
    /// U_TripleSwitch.xaml에 대한 상호 작용 논리
    /// </summary>
    public partial class U_TripleSwitch : UserControl
    {
        private int currentState = 0; // 0: 1번, 1: 2번, 2: 3번

        public U_TripleSwitch()
        {
            InitializeComponent();
            UpdateUI();
        }

        private void LayoutRoot_MouseLeftButtonUp(object sender, MouseButtonEventArgs e)
        {
            currentState = (currentState + 1) % 3;
            AnimateThumb(currentState);
            UpdateUI();
        }

        private void AnimateThumb(int state)
        {
            double toValue = 0;

            switch (state)
            {
                case 0:
                    toValue = 0;
                    break;

                case 1:
                    toValue = 65;
                    break;

                case 2:
                    toValue = 130;
                    break;

                default:
                    toValue = 0;
                    break;
            }

            var animation = new DoubleAnimation
            {
                To = toValue,
                Duration = TimeSpan.FromMilliseconds(200),
                EasingFunction = new QuadraticEase()
            };
            ThumbTransform.BeginAnimation(TranslateTransform.XProperty, animation);
        }

        private void UpdateUI()
        {
            switch (currentState)
            {
                case 0:
                    SwitchBackground.Background = Brushes.DarkSlateBlue;
                    StateText.Text = "1번";
                    break;
                case 1:
                    SwitchBackground.Background = Brushes.DarkGreen;
                    StateText.Text = "2번";
                    break;
                case 2:
                    SwitchBackground.Background = Brushes.DarkRed;
                    StateText.Text = "3번";
                    break;
            }
        }
    }
}
