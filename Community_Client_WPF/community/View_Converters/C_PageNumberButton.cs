using System;
using System.Globalization;
using System.Windows.Data;

namespace community.View_Converters
{
    public class C_PageNumberButton : IMultiValueConverter
    {
        // values[0]: CurrentPage, values[1]: PageNumber
        public object Convert(object[] values, Type targetType, object parameter, CultureInfo culture)
        {
            if (values.Length < 2 || values[0] == null || values[1] == null)
                return false;

            int currentPage, pageNumber;
            if (int.TryParse(values[0].ToString(), out currentPage) && int.TryParse(values[1].ToString(), out pageNumber))
                return currentPage == pageNumber;

            return false;
        }

        public object[] ConvertBack(object value, Type[] targetTypes, object parameter, CultureInfo culture)
        {
            return null;
        }
    }
}
