using community.Common;
using community.Models;
using community.Views;
using System;
using System.Collections.Generic;
using System.Collections.ObjectModel;
using System.ComponentModel;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Data;

namespace community.ViewModels
{
    public class VM_Approval : ViewModelBase
    {

        public ObservableCollection<M_Approval> ApprovalList { get; set; } = new ObservableCollection<M_Approval>();
        public ICollectionView ApprovalView { get; set; }
        private string txtApprovalSearch = string.Empty;
        public string TextApprovalSearch
        {
            get => this.txtApprovalSearch;
            set => base.OnPropertyChanged(ref this.txtApprovalSearch, value);
        }

        private async Task Loaded()
        {
            this.ApprovalView = CollectionViewSource.GetDefaultView(this.ApprovalList);

            await this.ApprovalLoad();
        }

        private async Task ApprovalLoad()
        {
            await UiAction.Instance.ExecuteAsync(async () =>
            {
                this.ApprovalList.Clear();
                
                var req = new { };
                var approvals = await HTTP_Server.API.HttpSendAsync<M_Approval[]>("/approval/select", HTTP_Server.Method.POST, req);
                if (approvals != null)
                {
                    foreach (var a in approvals)
                    {
                        this.ApprovalList.Add(a);
                    }
                }

                this.ApprovalView.Refresh();
            });
        }

        private async Task BtnApprovalSearch()
        {
            string txt = this.TextApprovalSearch;


            this.ApprovalView.Filter = (a) =>
            {
                if (a is M_Approval approval)
                {

                }

                return true;
            };

            this.ApprovalView.Refresh();
        }

        private async Task BtnApprovalSelect()
        {

        }

        private async Task BtnApprovalAdd()
        {
            var approval_add = new V_ApprovalDetail();

            var context = approval_add.DataContext as VM_ApprovalDetail;
            context.CurrentApproval.Type = "휴가";
            context.CurrentApproval.Status = "대기";

            approval_add.ShowDialog();

            await UiAction.Instance.ExecuteAsync(async () =>
            {
            });

            // 창 호출
        }

        private async Task ApprovalEdit()
        {
            await UiAction.Instance.ExecuteAsync(async () =>
            {

            });

            // 창 호출
        }

        private async Task ApprovalDelete()
        {
            await UiAction.Instance.ExecuteAsync(async () =>
            {

            });
        }
    }
}
