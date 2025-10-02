using community.View_Controls;
using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.IO;
using System.Linq;
using System.Net.Http;
using System.Security.Policy;
using System.Text;
using System.Threading.Tasks;
using System.Windows;
using System.Windows.Controls;
using System.Windows.Controls.Primitives;
using System.Windows.Data;
using System.Windows.Documents;
using System.Windows.Input;
using System.Windows.Media;
using System.Windows.Media.Imaging;
using System.Windows.Navigation;
using System.Windows.Shapes;
using System.Xml;
using static System.Net.Mime.MediaTypeNames;



namespace community.Views
{
    /// <summary>
    /// V_NewBoard.xaml에 대한 상호 작용 논리
    /// </summary>
    public partial class V_Board_Detail : UserControl
    {
        public V_Board_Detail()
        {
            InitializeComponent();
        }

        #region 이미지를 CTRL+V로 붙여넣기
        private void Editor_Paste_CanExecute(object sender, CanExecuteRoutedEventArgs e)
        {
            // 항상 붙여넣기 허용 (원하면 조건부로 변경)
            e.CanExecute = true;
            e.Handled = true;
        }

        private void Editor_Paste_Executed(object sender, ExecutedRoutedEventArgs e)
        {
            var rtb = sender as RichTextBox;
            if (rtb == null) return;

            // 1) RTF (Word에서 복사한 경우)
            if (Clipboard.ContainsText(TextDataFormat.Rtf))
            {
                string rtf = Clipboard.GetText(TextDataFormat.Rtf);
                if (!string.IsNullOrEmpty(rtf))
                {
                    var range = new TextRange(rtb.Selection.Start, rtb.Selection.End);
                    using (var ms = new MemoryStream(Encoding.UTF8.GetBytes(rtf)))
                    {
                        range.Load(ms, DataFormats.Rtf);
                    }
                    e.Handled = true;
                    return;
                }
            }

            // 2) 이미지 (캡처, 그림판 등)
            if (Clipboard.ContainsImage())
            {
                var bitmap = Clipboard.GetImage();
                var image = new System.Windows.Controls.Image
                {
                    Source = bitmap,
                    // Width = 300, // 원하는 크기로 조정
                    Width = 120,
                    Stretch = Stretch.Uniform
                };

                // 문서에 paragraph가 없으면 하나 만들어서 위치 보장
                if (rtb.CaretPosition.Paragraph == null)
                {
                    rtb.Document.Blocks.Add(new Paragraph());
                    rtb.CaretPosition = rtb.Document.ContentEnd;
                }

                new InlineUIContainer(image, rtb.CaretPosition);
                e.Handled = true;
                return;
            }

            // 3) 일반 텍스트
            if (Clipboard.ContainsText())
            {
                rtb.CaretPosition.InsertTextInRun(Clipboard.GetText());
                e.Handled = true;
                return;
            }

            // (필요하면 기본 동작으로 넘기려면 e.Handled = false)
            e.Handled = true;
        }
        #endregion

        private void MyRichTextBox_PreviewDragOver(object sender, DragEventArgs e)
        {
            // 드래그된 데이터가 파일 목록인지 확인
            bool isFile = e.Data.GetDataPresent(DataFormats.FileDrop);

            // 파일 목록이 있고, 이미지 파일이 포함되어 있는지 확인
            if (isFile)
            {
                string[] files = (string[])e.Data.GetData(DataFormats.FileDrop);
                string filePath = files[0];

                if (files != null && files.Length > 0 
                    && 
                    (IsImageFile(filePath) || IsSoundFile(filePath))
                    )
                {
                    e.Effects = DragDropEffects.Copy; // 커서를 복사 아이콘으로 변경
                }
                else
                {
                    e.Effects = DragDropEffects.None; // 다른 파일 형식은 드롭 금지
                }
            }
            else
            {
                e.Effects = DragDropEffects.None; // 파일이 아니면 드롭 금지
            }

            e.Handled = true; // 이벤트가 처리되었음을 알림
        }

        private MediaPlayer mediaPlayer = new MediaPlayer();

