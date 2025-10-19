using community.Common;
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

            // this.Closing += (sender, e) =>
            // {
            //     Server_REST_API.Instance.Dispose();
            //     Application.Current.Shutdown();
            // };

            this.Closed += (sender, e) =>
            {
                Server_REST_API.Instance.Dispose();
                Application.Current.Shutdown();
            };
        }
    }
}
