using System;
using System.Runtime.CompilerServices;
using System.Threading;
using System.Threading.Tasks;
using System.Windows.Input;

namespace community.Common
{
    public class UiAction : Singleton<UiAction>
    {
        private int isActing = 0;

        protected UiAction() { }

        public async Task ExecuteAsync(Func<Task> function, [CallerMemberName] string caller = "")
        {
            // 재진입 방지
            if (Interlocked.Exchange(ref isActing, 1) == 1)
            {
                Console.WriteLine($"{DateTime.Now:HH:mm:ss}\tUiAction.Async\tAlready acting! > {caller}");
                return;
            }

            try
            {
                Mouse.OverrideCursor = Cursors.Wait; // UI 스레드에서 커서 변경
                await function(); // function은 UI 스레드가 아니라 호출한 스레드에서 실행
            }
            catch (Exception ex)
            {
                Console.WriteLine($"{DateTime.Now:HH:mm:ss}\tUiAction.Async\t{ex} > {caller}");
            }
            finally
            {
                Mouse.OverrideCursor = null; // 커서 복원
                Interlocked.Exchange(ref isActing, 0);
            }
        }
    }
}
