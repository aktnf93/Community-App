using Newtonsoft.Json;
using System;
using System.IO;
using System.Net;
using System.Net.Http;
using System.Net.Http.Headers;
using System.Security.Policy;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Media.Imaging;


namespace community.Common
{
    public class Server
    {
        public static Server API { get; } = new Server();

        public string BaseUrl => "http://localhost:12070/";
        private readonly HttpClient httpClient;

        public enum Method
        {
            // GET,
            POST,
            PUT,
            DELETE
        }

        private Server()
        {
            httpClient = new HttpClient()
            {
                BaseAddress = new Uri(BaseUrl)
            };
        }

        public string UploadImageSync(string filePath)
        {
            string serverPath = string.Empty;

            try
            {
                dynamic result = this.HttpSend<object>("/upload", Method.POST, filePath);
                serverPath = result.path;
                // 업로드 성공
                Console.WriteLine("이미지 업로드 성공: {0}", serverPath);
            }
            catch (Exception ex)
            {
                // 업로드 실패
                Console.WriteLine("이미지 업로드 실패: {0}", ex.Message);
            }

            return serverPath;
        }

        public J HttpSend<J>(string url, Method method = Method.POST, object data = null)
        {
            HttpRequestMessage req = new HttpRequestMessage();

            switch (method)
            {
                // case Method.GET: req.Method = HttpMethod.Get;    break;
                case Method.POST:   req.Method = HttpMethod.Post;   break;
                case Method.PUT:    req.Method = HttpMethod.Put;    break;
                case Method.DELETE: req.Method = HttpMethod.Delete; break;
                default: throw new ArgumentOutOfRangeException(nameof(method), "Invalid HTTP method");
            }

            req.RequestUri = new Uri(httpClient.BaseAddress, url);
            req.Headers.Add("authorization", "a620");
            req.Headers.Add("User-Agent", "ClientWPF");
            // req.Headers.Authorization = new AuthenticationHeaderValue("Bearer", token); // 인증 토큰 설정 (예: JWT 토큰)
            // req.Headers.Authorization = null; // 로그아웃 처리 (예: 토큰 삭제 등)

            if (data is string)
            {
                var filePath = data as string;
                var fileBytes = File.ReadAllBytes(filePath);
                var byteContent = new ByteArrayContent(fileBytes);
                byteContent.Headers.ContentType = new MediaTypeHeaderValue("image/jpeg");

                var form = new MultipartFormDataContent();
                form.Add(byteContent, "image", Path.GetFileName(filePath));
                req.Content = form;
            }
            else if (data != null)
            {
                string json = JsonConvert.SerializeObject(data);
                req.Content = new StringContent(json, Encoding.UTF8, "application/json");
            }

            return Send<J>(req);
        }

        private J Send<J>(HttpRequestMessage req)
        {
            try
            {
                HttpResponseMessage res = httpClient.SendAsync(req).Result;

                HttpStatusCode statusCode = res.StatusCode;
                string body = res.Content.ReadAsStringAsync().Result;
                // Console.WriteLine($"code={statusCode}, body={body}");

                // Json 문자열을 객체로 변환 (Newtonsoft.Json 사용)
                if (string.IsNullOrWhiteSpace(body))
                {
                    // throw new ArgumentException("json 문자열이 비어 있습니다.", nameof(body));
                    return default(J);
                }

                J result = JsonConvert.DeserializeObject<J>(body);

                return result;
            }
            catch (Exception jerr)
            {
                // Cannot deserialize the current JSON array: 배열을 단일 객체에 할당할 수 없음.
                // Null 값을 객체 멤버에 할당할 수 없음.
                // 객체 DataMember.Name의 이름과 json 문자열의 key 이름이 일치하지 않음.
                // throw new Exception("서버로 부터 수신한 데이터를 처리하지 못했습니다.");
                Console.WriteLine("서버로 부터 수신한 데이터를 처리하지 못했습니다: {0}", jerr.Message);

                return default(J);
            }
        }
    }
}