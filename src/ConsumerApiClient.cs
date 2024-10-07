using System.Collections.Generic;
using System.Net.Http;
using System.Threading.Tasks;
using System.Text.Json;

namespace Consumer
{
    public struct Product
    {
        public string id { get; set; }
        public string type { get; set; }
        public string name { get; set; }
    }

    public class ProductClient
    {
        #nullable enable
        public async Task<System.Collections.Generic.List<Product>> GetProducts(string baseUrl, HttpClient? httpClient = null)
        {
            using var client = httpClient == null ? new HttpClient() : httpClient;

            var response = await client.GetAsync(baseUrl + "/products");
            response.EnsureSuccessStatusCode();

            var resp = await response.Content.ReadAsStringAsync();

            return JsonSerializer.Deserialize<List<Product>>(resp);
        }
    }
}