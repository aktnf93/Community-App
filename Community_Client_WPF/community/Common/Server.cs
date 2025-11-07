using System;
using System.Net;
using System.Net.Http;
using System.Text;
using Newtonsoft.Json;


namespace community.Common
{
    public class Server
    {
        public static Server API { get; } = new Server();

        private readonly HttpClient httpClient;

        private Server()
        {
            string baseUrl = "http://localhost:12070/";

            httpClient = new HttpClient()
            {
                BaseAddress = new Uri(baseUrl)
            };
        }

        public enum HttpMethod
        {
            // GET,
            POST,
            PUT,
            DELETE
        }

        public J HttpSendAsync<J>(string url)
        {
            HttpRequestMessage req = new HttpRequestMessage();
            req.Method = System.Net.Http.HttpMethod.Post;
            req.RequestUri = new Uri(httpClient.BaseAddress, url);
            req.Headers.Add("authorization", "a620");
            req.Headers.Add("User-Agent", "ClientWPF");
            // // 로그아웃 처리 (예: 토큰 삭제 등)
            // _httpClient.DefaultRequestHeaders.Authorization = null;
            // // 인증 토큰 설정 (예: JWT 토큰)
            // _httpClient.DefaultRequestHeaders.Authorization = new System.Net.Http.Headers.AuthenticationHeaderValue("Bearer", token);

            return SendAsync<J>(req);
        }

        /// <summary>
        /// HTTP 요청 전송
        /// </summary>
        /// <typeparam name="T">전송할 객체</typeparam>
        /// <typeparam name="J">응답받을 객체</typeparam>
        /// <param name="method">POST, PUT, DELETE</param>
        /// <param name="url">ex: "/user"</param>
        /// <param name="data">전송할 객체</param>
        /// <returns>응답받을 객체</returns>
        /// <exception cref="ArgumentOutOfRangeException"></exception>
        public J HttpSendAsync<T, J>(string url, HttpMethod method, T data)
        {
            // 객체를 Json 문자열로 변환 (Newtonsoft.Json 사용)
            if (data == null)
                throw new ArgumentNullException(nameof(data));

            string req_body_json = JsonConvert.SerializeObject(data);

            System.Net.Http.HttpMethod httpMethod = default;
            switch (method)
            {
                // case HttpMethod.GET:    httpMethod = System.Net.Http.HttpMethod.Get; break;
                case HttpMethod.POST:   httpMethod = System.Net.Http.HttpMethod.Post; break;
                case HttpMethod.PUT:    httpMethod = System.Net.Http.HttpMethod.Put; break;
                case HttpMethod.DELETE: httpMethod = System.Net.Http.HttpMethod.Delete; break;
                default: throw new ArgumentOutOfRangeException(nameof(method), "Invalid HTTP method");
            }

            HttpRequestMessage req = new HttpRequestMessage();
            req.Method = httpMethod;
            req.RequestUri = new Uri(httpClient.BaseAddress, url);
            req.Headers.Add("authorization", "a620");
            req.Headers.Add("User-Agent", "ClientWPF");
            req.Content = new StringContent(req_body_json, Encoding.UTF8, "application/json");
            // // 로그아웃 처리 (예: 토큰 삭제 등)
            // _httpClient.DefaultRequestHeaders.Authorization = null;
            // // 인증 토큰 설정 (예: JWT 토큰)
            // _httpClient.DefaultRequestHeaders.Authorization = new System.Net.Http.Headers.AuthenticationHeaderValue("Bearer", token);

            return SendAsync<J>(req);
        }

        private J SendAsync<J>(HttpRequestMessage req)
        {
            HttpResponseMessage res = httpClient.SendAsync(req).Result;

            HttpStatusCode statusCode = res.StatusCode;
            string body = res.Content.ReadAsStringAsync().Result;
            // Console.WriteLine($"code={statusCode}, body={body}");

            try
            {
                // Json 문자열을 객체로 변환 (Newtonsoft.Json 사용)
                if (string.IsNullOrWhiteSpace(body))
                    throw new ArgumentException("json 문자열이 비어 있습니다.", nameof(body));

                J result = JsonConvert.DeserializeObject<J>(body);

                return result;
            }
            catch (JsonSerializationException)
            {
                // 1. Cannot deserialize the current JSON array: 배열을 단일 객체에 할당할 수 없음.
                // Null 값을 객체 멤버에 할당할 수 없음.
                // 객체 DataMember.Name의 이름과 json 문자열의 key 이름이 일치하지 않음.
                throw new Exception("서버로 부터 수신한 데이터를 처리하지 못했습니다.");
            }
        }
    }
}