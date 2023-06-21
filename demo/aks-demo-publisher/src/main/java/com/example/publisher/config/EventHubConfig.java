package com.example.publisher.config;

import com.azure.identity.DefaultAzureCredentialBuilder;
import com.azure.identity.WorkloadIdentityCredentialBuilder;
import com.azure.messaging.eventhubs.EventHubClientBuilder;
import com.azure.messaging.eventhubs.EventHubProducerClient;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

@Configuration
public class EventHubConfig {

    @Value("${spring.cloud.stream.binders.eventhub-1.environment.spring.cloud.azure.eventhubs.namespace}")
    private String eventHubNamespace1;

    @Value("${spring.cloud.stream.binders.eventhub-1.environment.spring.cloud.azure.eventhubs.event-hub-name}")
    private String eventHubName1;

    @Value("${spring.cloud.stream.binders.eventhub-1.environment.spring.cloud.azure.eventhubs.consumer-group}")
    private String consumerGrp1;

    @Value("${spring.cloud.stream.binders.eventhub-2.environment.spring.cloud.azure.eventhubs.namespace}")
    private String eventHubNamespace2;

    @Value("${spring.cloud.stream.binders.eventhub-2.environment.spring.cloud.azure.eventhubs.event-hub-name}")
    private String eventHubName2;

    @Value("${spring.cloud.stream.binders.eventhub-2.environment.spring.cloud.azure.eventhubs.consumer-group}")
    private String consumerGrp2;

    @Value("${spring.cloud.stream.binders.eventhub-2.environment.spring.cloud.azure.eventhubs.profile.tenant-id}")
    private String tenantId2;

    @Value("${spring.cloud.stream.binders.eventhub-2.environment.spring.cloud.azure.eventhubs.credential.client-id}")
    private String clientId2;

//    @Bean
//    public EventHubProducerClient eventHubProducerClient1() {
//        return new EventHubClientBuilder()
//                .credential(eventHubNamespace1, eventHubName1, new DefaultAzureCredentialBuilder()
//                        .build())
//                .consumerGroup(consumerGrp1)
//                .buildProducerClient();
//    }

//    @Bean
//    public EventHubProducerClient eventHubProducerClient2() {
//        return new EventHubClientBuilder()
//                .credential(eventHubNamespace2, eventHubName2, new WorkloadIdentityCredentialBuilder()
//                .tokenFilePath(System.getenv("AZURE_FEDERATED_TOKEN_FILE"))
//                .tenantId(tenantId2)
//                .clientId(clientId2)
//                .build())
//                .consumerGroup(consumerGrp2)
//                .buildProducerClient();
//    }

}