        private void MyRichTextBox_Drop(object sender, DragEventArgs e)
        {
            if (e.Data.GetDataPresent(DataFormats.FileDrop))
            {
                string[] files = (string[])e.Data.GetData(DataFormats.FileDrop);
                if (files != null && files.Length > 0)
                {
                    string filePath = files[0];
                    if (IsImageFile(filePath))
                    {
                        // 이미지 파일 확인
                        try
                        {
                            // 이미지 파일을 RichTextBox에 삽입
                            InsertImageIntoRichTextBox(filePath);
                        }
                        catch (Exception ex)
                        {
                            MessageBox.Show($"이미지를 삽입하는 중 오류가 발생했습니다: {ex.Message}");
                        }
                    }
                    else if (IsSoundFile(filePath))
                    {
                        // 사운드 파일 확인
                        try
                        {
                            // U_AudioPlayer 사용자 컨트롤을 사용하여 사운드 파일 삽입
                            U_AudioPlayer player = new U_AudioPlayer();

                            // ____________________________________________________________
                            byte[] fileBytes = File.ReadAllBytes(filePath); // 메모리에 올림
                            MemoryStream ms = new MemoryStream(fileBytes);

                            // string tempPath = System.IO.Path.Combine(System.IO.Path.GetTempPath(), System.IO.Path.GetFileName(filePath));
                            // File.WriteAllBytes(tempPath, fileBytes); // 임시 파일 생성
                            // 
                            // // 임시파일 삭제
                            // if (File.Exists(tempPath))
                            //     File.Delete(tempPath);

                            // 서버에 업로드 (예시 URL, 실제 서버 URL로 변경 필요)
                            // using var content = new MultipartFormDataContent();
                            // content.Add(new StreamContent(ms), "file", Path.GetFileName(droppedFilePath));
                            // 
                            // var response = await httpClient.PostAsync("https://server/upload", content);
                            // var url = await response.Content.ReadAsStringAsync(); // 서버 URL 반환

                            // 서버 URL을 AudioPlayer에 설정
                            // player.SetSource(url);            // AudioPlayer
                            // image.Source = new BitmapImage(new Uri(url));

                            // RichTextBox 내용을 XAML로 변환하여 서버에 업로드
                            // using (MemoryStream ms = new MemoryStream())
                            // {
                            //     TextRange tr = new TextRange(richTextBox.Document.ContentStart, richTextBox.Document.ContentEnd);
                            //     tr.Save(ms, DataFormats.XamlPackage); // 혹은 DataFormats.Xaml
                            //     xamlText = Encoding.UTF8.GetString(ms.ToArray());
                            // }

                            // ____________________________________________________________

                            player.SetSource(filePath);


                            TextPointer tp = Editor.CaretPosition;
                            InlineUIContainer container = new InlineUIContainer(player, tp);
                        }
                        catch (Exception ex)
                        {
                            MessageBox.Show($"사운드 파일을 재생하는 중 오류 발생: {ex.Message}");
                        }
                    }
                    else
                    {
                        MessageBox.Show("지원하지 않는 파일 형식입니다.");
                    }
                }
            }
        }

        private void InsertImageIntoRichTextBox(string filePath)
        {
            // 파일 경로를 사용하여 BitmapImage 생성
            BitmapImage bitmapImage = new BitmapImage(new Uri(filePath));

            // 이미지 컨트롤 생성 및 소스 설정
            var image = new System.Windows.Controls.Image
            {
                Width = 120,
                Source = bitmapImage,
                Stretch = Stretch.Uniform
            };

            // InlineUIContainer를 사용하여 이미지를 FlowDocument에 삽입
            InlineUIContainer container = new InlineUIContainer(image);

            // 현재 커서 위치에 이미지 삽입
            Editor.CaretPosition.Paragraph.Inlines.Add(container);
        }

        private bool IsImageFile(string filePath)
        {
            // 확장자로 이미지 파일 여부 판단
            string extension = System.IO.Path.GetExtension(filePath).ToLower();
            return extension == ".png" || extension == ".jpg" || extension == ".jpeg" || extension == ".gif" || extension == ".bmp";
        }

        private bool IsSoundFile(string filePath)
        {
            // 확장자로 사운드 파일 여부 판단
            string extension = System.IO.Path.GetExtension(filePath).ToLower();
            return extension == ".mp3" || extension == ".wav" || extension == ".wma";
        }
    }
}
