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
using System.Windows.Threading;

namespace community.View_Controls
{
    /// <summary>
    /// U_AudioPlayer.xaml에 대한 상호 작용 논리
    /// </summary>
    public partial class U_AudioPlayer : UserControl
    {
        private bool isDragging = false;

        public U_AudioPlayer()
        {
            InitializeComponent();
            media.MediaOpened += Media_MediaOpened;
            media.MediaEnded += Media_MediaEnded;
        }

        public void SetSource(string path)
        {
            media.Source = new Uri(path);
        }

        private void Play_Click(object sender, RoutedEventArgs e)
        {
            media.Play();
        }

        private void Pause_Click(object sender, RoutedEventArgs e)
        {
            media.Pause();
        }

        private void Stop_Click(object sender, RoutedEventArgs e)
        {
            media.Stop();
        }

        private void Media_MediaOpened(object sender, RoutedEventArgs e)
        {
            progress.Maximum = media.NaturalDuration.TimeSpan.TotalSeconds;
            DispatcherTimer timer = new DispatcherTimer { Interval = TimeSpan.FromSeconds(1) };
            timer.Tick += (s, args) =>
            {
                if (!isDragging)
                    progress.Value = media.Position.TotalSeconds;
            };
            timer.Start();

            this.media_max.Text = media.NaturalDuration.TimeSpan.ToString(@"mm\:ss");
            this.media_min.Text = media.Position.ToString(@"mm\:ss");
        }

        private void Media_MediaEnded(object sender, RoutedEventArgs e)
        {
            media.Stop();
        }

        private void Progress_ValueChanged(object sender, RoutedPropertyChangedEventArgs<double> e)
        {
            if (isDragging)
                media.Position = TimeSpan.FromSeconds(progress.Value);

            this.media_max.Text = media.NaturalDuration.TimeSpan.ToString(@"mm\:ss");
            this.media_min.Text = media.Position.ToString(@"mm\:ss");
        }
    }
}
