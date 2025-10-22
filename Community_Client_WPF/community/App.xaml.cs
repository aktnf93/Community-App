using community.Enums;
using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Diagnostics;
using System.Linq;
using System.Threading.Tasks;
using System.Windows;
using System.Windows.Controls;
using System.Windows.Interop;
using System.Windows.Media;
using System.Windows.Shapes;

namespace community
{
    /// <summary>
    /// App.xaml에 대한 상호 작용 논리
    /// </summary>
    public partial class App : Application
    {
        public App()
        {
            // DPI 인식 모드 설정 (WPF 에서는 기본적으로 PerMonitorV2 모드 사용)
            // System.Windows.Forms.Application.SetHighDpiMode(System.Windows.Forms.HighDpiMode.PerMonitorV2);

            // GPU 렌더링 티어 확인 (GPU 가속 사용 여부)
            // 0: 제한적
            // 1: 비활성화
            // 2: GPU 가속 활성화
            int tier = RenderCapability.Tier >> 16;
            Debug.WriteLine($"Render Tier: {tier}"); // 0, 1, 2 중 하나
        }

        protected override void OnStartup(StartupEventArgs e)
        {
            // RenderMode.SoftwareOnly: CPU 소프트웨어 렌더링 모드 사용
            // RenderMode.Default: 기본 GPU 렌더링 모드 사용

            // GPU 렌더링 활성화
            RenderOptions.ProcessRenderMode = RenderMode.Default;

            base.OnStartup(e);
        }

    }
}
