package com.example.publisher.config;

import com.azure.identity.DefaultAzureCredentialBuilder;
import com.azure.storage.blob.BlobContainerClientBuilder;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.Configuration;
import com.azure.messaging.eventhubs.CheckpointStore;
import org.springframework.context.annotation.Bean;
import com.azure.messaging.eventhubs.checkpointstore.blob.BlobCheckpointStore;
import org.springframework.context.annotation.Primary;

@Configuration
public class CheckpointStoreConfig {

    @Value("${spring.cloud.azure.eventhubs.processor.checkpoint-store.endpoint}")
    private String endpoint;

    @Bean
    @Primary
    public CheckpointStore checkpointStoreClient() {
        var blobContainerAsyncClient = new BlobContainerClientBuilder()
                .credential(new DefaultAzureCredentialBuilder().build())
                .endpoint(endpoint)
                .buildAsyncClient();
        return new BlobCheckpointStore(blobContainerAsyncClient);
    }
}
