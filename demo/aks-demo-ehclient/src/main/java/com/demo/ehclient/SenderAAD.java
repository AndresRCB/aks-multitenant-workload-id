package com.demo.ehclient;

import java.util.Arrays;
import java.util.List;

import com.azure.core.credential.AccessToken;
import com.azure.core.credential.TokenRequestContext;
import com.azure.identity.WorkloadIdentityCredential;
import com.azure.identity.WorkloadIdentityCredentialBuilder;
import com.azure.messaging.eventhubs.EventData;
import com.azure.messaging.eventhubs.EventDataBatch;
import com.azure.messaging.eventhubs.EventHubClientBuilder;
import com.azure.messaging.eventhubs.EventHubProducerClient;

import reactor.core.publisher.Mono;

public class SenderAAD {

    private static final String namespaceName = System.getenv("ehNamespaceOfTenant2");

    private static final String eventHubName = System.getenv("ehNameOfTenant2");

    private static final String tenantId = System.getenv("tenantId2");

    private static final String tenantId1 = System.getenv("tenantId");

    private static final String clientId = System.getenv("clientId2");

    private static final String clientId1 = System.getenv("clientId");

    public static void main(String[] args) {
        while(true) {
            try {
                publishEventsTenant2();
                Thread.sleep(5000);
            } catch (Exception e) {
                System.out.println("Exception:"+e.getMessage());
            }
        }
    }

    /**
     * Code sample for publishing events.
     * @throws IllegalArgumentException if the EventData is bigger than the max batch size.
     */
    public static void publishEventsTenant2() {

        WorkloadIdentityCredential credential = new WorkloadIdentityCredentialBuilder()
                .tokenFilePath(System.getenv("AZURE_FEDERATED_TOKEN_FILE"))
                .tenantId(tenantId)
                .clientId(clientId)
                .build();


    
        Mono<AccessToken> accessTokenMono = credential.getToken(new TokenRequestContext().addScopes("https://eventhubs.azure.net/.default"));
        AccessToken accessToken = accessTokenMono.block();
        System.out.println(accessToken.getToken());
        // DefaultAzureCredential credential = new DefaultAzureCredentialBuilder()
        //         .additionallyAllowedTenants("*")
        //         .tenantId(tenantId)
        //         // .authorityHost("https://eastus2.oic.prod-aks.azure.com/8f31ceff-0c7c-44d1-b7bf-d0d60f325f48/df43f585-d0e5-447b-9b7f-0c56a28d4dda/")
        //         .workloadIdentityClientId(clientId)
                
        //         // .tokenFilePath(System.getenv("AZURE_FEDERATED_TOKEN_FILE_LOCAL"))
        //         // .tenantId(tenantId)
        //         // .clientId(clientId)
        //         .build();

        EventHubProducerClient producer = new EventHubClientBuilder()
                .credential(namespaceName, eventHubName, credential)
                .consumerGroup("$Default")
                .buildProducerClient();

       System.out.println("Producer created:"+producer.getEventHubProperties());

        // sample events in an array
        List<EventData> allEvents = Arrays.asList(new EventData("Foo"), new EventData("Bar"));

        // create a batch
        EventDataBatch eventDataBatch = producer.createBatch();

        System.out.println("Databatch created:"+eventDataBatch.getCount());

        for (EventData eventData : allEvents) {
            // try to add the event from the array to the batch
            if (!eventDataBatch.tryAdd(eventData)) {
                // if the batch is full, send it and then create a new batch
                producer.send(eventDataBatch);
                eventDataBatch = producer.createBatch();

                System.out.println("Message created:"+eventData.getBodyAsString());

                // Try to add that event that couldn't fit before.
                if (!eventDataBatch.tryAdd(eventData)) {
                    throw new IllegalArgumentException("Event is too large for an empty batch. Max size: "
                            + eventDataBatch.getMaxSizeInBytes());
                }
            }
        }
        // send the last batch of remaining events
        if (eventDataBatch.getCount() > 0) {
            System.out.println("batch sent###:  "+eventDataBatch.getCount());
            producer.send(eventDataBatch);
        }

        producer.close();
    }
}
