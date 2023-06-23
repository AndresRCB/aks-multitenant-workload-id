package com.demo.ehclient;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

import com.azure.core.credential.AccessToken;
import com.azure.core.credential.TokenCredential;
import com.azure.core.credential.TokenRequestContext;
import com.azure.identity.DefaultAzureCredentialBuilder;
import com.azure.identity.WorkloadIdentityCredentialBuilder;
import com.azure.messaging.eventhubs.EventData;
import com.azure.messaging.eventhubs.EventDataBatch;
import com.azure.messaging.eventhubs.EventHubClientBuilder;
import com.azure.messaging.eventhubs.EventHubProducerClient;

import reactor.core.publisher.Mono;

public class SenderAAD {

    private static final String namespaceName = System.getenv("ehNamespaceOfTenant2");

    private static final String eventHubName = System.getenv("ehNameOfTenant2");
    private static final String tenantId1 = System.getenv("AZURE_TENANT_ID");
    private static final String clientId1 = System.getenv("AZURE_CLIENT_ID");
    private static final String tenantId2 = System.getenv("tenantId2");
    private static final String clientId2 = System.getenv("clientId2");

    public static void main(String[] args) {
        LinkedHashMap<String, String> map = new LinkedHashMap<>(Map.of("tenantId1", tenantId1, "clientid1", clientId1, "tenantid2", tenantId2,
                "clientid2", clientId2));

        for (String key : map.keySet()) {
            System.out.println("\n" + key + ":" + map.get(key));
        }
        while (true) {
            // this works.
            try {
                System.out.println("\nAttempting use of WorkloadIdentityCredential...");
                TokenCredential credential = getWorkloadIdentityCredential();
                publishEventsTenant2(credential);
                System.out.println("pausing for 5 seconds...");
            } catch (Exception e) {
                System.out.println("Exception during WorkloadIdentityCredential:" + e.getMessage());
            }
            sleep(5000);

            // fails
            try {
                System.out.println("\nAttempting use of DefaultCredential...");
                TokenCredential credential = getDefaultCredential();
                publishEventsTenant2(credential);

            } catch (Exception e) {
                System.out.println("Exception during DefaultCredential:" + e.getMessage());
            }
            sleep(5000);
        }
    }

    static void sleep(long ms) {
        try {
            Thread.sleep(ms);
        } catch (InterruptedException e) {
            e.printStackTrace();
        }
    }

    static TokenCredential getWorkloadIdentityCredential() {
        return new WorkloadIdentityCredentialBuilder()
                .tokenFilePath(System.getenv("AZURE_FEDERATED_TOKEN_FILE")) // exception if not set...
                .tenantId(tenantId2) // this is the RP tenanat id - the Trusting tenant
                .clientId(clientId2) // this is the RP client id - the Trusting tenant
                .build();
    }

    // Fails with exception during DefaultCredential:status-code: 401, status-description: InvalidIssuer: Token issuer is invalid.
    static TokenCredential getDefaultCredential() {
        return new DefaultAzureCredentialBuilder()
                .additionallyAllowedTenants("*")
                .tenantId(tenantId2)            
                .workloadIdentityClientId(clientId2)
                // .managedIdentityClientId(clientId2)
                // .authorityHost("https://eastus2.oic.prod-aks.azure.com/8f31ceff-0c7c-44d1-b7bf-d0d60f325f48/6e897b56-1da9-4b56-ac00-4dd71f9fa8a4/")
                .build();
    }



    /**
     * Code sample for publishing events.
     * 
     * @throws IllegalArgumentException if the EventData is bigger than the max
     *                                  batch size.
     */
    public static void publishEventsTenant2(TokenCredential credential) {

        Mono<AccessToken> accessTokenMono = credential
                .getToken(new TokenRequestContext().addScopes("https://eventhubs.azure.net/.default"));
        AccessToken accessToken = accessTokenMono.block();
        System.out.println(accessToken.getToken());

        EventHubProducerClient producer = new EventHubClientBuilder()
                .credential(namespaceName, eventHubName, credential)
                .consumerGroup("$Default")
                .buildProducerClient();

        System.out.println("Producer created:" + producer.getEventHubProperties());

        // sample events in an array
        List<EventData> allEvents = Arrays.asList(new EventData("Foo"), new EventData("Bar"));

        // create a batch
        EventDataBatch eventDataBatch = producer.createBatch();

        System.out.println("Databatch created:" + eventDataBatch.getCount());

        for (EventData eventData : allEvents) {
            // try to add the event from the array to the batch
            if (!eventDataBatch.tryAdd(eventData)) {
                // if the batch is full, send it and then create a new batch
                producer.send(eventDataBatch);
                eventDataBatch = producer.createBatch();

                System.out.println("Message created:" + eventData.getBodyAsString());

                // Try to add that event that couldn't fit before.
                if (!eventDataBatch.tryAdd(eventData)) {
                    throw new IllegalArgumentException("Event is too large for an empty batch. Max size: "
                            + eventDataBatch.getMaxSizeInBytes());
                }
            }
        }
        // send the last batch of remaining events
        if (eventDataBatch.getCount() > 0) {
            System.out.println("batch sent###:  " + eventDataBatch.getCount());
            producer.send(eventDataBatch);
        }

        producer.close();
    }
}
