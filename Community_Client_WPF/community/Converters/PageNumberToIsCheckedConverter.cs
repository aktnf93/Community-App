using System;
using System.Collections.Generic;
using System.Globalization;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Data;

namespace community.Converters
{
    /// <summary>
    /// 페이지 번호와 현재 페이지를 비교하여 RadioButton의 IsChecked를 결정하는 컨버터
    /// </summary>
    public class PageNumberToIsCheckedConverter : IValueConverter
    {
        // value: CurrentPage (int)
        // parameter: PageNumber (object, int로 변환)
        public object Convert(object value, Type targetType, object parameter, CultureInfo culture)
        {
            if (value == null || parameter == null)
                return false;

            int currentPage;
            int pageNumber;

            if (!int.TryParse(value.ToString(), out currentPage))
                return false;
            if (!int.TryParse(parameter.ToString(), out pageNumber))
                return false;

            return currentPage == pageNumber;
        }

        public object ConvertBack(object value, Type targetType, object parameter, CultureInfo culture)
        {
            // RadioButton이 체크되면 해당 페이지 번호를 반환
            if (value is bool isChecked && isChecked && parameter != null)
            {
                int pageNumber;
                if (int.TryParse(parameter.ToString(), out pageNumber))
                    return pageNumber;
            }
            return Binding.DoNothing;
        }
    }
}
