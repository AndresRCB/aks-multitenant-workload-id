package com.demo.ehclient;

import com.azure.core.credential.AccessToken;
import com.azure.core.credential.TokenCredential;
import com.azure.core.credential.TokenRequestContext;
import com.azure.messaging.eventhubs.*;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;

import com.azure.identity.*;
import reactor.core.publisher.Mono;

public class SenderAAD {

    private static final String namespaceName = System.getenv("ehNamespaceOfTenant2");

    private static final String eventHubName = System.getenv("ehNameOfTenant2");

    private static final String tenantId = System.getenv("tenantId2");

    private static final String clientId = System.getenv("clientId2");

    public static void main(String[] args) {
        publishEventsTenant2();
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

        EventHubProducerClient producer = new EventHubClientBuilder()
                .credential(namespaceName, eventHubName, credential)
                .consumerGroup("$Default")
                .buildProducerClient();

      //  System.out.println("Producer created:"+producer.getEventHubProperties());

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
            System.out.println("batch sent:"+eventDataBatch.getCount());
            producer.send(eventDataBatch);
        }

        producer.close();
    }
}
