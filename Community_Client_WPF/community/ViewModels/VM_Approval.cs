using community.Common;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace community.ViewModels
{
    public class VM_Approval : ViewModelBase
    {
        private async Task Loaded()
        {

        }

        private async Task ApprovalSearch()
        {
            await UiAction.Instance.ExecuteAsync(async () =>
            {
                var req = new { };
                var approval_list = await HTTP_Server.API.HttpSendAsync<object>("", HTTP_Server.Method.POST, req);
                if (approval_list != null)
                {

                }
            });
        }

        private async Task ApprovalAdd()
        {
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
