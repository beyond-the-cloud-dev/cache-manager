# Best Practices

Guidelines for effective caching with Cache Manager.

## Choose the Right Cache Type

### Transaction Cache ⚡
Use for temporary data within a single transaction:
- Avoiding redundant SOQL in one transaction
- Caching expensive calculations
- Temporary data during processing

### Org Cache 🌐
Use for org-wide shared data:
- Configuration settings
- Metadata
- Reference data used by all users

### Session Cache 👤
Use for user-specific persistent data:
- User preferences
- User context
- Temporary user state

## Key Naming

### Use Descriptive Keys

```apex
// ✅ Good - clear and descriptive
CacheManager.ApexTransaction.put('currentUser', user);
CacheManager.ApexTransaction.put('accountType123', metadata);

// ❌ Bad - unclear
CacheManager.ApexTransaction.put('u', user);
CacheManager.ApexTransaction.put('data', metadata);
```

### Include Identifiers

```apex
// ✅ Good - includes identifier
String key = 'account' + accountId;
CacheManager.ApexTransaction.put(key, account);

// ✅ Good - unique per user
String key = 'prefs' + UserInfo.getUserId();
CacheManager.DefaultSessionCache.put(key, preferences);
```

### Alphanumeric Only

Remember: keys must be alphanumeric.

```apex
// ✅ Valid
CacheManager.ApexTransaction.put('userId123', user);

// ❌ Invalid
CacheManager.ApexTransaction.put('user-id', user);
CacheManager.ApexTransaction.put('user_id', user);
```

## Check Before Getting

```apex
// ✅ Good - check first
if (CacheManager.ApexTransaction.contains('userId')) {
    User user = (User) CacheManager.ApexTransaction.get('userId');
}

// ❌ Inefficient - get then check null
User user = (User) CacheManager.ApexTransaction.get('userId');
if (user != null) {
    // Use user
}
```

## Cache Invalidation

### Invalidate on Updates

```apex
public static void updateConfig(Map<String, Object> newConfig) {
    saveConfig(newConfig);

    // Invalidate cache
    CacheManager.DefaultOrgCache.remove('appConfig');
}
```

### Batch Invalidation

```apex
public static void clearUserCaches(Set<Id> userIds) {
    for (Id userId : userIds) {
        CacheManager.DefaultSessionCache.remove('prefs' + userId);
    }
}
```

## Avoid Over-Caching

Don't cache data that:
- Changes frequently
- Is cheap to retrieve
- Is rarely reused
- Consumes significant memory

```apex
// ❌ Don't cache - changes every time
CacheManager.ApexTransaction.put('timestamp', DateTime.now());

// ❌ Don't cache - cheap to get
CacheManager.ApexTransaction.put('userId', UserInfo.getUserId());

// ✅ Do cache - expensive query
CacheManager.ApexTransaction.put('accountWithChildren', complexQuery());
```

## Monitor Resource Usage

### Transaction Cache

- Uses heap space (6MB sync, 12MB async limits)
- Clear large objects when no longer needed

```apex
// Clear when done
CacheManager.ApexTransaction.remove('largeDataSet');
```

### Platform Cache

- Monitor capacity in Setup → Platform Cache
- Allocate appropriate storage
- Handle cache misses gracefully

## Error Handling

```apex
public User getUserSafely(Id userId) {
    try {
        if (CacheManager.ApexTransaction.contains(userId)) {
            return (User) CacheManager.ApexTransaction.get(userId);
        }

        User user = [SELECT Id, Name FROM User WHERE Id = :userId];
        CacheManager.ApexTransaction.put(userId, user);

        return user;
    } catch (Exception e) {
        System.debug('Cache error: ' + e.getMessage());
        // Fallback to direct query
        return [SELECT Id, Name FROM User WHERE Id = :userId];
    }
}
```

## Testing

### Clear Cache in Tests

```apex
@IsTest
static void testCaching() {
    // Arrange
    Test.startTest();

    // Act
    UserService.getUser(userId);
    UserService.getUser(userId); // Should use cache

    Test.stopTest();

    // Assert
    Assert.isTrue(CacheManager.ApexTransaction.contains(userId));
}
```

## Performance Tips

1. **Cache Read-Heavy Data** - Data read often, changed rarely
2. **Batch Cache Writes** - Cache multiple items together when possible
3. **Use Appropriate Scope** - Transaction < Session < Org
4. **Monitor Hit Rates** - Track cache effectiveness

## Documentation

Document your caching strategy:

```apex
/**
 * Caches user preferences for the session.
 * Cache key: 'prefs' + userId
 * Invalidated when preferences are updated.
 */
public static Map<String, Object> getPreferences() {
    // Implementation
}
```

[See Examples →](/examples)
