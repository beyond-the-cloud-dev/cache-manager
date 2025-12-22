# Getting Started

Learn how to use Cache Manager in your Salesforce org.

## What is Cache Manager?

Cache Manager provides a simplified, unified interface for Salesforce Platform Cache. It supports:

- **Transaction Cache** - In-memory cache for single transaction
- **Org Cache** - Persistent cache shared across org
- **Session Cache** - Persistent cache scoped to user session

All three use the same simple API.

## Installation

See the [Installation Guide](/installation) for setup instructions.

## Basic Usage

### Transaction Cache

Cache data for the duration of a transaction:

```apex
// Store in cache
CacheManager.ApexTransaction.put('currentUser', currentUser);

// Retrieve from cache
User user = (User) CacheManager.ApexTransaction.get('currentUser');

// Check if exists
if (CacheManager.ApexTransaction.contains('currentUser')) {
    // Use cached data
}

// Remove from cache
CacheManager.ApexTransaction.remove('currentUser');
```

### Org Cache

Cache data persistently across the org:

```apex
// Store in org cache
CacheManager.DefaultOrgCache.put('settings', orgSettings);

// Retrieve from org cache
Settings__c settings = (Settings__c) CacheManager.DefaultOrgCache.get('settings');
```

### Session Cache

Cache data for a user session:

```apex
// Store in session cache
CacheManager.DefaultSessionCache.put('preferences', userPrefs);

// Retrieve from session cache
Map<String, Object> prefs = (Map<String, Object>)
    CacheManager.DefaultSessionCache.get('preferences');
```

## Common Use Cases

### Avoid Redundant SOQL

```apex
public User getCurrentUser() {
    String userId = UserInfo.getUserId();

    // Check cache first
    if (CacheManager.ApexTransaction.contains(userId)) {
        return (User) CacheManager.ApexTransaction.get(userId);
    }

    // Query and cache
    User currentUser = [SELECT Id, Name, Email FROM User WHERE Id = :userId];
    CacheManager.ApexTransaction.put(userId, currentUser);

    return currentUser;
}
```

### Cache Expensive Calculations

```apex
public Decimal calculateTotal(List<LineItem> items) {
    String cacheKey = 'total' + items.hashCode();

    if (CacheManager.ApexTransaction.contains(cacheKey)) {
        return (Decimal) CacheManager.ApexTransaction.get(cacheKey);
    }

    Decimal total = 0;
    for (LineItem item : items) {
        total += item.quantity * item.price;
    }

    CacheManager.ApexTransaction.put(cacheKey, total);
    return total;
}
```

### Cache Configuration

```apex
public static Map<String, Object> getAppConfig() {
    String cacheKey = 'appConfig';

    if (CacheManager.DefaultOrgCache.contains(cacheKey)) {
        return (Map<String, Object>) CacheManager.DefaultOrgCache.get(cacheKey);
    }

    Map<String, Object> config = loadConfigFromCustomSettings();
    CacheManager.DefaultOrgCache.put(cacheKey, config);

    return config;
}
```

## Key Validation

Cache Manager validates that keys are alphanumeric:

```apex
// ✅ Valid keys
CacheManager.ApexTransaction.put('userId123', user);
CacheManager.ApexTransaction.put('abc', data);

// ❌ Invalid keys (throws IllegalArgumentException)
CacheManager.ApexTransaction.put('user-id', user);    // Contains hyphen
CacheManager.ApexTransaction.put('user.id', user);    // Contains dot
CacheManager.ApexTransaction.put('user_id', user);    // Contains underscore
```

## Next Steps

- Learn about [Transaction Cache](/caches/transaction)
- Explore [Org Cache](/caches/org)
- See [Complete Examples](/examples)
- Review [API Reference](/api)
