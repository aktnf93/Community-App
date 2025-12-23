using community.Common;
using community.Models;
using System;
using System.Collections.Generic;
using System.Collections.ObjectModel;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows;

namespace community.ViewModels
{
    public class VM_ApprovalDetail
    {
        public ObservableCollection<M_Approval_Line> CurrentApprovalLines { get; set; } = new ObservableCollection<M_Approval_Line>();
        public M_Approval CurrentApproval { get; set; } = new M_Approval();
        public M_Approval_Vacation CurrentVacation { get; set; } = new M_Approval_Vacation();
        public M_Employee CurrentEmployee { get; set; }

        public VM_ApprovalDetail()
        {
        }

        private async Task BtnApprovalSave()
        {
            await UiAction.Instance.ExecuteAsync(async () =>
            {
                if (this.CurrentApproval.Type == "휴가")
                {
                    var db_result = await HTTP_Server.API.HttpSendAsync<M_DB_Result>("/approval/insert", HTTP_Server.Method.POST, CurrentApproval);

                    if (db_result is null)
                    {
                        // 실패
                        MessageBox.Show("결재 문서 저장 실패");
                    }
                    else
                    {
                        // 성공

                        MessageBox.Show($"결재 문서 저장 성공\n {db_result.Info}, {db_result.InsertId}");


                        CurrentVacation.Approval_Id = db_result.InsertId.Value;
                        db_result = await HTTP_Server.API.HttpSendAsync<M_DB_Result>("insert", HTTP_Server.Method.POST, CurrentVacation);
                    }
                }

                if (this.CurrentApproval.Type == "지출")
                {

                }
            });
        }
    }
}
