# Transaction Cache

In-memory caching for the duration of a single transaction.

## Overview

Transaction cache stores data in memory for the lifetime of a single Apex transaction. When the transaction completes, the cache is cleared.

```apex
CacheManager.ApexTransaction
```

## Characteristics

- **Lifetime:** Single transaction only
- **Scope:** Current transaction
- **Storage:** In-memory (heap)
- **Persistence:** Not persistent
- **Sharing:** Not shared across transactions

## When to Use

Use transaction cache when you need to:

- Avoid redundant SOQL queries within a transaction
- Cache expensive calculations
- Store temporary data during processing
- Share data between methods in the same transaction

## Basic Usage

```apex
// Store in cache
CacheManager.ApexTransaction.put('userId', currentUser);

// Retrieve from cache
User user = (User) CacheManager.ApexTransaction.get('userId');

// Check existence
if (CacheManager.ApexTransaction.contains('userId')) {
    // Use cached data
}

// Remove from cache
CacheManager.ApexTransaction.remove('userId');

// Get all keys
Set<String> keys = CacheManager.ApexTransaction.getKeys();
```

## Example: Avoid Redundant SOQL

```apex
public User getUser(Id userId) {
    // Check cache first
    if (CacheManager.ApexTransaction.contains(userId)) {
        return (User) CacheManager.ApexTransaction.get(userId);
    }

    // Query if not cached
    User user = [SELECT Id, Name FROM User WHERE Id = :userId];

    // Cache for future use in this transaction
    CacheManager.ApexTransaction.put(userId, user);

    return user;
}
```

## Example: Cache in Loops

```apex
for (Account acc : accounts) {
    // Cache account type metadata to avoid repeated queries
    String cacheKey = 'type' + acc.Type;

    if (!CacheManager.ApexTransaction.contains(cacheKey)) {
        AccountType__mdt metadata = [
            SELECT DefaultOwner__c
            FROM AccountType__mdt
            WHERE Type__c = :acc.Type
        ];
        CacheManager.ApexTransaction.put(cacheKey, metadata);
    }

    AccountType__mdt metadata = (AccountType__mdt)
        CacheManager.ApexTransaction.get(cacheKey);

    acc.OwnerId = metadata.DefaultOwner__c;
}
```

## Limits

Transaction cache uses heap space. Be mindful of:
- Heap size limits (6MB synchronous, 12MB asynchronous)
- Large objects in cache consume significant heap
- Clear cache when no longer needed

## Best Practices

1. **Use for Short-Lived Data** - Perfect for single-transaction caching
2. **Clear When Done** - Remove cached items you no longer need
3. **Monitor Heap Usage** - Large caches can exceed heap limits
4. **Use Descriptive Keys** - Make cache keys meaningful

[See Examples →](/examples)
