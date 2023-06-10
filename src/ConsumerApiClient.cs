using System;
using System.Collections.Generic;
using System.Collections.Immutable;
using System.Net.Http;
using System.Threading.Tasks;
using Newtonsoft.Json;

namespace Consumer
{
    public struct Product
    {
        public string id;
        public string type;
        public string name;
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

            return JsonConvert.DeserializeObject<List<Product>>(resp);
        }

        public async Task<System.Collections.Generic.List<Product>> GetProductById(string baseUrl,int id, HttpClient? httpClient = null)
        {
            using var client = httpClient == null ? new HttpClient() : httpClient;

            var response = await client.GetAsync(baseUrl + "/product/"+id);
           // response.EnsureSuccessStatusCode();
           
            var resp =await response.Content.ReadAsStringAsync();

            return JsonConvert.DeserializeObject<List<Product>>(resp);
        }
    }
}