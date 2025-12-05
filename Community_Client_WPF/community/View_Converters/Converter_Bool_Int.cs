using System;
using System.Globalization;
using System.Windows.Data;

namespace community.View_Converters
{
    public class Converter_Bool_Int : IValueConverter
    {
        // ViewModel(int) → View(bool)
        public object Convert(object value, Type targetType, object parameter, CultureInfo culture)
        {
            if (value is int intValue && parameter != null)
            {
                if (int.TryParse(parameter.ToString(), out int target))
                {
                    return intValue == target;
                }
            }
            return 0;
        }

        // View(bool) → ViewModel(int)
        public object ConvertBack(object value, Type targetType, object parameter, CultureInfo culture)
        {
            if (value is bool boolValue && parameter != null)
            {
                if (int.TryParse(parameter.ToString(), out int target))
                {
                    return boolValue ? target : Binding.DoNothing;
                }
            }
            return Binding.DoNothing;
        }
    }
}
