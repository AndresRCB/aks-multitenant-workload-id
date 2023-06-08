package com.example.publish.config;

import com.azure.messaging.eventhubs.EventData;
import com.azure.messaging.eventhubs.EventHubProducerClient;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.cloud.function.context.PollableBean;
import org.springframework.context.annotation.Configuration;
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

    private String[] messages = {
            "Tenant1 -> Message 1",
            "Tenant1 -> Message 2",
            "Tenant1 -> Message 3",
            "Tenant1 -> Message 4",
            "Tenant1 -> Message 5",
    };

    // Spring cloud triggers it by configurable polling
    @PollableBean
    Supplier<Message<String>> produce() {
        // Generate and set the 'sequenceNumber' header for each event
        return () -> {
            String message = messages[rnd.nextInt(messages.length)];
            System.out.println("Sending: " + message);
            return MessageBuilder.withPayload("Hello, " + message).build();
        };
    }
}
