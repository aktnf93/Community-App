using Newtonsoft.Json;
using System;
using System.IO;
using System.Net;
using System.Net.Http;
using System.Net.Http.Headers;
using System.Text;
using System.Threading.Tasks;


namespace community.Common
{
    public class HTTP_Server
    {
        public static HTTP_Server API { get; } = new HTTP_Server();

        public string BaseUrl => "http://localhost:12070";
        private readonly HttpClient httpClient;

        public enum Method
        {
            GET,
            POST,
            PUT,
            DELETE
        }

        private HTTP_Server()
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


        public T HttpSend<T>(string url, Method method = Method.POST, object data = null)
        {
            HttpStatusCode statusCode = HttpStatusCode.NotFound;

            try
            {
                return _HttpSend<T>(url, method, data, out statusCode);
            }
            catch (WebException web_ex)
            {
                string msg = string.Format("{0:HH:mm:ss}\t서버 접속 실패\t{1}\t{2}", DateTime.Now, statusCode, web_ex.Message);
                Console.WriteLine(msg);

                return default(T);
            }
            catch (Exception ex)
            {
                string msg = string.Format("{0:HH:mm:ss}\t서버 수신 실패\t{1}\t{2}", DateTime.Now, statusCode, ex);
                Console.WriteLine(msg);

                return default(T);
            }
        }

        private T _HttpSend<T>(string url, Method method, object data, out HttpStatusCode statusCode)
        {
            HttpRequestMessage req = new HttpRequestMessage();

            #region HTTP Header
            switch (method)
            {
                case Method.GET:    req.Method = HttpMethod.Get;    break;
                case Method.POST:   req.Method = HttpMethod.Post;   break;
                case Method.PUT:    req.Method = HttpMethod.Put;    break;
                case Method.DELETE: req.Method = HttpMethod.Delete; break;
            }

            req.RequestUri = new Uri(httpClient.BaseAddress, url);
            req.Headers.Add("authorization", "a620");
            req.Headers.Add("User-Agent", "ClientWPF");
            #endregion

            #region HTTP token/data
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


                Console.WriteLine("{0:HH:mm:ss}\t{1}\t{2}", DateTime.Now, url, json);
            }
            #endregion


            HttpResponseMessage res = httpClient.SendAsync(req).Result;

            statusCode = res.StatusCode;
            string body = res.Content.ReadAsStringAsync().Result;
            // Console.WriteLine($"code={statusCode}, body={body}");

            return JsonConvert.DeserializeObject<T>(body);
        }

        public async Task<T> HttpSendAsync<T>(string url, Method method, object data)
        {
            HttpRequestMessage req = new HttpRequestMessage();

            #region HTTP Header
            switch (method)
            {
                case Method.GET: req.Method = HttpMethod.Get; break;
                case Method.POST: req.Method = HttpMethod.Post; break;
                case Method.PUT: req.Method = HttpMethod.Put; break;
                case Method.DELETE: req.Method = HttpMethod.Delete; break;
            }

            req.RequestUri = new Uri(httpClient.BaseAddress, url);
            req.Headers.Add("authorization", "a620");
            req.Headers.Add("User-Agent", "ClientWPF");
            #endregion

            #region HTTP token/data
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


                Console.WriteLine("{0:HH:mm:ss}\t{1}\t{2}", DateTime.Now, url, json);
            }
            #endregion

            try
            {
                var res  = await httpClient.SendAsync(req);
                var status = res.StatusCode;
                var body = await res.Content.ReadAsStringAsync();
                // Console.WriteLine($"code={statusCode}, body={body}");

                return JsonConvert.DeserializeObject<T>(body);
            }
            catch (HttpRequestException req_ex)
            {
                // SocketException
                // WebSocketException
                // throw new Exception("서버 접속에 실패했습니다.", req_ex);
                Console.WriteLine($"{DateTime.Now:HH:mm:ss} 서버 접속에 실패했습니다.\n{req_ex}");
                return default(T);
            }
            catch (Exception ex)
            {
                Console.WriteLine($"{DateTime.Now:HH:mm:ss} 서버 수신에 실패했습니다.\n{ex}");
                // throw new Exception($"서버 수신 실패했습니다.", ex);
                return default(T);
            }
        }
    }
}