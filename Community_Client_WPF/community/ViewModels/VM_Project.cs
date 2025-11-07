using community.Common;
using community.Models;
using System;
using System.Collections.Generic;
using System.Collections.ObjectModel;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace community.ViewModels
{
    public class VM_Project : ViewModelBase
    {
        public ObservableCollection<M_Project> ProjectList { get; set; }
            = new ObservableCollection<M_Project>();

        private void Loaded()
        {
            Console.WriteLine("VM_Project Loaded");

            var result = Server.API.HttpSendAsync<M_Project[]>("/project/list/select");

            if (result != null)
            {
                this.ProjectList.Clear();
                foreach (var item in result)
                {
                    this.ProjectList.Add(item);
                }
            }
        }

        private void ProjectAdd()
        {
            var project = new M_Project()
            {
                Name = "New Project"
            };

            var result = Server.API.HttpSendAsync<M_Project, M_DB_Result>("/project/list/insert", Server.HttpMethod.POST, project);

            if (result != null)
            {
                if (result.InsertId.HasValue && result.InsertId.Value > 0)
                {
                    this.ProjectList.Add(project);
                }
            }
        }
    }
}
