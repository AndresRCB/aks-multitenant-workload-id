package com.example.publisher;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.cloud.stream.annotation.EnableBinding;
import org.springframework.cloud.stream.messaging.Processor;
import org.springframework.messaging.Message;
import org.springframework.messaging.handler.annotation.SendTo;
import org.springframework.stereotype.Component;

@SpringBootApplication
public class EventHubPubApplication {

    public static void main(String[] args) {
        SpringApplication.run(EventHubPubApplication.class, args);
    }

    @Component
    @EnableBinding(Processor.class)
    public static class EventHubProcessor {

        @SendTo(Processor.OUTPUT)
        public Message<String> processMessage(Message<String> message) {
            String payload = message.getPayload();
            // Process the message payload
            return message;
        }
    }
}
