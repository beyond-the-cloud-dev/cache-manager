# Org Cache

Persistent caching shared across the entire org.

## Overview

Org cache stores data persistently using Salesforce Platform Cache, shared across all users and sessions in the org.

```apex
CacheManager.DefaultOrgCache
```

## Characteristics

- **Lifetime:** Until evicted or explicitly removed
- **Scope:** Entire org
- **Storage:** Platform Cache
- **Persistence:** Persistent across transactions
- **Sharing:** Shared across all users and sessions

## When to Use

Use org cache when you need to:

- Cache configuration data
- Store data shared across all users
- Cache expensive calculations used org-wide
- Reduce database queries for frequently accessed data

## Setup Required

Org cache requires Platform Cache setup:

1. Go to **Setup** → **Platform Cache**
2. Create a partition named `Default`
3. Allocate org cache capacity

## Basic Usage

```apex
// Store in cache
CacheManager.DefaultOrgCache.put('settings', orgSettings);

// Retrieve from cache
Settings__c settings = (Settings__c)
    CacheManager.DefaultOrgCache.get('settings');

// Check existence
if (CacheManager.DefaultOrgCache.contains('settings')) {
    // Use cached data
}

// Remove from cache
CacheManager.DefaultOrgCache.remove('settings');
```

## Example: Cache Configuration

```apex
public class ConfigService {
    public static Map<String, Object> getConfig() {
        String cacheKey = 'appConfig';

        if (CacheManager.DefaultOrgCache.contains(cacheKey)) {
            return (Map<String, Object>)
                CacheManager.DefaultOrgCache.get(cacheKey);
        }

        Map<String, Object> config = loadConfigFromCustomSettings();
        CacheManager.DefaultOrgCache.put(cacheKey, config);

        return config;
    }
}
```

## Example: Cache Metadata

```apex
public List<AccountType__mdt> getAccountTypes() {
    String cacheKey = 'accountTypes';

    if (CacheManager.DefaultOrgCache.contains(cacheKey)) {
        return (List<AccountType__mdt>)
            CacheManager.DefaultOrgCache.get(cacheKey);
    }

    List<AccountType__mdt> types = [
        SELECT Id, Type__c, DefaultOwner__c
        FROM AccountType__mdt
    ];

    CacheManager.DefaultOrgCache.put(cacheKey, types);
    return types;
}
```

## Cache Invalidation

```apex
// Invalidate when configuration changes
public static void updateConfig(Map<String, Object> newConfig) {
    // Update database
    saveConfig(newConfig);

    // Invalidate cache
    CacheManager.DefaultOrgCache.remove('appConfig');
}
```

## Best Practices

1. **Cache Read-Heavy Data** - Perfect for configuration, metadata
2. **Invalidate on Updates** - Remove cache when underlying data changes
3. **Use Reasonable TTL** - Don't cache data that changes frequently
4. **Monitor Capacity** - Platform Cache has storage limits

[See Examples →](/examples)
