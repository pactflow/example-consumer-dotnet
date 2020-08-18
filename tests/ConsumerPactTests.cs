using System;
using Xunit;
using PactNet.Mocks.MockHttpService;
using PactNet.Mocks.MockHttpService.Models;
using Consumer;
using System.Collections.Generic;
using PactNet.Matchers.Type;
using FluentAssertions;

namespace tests
{
    public class ConsumerPactTests : IClassFixture<ConsumerPactClassFixture>
    {
        private IMockProviderService _mockProviderService;
        private string _mockProviderServiceBaseUri;

        public ConsumerPactTests(ConsumerPactClassFixture fixture)
        {
            _mockProviderService = fixture.MockProviderService;
            _mockProviderService.ClearInteractions(); //NOTE: Clears any previously registered interactions before the test is run
            _mockProviderServiceBaseUri = fixture.MockProviderServiceBaseUri;
        }

        [Fact]
        public async void RetrieveProducts()
        {
            // Arrange
            _mockProviderService.Given("There are products")
                                .UponReceiving("A request to get products")
                                .With(new ProviderServiceRequest
                                {
                                    Method = HttpVerb.Get,
                                    Path = "/products",
                                })
                                .WillRespondWith(new ProviderServiceResponse {
                                    Status = 200,
                                    Headers = new Dictionary<string, object>
                                    {
                                        { "Content-Type", "application/json; charset=utf-8" }
                                    },
                                    Body = new MinTypeMatcher(new
                                    {
                                        id = "27",
                                        name = "burger",
                                        type = "food"
                                    }, 1)
                                });

            // Act
            var consumer = new ProductClient();
            List<Product> result = await consumer.GetProducts(_mockProviderServiceBaseUri);

            // Assert
            result.Should().NotBeNull();
            result.Should().HaveCount(1);
            result[0].id.Should().Equals("27");
            result[0].name.Should().Equals("burger");
            result[0].type.Should().Equals("food");
        }
    }
}
