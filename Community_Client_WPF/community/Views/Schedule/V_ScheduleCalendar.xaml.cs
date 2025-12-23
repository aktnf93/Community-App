using System;
using System.Linq;
using System.Windows;
using System.Windows.Controls;
using System.Windows.Controls.Primitives;
using community.Models;
using community.ViewModels;

namespace community.Views
{
    /// <summary>
    /// V_ScheduleCalendar.xaml에 대한 상호 작용 논리
    /// </summary>
    public partial class V_ScheduleCalendar : UserControl
    {
        public V_ScheduleCalendar()
        {
            InitializeComponent();
        }

        private void DayButton_Loaded(object sender, RoutedEventArgs e)
        {
            if (this.DataContext is VM_Schedule vm)
            {
                vm.OnScheduleViewChanged += () =>
                {
                    try
                    {
                        if (sender is CalendarDayButton dayButton)
                        {
                            DateTime? date = null;

                            if (dayButton.DataContext is DateTime)
                            {
                                date = ((DateTime)dayButton.DataContext).Date;
                            }

                            if (dayButton.DataContext is M_DaySchedule)
                            {
                                date = ((M_DaySchedule)dayButton.DataContext).Date.Date;
                            }

                            if (date.HasValue)
                            {
                                var daySchedule = vm.ScheduleView.FirstOrDefault(d => d.Date.Date == date.Value);
                                if (daySchedule != null)
                                {
                                    if (DateTime.Now.Date == date.Value)
                                    {
                                        daySchedule.IsToday = true;
                                        daySchedule.Alias = "오늘";
                                    }
                                    else
                                    {
                                        daySchedule.IsToday = false;
                                        daySchedule.Alias = "";
                                    }

                                    dayButton.DataContext = daySchedule;
                                }
                                else
                                {
                                    Console.WriteLine("OnScheduleViewChanged > daySchedule 가 없다.");
                                }
                            }
                            else
                            {
                                Console.WriteLine("OnScheduleViewChanged > dayButton.DataContext는 {0}", dayButton.DataContext);
                            }
                        }
                        else
                        {
                            Console.WriteLine("OnScheduleViewChanged > sender는 {0}, {1}", sender, sender.GetType());
                        }
                    }
                    catch (Exception ex)
                    {
                        Console.WriteLine("OnScheduleViewChanged > {0}", ex.Message);
                    }
                };
            }
        }
    }
}
