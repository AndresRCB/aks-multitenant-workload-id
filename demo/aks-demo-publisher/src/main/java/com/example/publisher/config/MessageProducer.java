package com.example.publisher.config;

import com.azure.messaging.eventhubs.EventData;
import com.azure.messaging.eventhubs.EventHubProducerClient;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.cloud.function.context.PollableBean;
import org.springframework.context.annotation.Configuration;
import org.springframework.context.annotation.Profile;
import reactor.core.publisher.Flux;

import java.util.Random;
import java.util.UUID;
import java.util.function.Supplier;
import org.springframework.messaging.Message;
import org.springframework.messaging.support.MessageBuilder;
/*
Spring-Cloud Stream detects the Supplier @Bean and creates a binding for it
— a bridge between our source code and the brokers exposed by the binder.
The naming convention that Spring Cloud uses to automatically name our bindings is:

input binding — <functionName> + -in- + <index>
output binding — <functionName> + -out- + <index>
https://learn.microsoft.com/en-us/azure/developer/java/spring-framework/configure-spring-cloud-stream-binder-java-app-azure-event-hub
 */
@Configuration
public class MessageProducer {

    private Random rnd = new Random();

    private String[] tenant1Messages = {
            "Tenant1 -> Message 1",
            "Tenant1 -> Message 2",
            "Tenant1 -> Message 3",
            "Tenant1 -> Message 4",
            "Tenant1 -> Message 5",
    };

    private String[] tenant2Messages = {
            "Tenant2 -> Message 1",
            "Tenant2 -> Message 2",
            "Tenant2-> Message 3",
            "Tenant2 -> Message 4",
            "Tenant2-> Message 5",
    };

    // Spring cloud triggers it by configurable polling
    @PollableBean
    Supplier<Message<String>> publish1() {
        // Generate and set the 'sequenceNumber' header for each event
        return () -> {
            String tenant1Message = tenant1Messages[rnd.nextInt(tenant1Messages.length)];
            System.out.println("Publishing to main tenant1: " + tenant1Message);
            return MessageBuilder.withPayload("Hello primary, " + tenant1Message).build();
        };
    }

    @PollableBean
    Supplier<Message<String>> publish2() {
        // Generate and set the 'sequenceNumber' header for each event
        return () -> {
            String tenant2Message = tenant2Messages[rnd.nextInt(tenant2Messages.length)];
            System.out.println("Publishing to secondary tenant2: " + tenant2Message);
            return MessageBuilder.withPayload("Hello secondary, " + tenant2Message).build();
        };
    }

}
