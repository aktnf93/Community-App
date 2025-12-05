using community.Common;
using community.Models;
using community.Views;
using MySqlX.XDevAPI.Common;
using System;
using System.Collections.Generic;
using System.Collections.ObjectModel;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows;
using System.Windows.Media;

namespace community.ViewModels
{
    public class VM_Project : ViewModelBase
    {
        public ObservableCollection<M_Project> ProjectList { get; set; }
            = new ObservableCollection<M_Project>();

        private void Loaded()
        {
            Console.WriteLine("VM_Project Loaded");

            var projects = HTTP_Server.API.HttpSend<M_Project[]>("/project/list/select");
            this.ProjectRead(projects);

        }

        private void ProjectRead(M_Project[] projects)
        {
            this.ProjectList.Clear();
            if (projects != null)
            {
                foreach (var pro in projects)
                {
                    pro.UpdateMonth();

                    // Project Edit
                    pro.OnProjectEdit += (p) =>
                    {

                    };

                    // Project Delete
                    pro.OnProjectDelete += (p) =>
                    {
                        if(MessageBoxResult.Yes == MessageBox.Show("해당 프로젝트를 삭제 하시겠습니까?", "프로젝트 삭제",
                            MessageBoxButton.YesNo, MessageBoxImage.Question))
                        {
                            var req = new { id = p.Id };
                            var result = HTTP_Server.API.HttpSend<M_DB_Result>("/project/list/delete", HTTP_Server.Method.DELETE, req);

                            if (result != null && result.AffectedRows > 0)
                            {
                                // 삭제 성공
                            }
                            else
                            {
                                // 삭제 실패 or 삭제할 레코드가 없음
                            }

                            Loaded();
                        }
                    };

                    // Task Read
                    pro.OnProjectTaskShow += (p) =>
                    {
                        var req = new { project_id = pro.Id };
                        var tasks = HTTP_Server.API.HttpSend<M_Project_Task[]>("/project/task/select", HTTP_Server.Method.POST, req);
                        p.TaskList.Clear();

                        if (tasks != null)
                        {
                            foreach (var t in tasks)
                            {
                                t.UpdateMonth();
                                p.TaskList.Add(t);
                            }
                        }

                        if (p.TaskView == Visibility.Collapsed)
                        {
                            p.TaskView = Visibility.Visible;
                        }
                        else
                        {
                            p.TaskView = Visibility.Collapsed;
                        }
                    };

                    this.ProjectList.Add(pro);
                }
            }
        }

        private void BtnProjectAdd()
        {
            var v = new V_ProjectDetail();
            var detail = v.DataContext as VM_ProjectDetail;
            detail.OnClose += () =>
            {
                v.Close();
            };

            var result = v.ShowDialog();
            this.Loaded();
        }
    }
}
