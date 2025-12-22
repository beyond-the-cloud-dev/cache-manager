---
layout: home

hero:
  name: "Cache Manager"
  text: "Simplified Platform Cache"
  tagline: A clean, unified interface for Salesforce Platform Cache - supporting transaction, org, and session caching with a consistent API
  actions:
    - theme: brand
      text: Get Started
      link: /getting-started
    - theme: alt
      text: API Reference
      link: /api
    - theme: alt
      text: View on GitHub
      link: https://github.com/beyond-the-cloud-dev/cache-manager

features:
  - icon: 🎯
    title: Unified Interface
    details: One consistent API for all cache types - transaction, org, and session cache with the same methods.

  - icon: ⚡
    title: Simple & Fast
    details: Straightforward API that wraps Salesforce Platform Cache complexity with clean, easy-to-use methods.

  - icon: 🔒
    title: Type-Safe Keys
    details: Automatic validation ensures cache keys are alphanumeric, preventing runtime errors.

  - icon: 📦
    title: Transaction Cache
    details: In-memory caching for the duration of a single transaction. Perfect for avoiding redundant SOQL queries.

  - icon: 🌐
    title: Org & Session Cache
    details: Persistent caching across transactions using Platform Cache partitions.

  - icon: 🚀
    title: Production Ready
    details: Battle-tested in production. Part of Apex Fluently suite of enterprise-grade Salesforce libraries.
---

## Why Cache Manager?

Salesforce Platform Cache is powerful but verbose. Cache Manager simplifies it with a clean, consistent API:

::: code-group

```apex [Before ❌]
// Platform Cache - verbose and complex
Cache.Org orgCache = Cache.Org.getPartition('local.Default');
orgCache.put('userId', currentUser);
User cachedUser = (User) orgCache.get('userId');

// Different API for transaction cache
Map<String, Object> transactionCache = new Map<String, Object>();
transactionCache.put('userId', currentUser);
User user = (User) transactionCache.get('userId');
```

```apex [After ✅]
// Cache Manager - simple and consistent
CacheManager.DefaultOrgCache.put('userId', currentUser);
User cachedUser = (User) CacheManager.DefaultOrgCache.get('userId');

// Same API for transaction cache
CacheManager.ApexTransaction.put('userId', currentUser);
User user = (User) CacheManager.ApexTransaction.get('userId');
```

:::

## Quick Example

```apex
// Cache user data for the transaction
CacheManager.ApexTransaction.put(
    UserInfo.getUserId(),
    [SELECT Id, Name, Email FROM User WHERE Id = :UserInfo.getUserId()]
);

// Retrieve from cache (no SOQL query)
User currentUser = (User) CacheManager.ApexTransaction.get(UserInfo.getUserId());

// Check if key exists
if (CacheManager.ApexTransaction.contains(UserInfo.getUserId())) {
    // Use cached data
}

// Remove from cache
CacheManager.ApexTransaction.remove(UserInfo.getUserId());
```

## Cache Types

Cache Manager supports three types of caching:

### Transaction Cache
In-memory cache that lasts for the duration of a single transaction.

```apex
CacheManager.ApexTransaction.put('key', value);
```

### Org Cache
Persistent cache shared across the entire org.

```apex
CacheManager.DefaultOrgCache.put('key', value);
```

### Session Cache
Persistent cache scoped to a single user session.

```apex
CacheManager.DefaultSessionCache.put('key', value);
```

## Features at a Glance

- ✅ **Transaction Cache** - In-memory caching for single transaction
- ✅ **Org Cache** - Persistent org-wide caching
- ✅ **Session Cache** - Persistent user-session caching
- ✅ **Unified API** - Same methods across all cache types
- ✅ **Key Validation** - Automatic alphanumeric key validation
- ✅ **Simple Interface** - Just 5 methods: `put`, `get`, `contains`, `remove`, `getKeys`
- ✅ **Zero Config** - Works out of the box with default partitions

## API at a Glance

```apex
interface Cacheable {
    void put(String key, Object value);      // Store value
    Object get(String key);                  // Retrieve value
    Boolean contains(String key);            // Check if key exists
    void remove(String key);                 // Remove key
    Set<String> getKeys();                   // Get all keys
}
```

## Part of Apex Fluently

Cache Manager is part of [Apex Fluently](https://apexfluently.beyondthecloud.dev/), a suite of production-ready Salesforce libraries by [Beyond the Cloud](https://beyondthecloud.dev).

## Get Started

Ready to simplify your caching? [Get started →](/getting-started)
