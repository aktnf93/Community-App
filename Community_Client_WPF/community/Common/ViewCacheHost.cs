using System;
using System.Collections.Generic;
using System.Windows;
using System.Windows.Controls;

namespace community.Common
{
    public class ViewCacheHost : ContentControl
    {
        private readonly Dictionary<Type, FrameworkElement> viewCache = new Dictionary<Type, FrameworkElement>();

        /// <summary>
        /// 
        /// </summary>
        /// <param name="oldContent"></param>
        /// <param name="newContent"></param>
        protected override void OnContentChanged(object oldContent, object newContent)
        {
            // 콘텐츠가 null인 경우 처리.
            if (newContent == null)
            {
                base.OnContentChanged(oldContent, null);
                return;
            }

            var vmType = newContent.GetType();

            // 뷰 캐시에서 조회.
            if (!this.viewCache.TryGetValue(vmType, out var view))
            {
                // 새로 생성.
                var dataTemplate = this.FindResource(new DataTemplateKey(vmType)) as DataTemplate;
                if (dataTemplate != null)
                {
                    // View 생성 및 DataContext 설정.
                    view = dataTemplate.LoadContent() as FrameworkElement;
                    if (view != null)
                    {
                        view.DataContext = newContent;
                        this.viewCache[vmType] = view; // 캐시에 저장.

                        // Console.WriteLine($"[ViewCacheHost] View=\"{view}\", DataContext=\"{view.DataContext}\"");

                        Console.Write($"[ViewCacheHost]\tNew\t\tView=\"");
                        Console.ForegroundColor = ConsoleColor.Green;
                        Console.Write(view.GetType().Name);
                        Console.ForegroundColor = ConsoleColor.Gray;
                        Console.Write($"\", DataContext=\"");
                        Console.ForegroundColor = ConsoleColor.Green;
                        Console.Write(view.DataContext.GetType().Name);
                        Console.ForegroundColor = ConsoleColor.Gray;
                        Console.WriteLine($"\"");
                    }
                }
            }
            else
            {
                // 재사용.
                view.DataContext = newContent;

                Console.Write($"[ViewCacheHost]\tRecycling\tView=\"");
                Console.ForegroundColor = ConsoleColor.Green;
                Console.Write(view.GetType().Name);
                Console.ForegroundColor = ConsoleColor.Gray;
                Console.Write($"\", DataContext=\"");
                Console.ForegroundColor = ConsoleColor.Green;
                Console.Write(view.DataContext.GetType().Name);
                Console.ForegroundColor = ConsoleColor.Gray;
                Console.WriteLine($"\"");
            }

            base.OnContentChanged(oldContent, view);
        }
    }

}
