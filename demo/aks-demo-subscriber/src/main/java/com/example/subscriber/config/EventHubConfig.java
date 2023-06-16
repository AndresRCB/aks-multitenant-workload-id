package com.example.subscriber.config;

import com.azure.identity.DefaultAzureCredentialBuilder;
import com.azure.messaging.eventhubs.EventHubClientBuilder;
import com.azure.messaging.eventhubs.EventHubConsumerClient;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

@Configuration
public class EventHubConfig {

    @Value("${spring.cloud.stream.binders.eventhub-1.environment.spring.cloud.azure.eventhubs.namespace}")
    private String eventHubNamespace1;

    @Value("${spring.cloud.stream.binders.eventhub-1.environment.spring.cloud.azure.eventhubs.event-hub-name}")
    private String eventHubName1;

    @Value("${spring.cloud.stream.bindings.consume1-in-0.group}")
    private String consumerGrp1;

    @Value("${spring.cloud.stream.binders.eventhub-2.environment.spring.cloud.azure.eventhubs.namespace}")
    private String eventHubNamespace2;

    @Value("${spring.cloud.stream.binders.eventhub-2.environment.spring.cloud.azure.eventhubs.event-hub-name}")
    private String eventHubName2;

    @Value("${spring.cloud.stream.bindings.consume2-in-0.group}")
    private String consumerGrp2;

    @Value("${spring.cloud.stream.binders.eventhub-2.environment.spring.cloud.azure.eventhubs.profile.tenant-id}")
    private String tenantId2;

    @Value("${spring.cloud.stream.binders.eventhub-2.environment.spring.cloud.azure.eventhubs.credential.client-id}")
    private String clientId2;

    @Bean
    public EventHubConsumerClient eventHubConsumerClient1() {
        return new EventHubClientBuilder()
                .credential(eventHubNamespace1, eventHubName1, new DefaultAzureCredentialBuilder()
                        .build())
                .consumerGroup(consumerGrp1)
                .buildConsumerClient();
    }

    @Bean
    public EventHubConsumerClient eventHubConsumerClient2() {
        return new EventHubClientBuilder()
                .credential(eventHubNamespace2, eventHubName2, new DefaultAzureCredentialBuilder()
                        .tenantId(tenantId2)
                        .managedIdentityClientId(clientId2)
                        .build())
                .consumerGroup(consumerGrp2)
                .buildConsumerClient();
    }
}
