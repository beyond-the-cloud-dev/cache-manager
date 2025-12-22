# Session Cache

Persistent caching scoped to a single user session.

## Overview

Session cache stores data persistently using Salesforce Platform Cache, scoped to the current user's session.

```apex
CacheManager.DefaultSessionCache
```

## Characteristics

- **Lifetime:** Duration of user session
- **Scope:** Current user session only
- **Storage:** Platform Cache
- **Persistence:** Persistent across transactions in same session
- **Sharing:** Not shared across users or sessions

## When to Use

Use session cache when you need to:

- Cache user-specific preferences
- Store temporary user state
- Cache data for current user only
- Reduce queries for user-specific data

## Setup Required

Session cache requires Platform Cache setup:

1. Go to **Setup** → **Platform Cache**
2. Create a partition named `Default`
3. Allocate session cache capacity

## Basic Usage

```apex
// Store in cache
CacheManager.DefaultSessionCache.put('preferences', userPrefs);

// Retrieve from cache
Map<String, Object> prefs = (Map<String, Object>)
    CacheManager.DefaultSessionCache.get('preferences');

// Check existence
if (CacheManager.DefaultSessionCache.contains('preferences')) {
    // Use cached data
}

// Remove from cache
CacheManager.DefaultSessionCache.remove('preferences');
```

## Example: Cache User Preferences

```apex
public class PreferenceService {
    public static Map<String, Object> getPreferences() {
        String cacheKey = 'prefs' + UserInfo.getUserId();

        if (CacheManager.DefaultSessionCache.contains(cacheKey)) {
            return (Map<String, Object>)
                CacheManager.DefaultSessionCache.get(cacheKey);
        }

        Map<String, Object> prefs = loadFromDatabase();
        CacheManager.DefaultSessionCache.put(cacheKey, prefs);

        return prefs;
    }

    private static Map<String, Object> loadFromDatabase() {
        UserPreference__c pref = [
            SELECT Theme__c, Language__c
            FROM UserPreference__c
            WHERE User__c = :UserInfo.getUserId()
        ];

        return new Map<String, Object>{
            'theme' => pref.Theme__c,
            'language' => pref.Language__c
        };
    }
}
```

## Example: Cache User Context

```apex
public class UserContextService {
    public static User getCurrentUserWithProfile() {
        String cacheKey = 'userContext';

        if (CacheManager.DefaultSessionCache.contains(cacheKey)) {
            return (User) CacheManager.DefaultSessionCache.get(cacheKey);
        }

        User currentUser = [
            SELECT Id, Name, Email, Profile.Name, UserRole.Name
            FROM User
            WHERE Id = :UserInfo.getUserId()
        ];

        CacheManager.DefaultSessionCache.put(cacheKey, currentUser);
        return currentUser;
    }
}
```

## Invalidation

```apex
// Invalidate when user updates preferences
public static void updatePreferences(Map<String, Object> newPrefs) {
    // Update database
    savePreferences(newPrefs);

    // Invalidate session cache
    String cacheKey = 'prefs' + UserInfo.getUserId();
    CacheManager.DefaultSessionCache.remove(cacheKey);
}
```

## Best Practices

1. **Cache User-Specific Data** - Perfect for preferences, settings
2. **Include User ID in Key** - Ensure keys are unique per user
3. **Invalidate on Updates** - Clear cache when user changes data
4. **Monitor Capacity** - Session cache has storage limits

[See Examples →](/examples)
