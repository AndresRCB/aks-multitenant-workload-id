package com.example.publisher.config;

import com.azure.core.credential.TokenCredential;
import com.azure.identity.DefaultAzureCredential;
import com.azure.identity.DefaultAzureCredentialBuilder;
import com.azure.messaging.eventhubs.*;
import com.azure.spring.cloud.stream.binder.eventhubs.EventHubsMessageChannelBinder;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.cloud.stream.binder.BinderConfiguration;
import org.springframework.cloud.stream.binder.BinderCustomizer;
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




//    @Bean
//    public EventHubProducerClient eventHubProducerClient() {
//        return new EventHubClientBuilder()
//                .credential(eventHubNamespace, eventHubName, new DefaultAzureCredentialBuilder().build())
//                .consumerGroup(consumerGrp)
//                .buildProducerClient();
//    }

//    @Bean
//    public EventHubConsumerClient eventHubConsumerClient() {
//        return new EventHubClientBuilder()
//                .credential(eventHubNamespace, eventHubName, new DefaultAzureCredentialBuilder().build())
//                .consumerGroup(consumerGrp)
//                .buildConsumerClient();
//    }
}
