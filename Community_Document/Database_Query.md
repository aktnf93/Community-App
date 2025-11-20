

# 📌DB 내 목록 조회 (테이블, 뷰, 트리거, 프로시저)
```
SET @database_name = 'community';

SELECT 'TABLE' AS ObjectType, TABLE_NAME AS ObjectName 
FROM information_schema.TABLES 
WHERE TABLE_SCHEMA = @database_name AND TABLE_TYPE = 'BASE TABLE'

UNION ALL

SELECT 'VIEW', TABLE_NAME 
FROM information_schema.VIEWS 
WHERE TABLE_SCHEMA = @database_name

UNION ALL

SELECT 'TRIGGER', TRIGGER_NAME 
FROM information_schema.TRIGGERS 
WHERE TRIGGER_SCHEMA = @database_name

UNION ALL

SELECT 'PROCEDURE', ROUTINE_NAME 
FROM information_schema.ROUTINES 
WHERE ROUTINE_SCHEMA = @database_name AND ROUTINE_TYPE = 'PROCEDURE';
```



```

public partial class TripleSwitchControl : UserControl
{
    private int currentState = 0; // 0: 1번, 1: 2번, 2: 3번

    public TripleSwitchControl()
    {
        InitializeComponent();
        UpdateUI();
    }

    private void LayoutRoot_MouseLeftButtonUp(object sender, MouseButtonEventArgs e)
    {
        currentState = (currentState + 1) % 3;
        AnimateThumb(currentState);
        UpdateUI();
    }

    private void AnimateThumb(int state)
    {
        double toValue = state switch
        {
            0 => 0,
            1 => 65,
            2 => 130,
            _ => 0
        };

        var animation = new DoubleAnimation
        {
            To = toValue,
            Duration = TimeSpan.FromMilliseconds(200),
            EasingFunction = new QuadraticEase()
        };
        ThumbTransform.BeginAnimation(TranslateTransform.XProperty, animation);
    }

    private void UpdateUI()
    {
        switch (currentState)
        {
            case 0:
                SwitchBackground.Background = Brushes.DarkSlateBlue;
                StateText.Text = "1번";
                break;
            case 1:
                SwitchBackground.Background = Brushes.DarkGreen;
                StateText.Text = "2번";
                break;
            case 2:
                SwitchBackground.Background = Brushes.DarkRed;
                StateText.Text = "3번";
                break;
        }
    }
}

```