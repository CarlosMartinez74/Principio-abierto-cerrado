using System;
using System.Net.Http;
using System.Threading.Tasks;

// Interfaz para la petición HTTP (permite cambiar la implementación sin modificar la clase principal)
public interface IHttpClientWrapper
{
    Task<string> GetAsync(string url);
}

// Implementación de HttpClientWrapper usando HttpClient
public class HttpClientWrapper : IHttpClientWrapper
{
    private static readonly HttpClient client = new HttpClient();

    public async Task<string> GetAsync(string url)
    {
        HttpResponseMessage response = await client.GetAsync(url);
        return response.IsSuccessStatusCode ? await response.Content.ReadAsStringAsync() : string.Empty;
    }
}

// Clase principal desacoplada del cliente HTTP
public class TodoService
{
    private readonly IHttpClientWrapper httpClient;

    public TodoService(IHttpClientWrapper httpClient)
    {
        this.httpClient = httpClient;
    }

    public async Task RequestTodoItems()
    {
        string url = "https://jsonplaceholder.typicode.com/todos/";
        string data = await httpClient.GetAsync(url);
        Console.WriteLine(data);
    }
}

class Program
{
    static async Task Main()
    {
        IHttpClientWrapper client = new HttpClientWrapper();
        TodoService service = new TodoService(client);
        await service.RequestTodoItems();
    }
}
