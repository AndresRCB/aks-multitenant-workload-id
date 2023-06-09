package com.example.publisher.config;

import com.azure.identity.DefaultAzureCredentialBuilder;
import com.azure.messaging.eventhubs.EventHubClientBuilder;
import com.azure.messaging.eventhubs.EventHubProducerClient;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

@Configuration
public class EventHubConfig {

    @Value("${spring.cloud.azure.eventhubs.namespace}")
    private String eventHubNamespace;

    @Value("${spring.cloud.azure.eventhubs.event-hub-name}")
    private String eventHubName;

    @Value("${spring.cloud.azure.eventhubs.processor.consumer-group}")
    private String consumerGrp;

    @Bean
    public EventHubProducerClient eventHubProducerClient() {
        return new EventHubClientBuilder()
                .credential(eventHubNamespace, eventHubName, new DefaultAzureCredentialBuilder().build())
                .consumerGroup(consumerGrp)
                .buildProducerClient();
    }

}
