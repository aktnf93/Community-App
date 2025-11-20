using System;
using System.Windows;
using System.Windows.Controls;

namespace community.Views
{
    /// <summary>
    /// V_Home.xaml에 대한 상호 작용 논리
    /// </summary>
    public partial class V_Home : UserControl
    {
        public V_Home()
        {
            InitializeComponent();
            WeatherWebView.Source = new Uri("https://weather.naver.com/");
            NewsWebView.Source = new Uri("https://news.naver.com/section/101");
        }
    }
}
