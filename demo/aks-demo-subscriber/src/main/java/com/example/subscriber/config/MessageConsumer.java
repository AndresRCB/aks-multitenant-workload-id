package com.example.subscriber.config;

import com.azure.spring.messaging.eventhubs.support.EventHubsHeaders;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.messaging.Message;

import com.azure.spring.messaging.checkpoint.Checkpointer;
import org.springframework.messaging.MessageHeaders;

import java.util.function.Consumer;

import static com.azure.spring.messaging.AzureHeaders.CHECKPOINTER;

/*
Spring-Cloud Stream detects the Supplier @Bean and creates a binding for it
— a bridge between our source code and the brokers exposed by the binder.
The naming convention that Spring Cloud uses to automatically name our bindings is:

input binding — <functionName> + -in- + <index>
output binding — <functionName> + -out- + <index>
 */
@Configuration
public class MessageConsumer {

    private static final Logger LOGGER = LoggerFactory.getLogger(MessageConsumer.class);

    @Bean
    Consumer<Message<String>> consume() {
        return message -> {
            if (message != null) {
                Checkpointer checkpointer = (Checkpointer) message.getHeaders().get(CHECKPOINTER);
                if (checkpointer != null) {
                    LOGGER.info("New message received: '{}', partition key: {}, sequence number: {}, offset: {}, enqueued time: {}",
                            message.getPayload(),
                            message.getHeaders().get(EventHubsHeaders.PARTITION_KEY),
                            message.getHeaders().get(EventHubsHeaders.SEQUENCE_NUMBER),
                            message.getHeaders().get(EventHubsHeaders.OFFSET),
                            message.getHeaders().get(EventHubsHeaders.ENQUEUED_TIME)
                    );

                    checkpointer.success()
                            .doOnSuccess(success -> LOGGER.info("Message '{}' successfully checkpointed", message.getPayload()))
                            .doOnError(error -> LOGGER.info("Exception found", error))
                            .block();
                }
            }
        };
    }
}
