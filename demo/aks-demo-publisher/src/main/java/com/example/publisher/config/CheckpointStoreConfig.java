package com.example.publisher.config;

import com.azure.identity.DefaultAzureCredential;
import com.azure.identity.DefaultAzureCredentialBuilder;
import com.azure.identity.WorkloadIdentityCredential;
import com.azure.identity.WorkloadIdentityCredentialBuilder;
import com.azure.storage.blob.BlobContainerClientBuilder;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.Configuration;
import com.azure.messaging.eventhubs.CheckpointStore;
import org.springframework.context.annotation.Bean;
import com.azure.messaging.eventhubs.checkpointstore.blob.BlobCheckpointStore;
import org.springframework.context.annotation.Primary;

@Configuration
public class CheckpointStoreConfig {

    @Value("${spring.cloud.stream.binders.eventhub-1.environment.spring.cloud.azure.eventhubs.processor.checkpoint-store.endpoint}")
    private String endpoint1;

    @Value("${spring.cloud.stream.binders.eventhub-2.environment.spring.cloud.azure.eventhubs.processor.checkpoint-store.endpoint}")
    private String endpoint2;

    @Value("${spring.cloud.stream.binders.eventhub-2.environment.spring.cloud.azure.eventhubs.profile.tenant-id}")
    private String tenantId2;

    @Value("${spring.cloud.stream.binders.eventhub-2.environment.spring.cloud.azure.eventhubs.credential.client-id}")
    private String clientId2;

    @Bean
    @Primary
    public CheckpointStore checkpointStoreClient1() {
        var blobContainerAsyncClient = new BlobContainerClientBuilder()
                .credential(new DefaultAzureCredentialBuilder()
                        .build())
                .endpoint(endpoint1)
                .buildAsyncClient();
        return new BlobCheckpointStore(blobContainerAsyncClient);
    }

    @Bean
    @Primary
    public CheckpointStore checkpointStoreClient2() {
        var blobContainerAsyncClient = new BlobContainerClientBuilder()
                .credential(new WorkloadIdentityCredentialBuilder()
                .tokenFilePath(System.getenv("AZURE_FEDERATED_TOKEN_FILE"))
                .tenantId(tenantId2)
                .clientId(clientId2)
                .build())
                .endpoint(endpoint2)
                .buildAsyncClient();
        return new BlobCheckpointStore(blobContainerAsyncClient);
    }
}
