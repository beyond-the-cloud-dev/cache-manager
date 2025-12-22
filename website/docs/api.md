# API Reference

Complete API documentation for Cache Manager.

## Interface

All cache types implement the `Cacheable` interface:

```apex
public interface Cacheable {
    Boolean contains(String key);
    Set<String> getKeys();
    Object get(String key);
    void put(String key, Object value);
    void remove(String key);
}
```

## Methods

### put()

Store a value in the cache.

```apex
void put(String key, Object value)
```

**Parameters:**
- `key` - Alphanumeric cache key
- `value` - Any serializable object

**Example:**
```apex
CacheManager.ApexTransaction.put('userId', currentUser);
CacheManager.DefaultOrgCache.put('settings', orgSettings);
```

::: warning
Keys must be alphanumeric. Special characters will throw `IllegalArgumentException`.
:::

### get()

Retrieve a value from the cache.

```apex
Object get(String key)
```

**Parameters:**
- `key` - Cache key to retrieve

**Returns:** Cached object or `null` if not found

**Example:**
```apex
User user = (User) CacheManager.ApexTransaction.get('userId');
if (user != null) {
    // Use cached user
}
```

### contains()

Check if a key exists in the cache.

```apex
Boolean contains(String key)
```

**Parameters:**
- `key` - Cache key to check

**Returns:** `true` if key exists, `false` otherwise

**Example:**
```apex
if (CacheManager.ApexTransaction.contains('userId')) {
    User user = (User) CacheManager.ApexTransaction.get('userId');
}
```

### remove()

Remove a key from the cache.

```apex
void remove(String key)
```

**Parameters:**
- `key` - Cache key to remove

**Example:**
```apex
CacheManager.ApexTransaction.remove('userId');
```

### getKeys()

Get all keys currently in the cache.

```apex
Set<String> getKeys()
```

**Returns:** Set of all cache keys

**Example:**
```apex
Set<String> allKeys = CacheManager.ApexTransaction.getKeys();
for (String key : allKeys) {
    System.debug(key + ': ' + CacheManager.ApexTransaction.get(key));
}
```

## Cache Types

### Transaction Cache

```apex
CacheManager.ApexTransaction
```

In-memory cache for single transaction duration.

### Org Cache

```apex
CacheManager.DefaultOrgCache
```

Persistent cache shared across the org.

### Session Cache

```apex
CacheManager.DefaultSessionCache
```

Persistent cache scoped to user session.

## Key Validation

All keys must be alphanumeric (`[a-zA-Z0-9]+`):

```apex
// ✅ Valid
CacheManager.ApexTransaction.put('userId123', user);

// ❌ Invalid - throws IllegalArgumentException
CacheManager.ApexTransaction.put('user-id', user);
CacheManager.ApexTransaction.put('user_id', user);
CacheManager.ApexTransaction.put('user.id', user);
```

## Examples

[See complete examples →](/examples)
