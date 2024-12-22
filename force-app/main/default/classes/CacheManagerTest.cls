/**
 * Copyright (c) 2025 BEYOND THE CLOUD Sp. z o.o. (BeyondTheCloud.Dev)
 * Licensed under the MIT License (https://github.com/beyond-the-cloud-dev/cache-manager/blob/main/LICENSE)
 *
 * PMD False Positives:
 * TBD
**/
@IsTest
private class CacheManagerTest {
    @IsTest
    static void apexTransactionContains() {
        // Setup
        CacheManager.ApexTransaction.put('Test Key', 'Test Value');

        // Test
        Boolean hasKey = CacheManager.ApexTransaction.contains('Test Key');

        // Verify
        Assert.isTrue(hasKey, 'Key should exist');
    }

    @IsTest
    static void apexTransactionGet() {
        // Setup
        CacheManager.ApexTransaction.put('Test Key', 'Test Value');

        // Test
        String cachedValue = (String) CacheManager.ApexTransaction.get('Test Key');

        // Verify
        Assert.areEqual('Test Value', cachedValue, 'Cached value should be the same');
    }

    @IsTest
    static void apexTransactionPut() {
        // Test
        CacheManager.ApexTransaction.put('Test Key', 'Test Value');

        // Verify
        Assert.areEqual('Test Value', (String) CacheManager.ApexTransaction.get('Test Key'), 'Cached value should be the same');
    }

    @IsTest
    static void apexTransactionRemove() {
        // Setup
        CacheManager.ApexTransaction.put('Test Key', 'Test Value');

        // Test
        CacheManager.ApexTransaction.remove('Test Key');

        // Verify
        Assert.areEqual(null, CacheManager.ApexTransaction.get('Test Key'), 'Cached value should not exist.');
    }

    @IsTest
    static void apexTransactionGetKeys() {
        // Setup
        CacheManager.ApexTransaction.put('Test Key', 'Test Value');
        CacheManager.ApexTransaction.put('Test Key 2', 'Test Value 2');

        // Test
        Set<String> keys = CacheManager.ApexTransaction.getKeys();

        // Verify
        Assert.isTrue(keys.contains('Test Key'), 'Key should exist.');
        Assert.isTrue(keys.contains('Test Key 2'), 'Key should exist.');
    }
}
