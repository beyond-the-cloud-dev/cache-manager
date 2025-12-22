# Examples

Practical examples using Cache Manager.

## Avoid Redundant SOQL

Cache query results to avoid repeated SOQL:

```apex
public class UserService {
    public User getCurrentUser() {
        String userId = UserInfo.getUserId();

        // Check cache first
        if (CacheManager.ApexTransaction.contains(userId)) {
            return (User) CacheManager.ApexTransaction.get(userId);
        }

        // Query and cache
        User currentUser = [
            SELECT Id, Name, Email, Profile.Name
            FROM User
            WHERE Id = :userId
        ];

        CacheManager.ApexTransaction.put(userId, currentUser);
        return currentUser;
    }
}
```

## Cache Expensive Calculations

```apex
public class PricingService {
    public Decimal calculateDiscount(List<Product> products) {
        String cacheKey = 'discount' + products.hashCode();

        if (CacheManager.ApexTransaction.contains(cacheKey)) {
            return (Decimal) CacheManager.ApexTransaction.get(cacheKey);
        }

        Decimal discount = performComplexCalculation(products);
        CacheManager.ApexTransaction.put(cacheKey, discount);

        return discount;
    }

    private Decimal performComplexCalculation(List<Product> products) {
        // Complex business logic here
        return 0.15;
    }
}
```

## Cache Configuration Settings

```apex
public class ConfigService {
    public static Map<String, Object> getAppConfig() {
        String cacheKey = 'appConfig';

        // Check org cache
        if (CacheManager.DefaultOrgCache.contains(cacheKey)) {
            return (Map<String, Object>)
                CacheManager.DefaultOrgCache.get(cacheKey);
        }

        // Load from custom settings
        Map<String, Object> config = new Map<String, Object>();
        for (AppConfig__c setting : AppConfig__c.getAll().values()) {
            config.put(setting.Name, setting.Value__c);
        }

        // Cache for future use
        CacheManager.DefaultOrgCache.put(cacheKey, config);
        return config;
    }
}
```

## Cache User Preferences

```apex
public class PreferenceService {
    public Map<String, Object> getUserPreferences() {
        String cacheKey = 'prefs' + UserInfo.getUserId();

        if (CacheManager.DefaultSessionCache.contains(cacheKey)) {
            return (Map<String, Object>)
                CacheManager.DefaultSessionCache.get(cacheKey);
        }

        Map<String, Object> prefs = loadPreferencesFromDB();
        CacheManager.DefaultSessionCache.put(cacheKey, prefs);

        return prefs;
    }

    private Map<String, Object> loadPreferencesFromDB() {
        // Load from database
        return new Map<String, Object>();
    }
}
```

## Cache in Triggers

```apex
trigger AccountTrigger on Account (before update) {
    for (Account acc : Trigger.new) {
        // Cache account type lookups
        String cacheKey = 'accType' + acc.Type;

        if (!CacheManager.ApexTransaction.contains(cacheKey)) {
            AccountType__mdt accType = [
                SELECT DefaultOwner__c, SLA__c
                FROM AccountType__mdt
                WHERE Type__c = :acc.Type
                LIMIT 1
            ];
            CacheManager.ApexTransaction.put(cacheKey, accType);
        }

        AccountType__mdt accType = (AccountType__mdt)
            CacheManager.ApexTransaction.get(cacheKey);

        // Use cached metadata
        acc.OwnerId = accType.DefaultOwner__c;
    }
}
```

## Batch Apex with Caching

```apex
public class AccountBatch implements Database.Batchable<sObject> {
    public Database.QueryLocator start(Database.BatchableContext bc) {
        // Cache configuration once per batch
        CacheManager.ApexTransaction.put('batchConfig', loadBatchConfig());

        return Database.getQueryLocator([
            SELECT Id, Name, Type
            FROM Account
        ]);
    }

    public void execute(Database.BatchableContext bc, List<Account> scope) {
        // Reuse cached config
        Map<String, Object> config = (Map<String, Object>)
            CacheManager.ApexTransaction.get('batchConfig');

        for (Account acc : scope) {
            // Process using cached config
        }
    }

    public void finish(Database.BatchableContext bc) {}

    private Map<String, Object> loadBatchConfig() {
        return new Map<String, Object>{'setting' => 'value'};
    }
}
```

## Cache Invalidation

```apex
public class CacheInvalidationService {
    public static void invalidateUserCache(Id userId) {
        // Remove from transaction cache
        CacheManager.ApexTransaction.remove(userId);

        // Remove from session cache
        String sessionKey = 'user' + userId;
        CacheManager.DefaultSessionCache.remove(sessionKey);
    }

    public static void clearAllTransactionCache() {
        Set<String> keys = CacheManager.ApexTransaction.getKeys();
        for (String key : keys) {
            CacheManager.ApexTransaction.remove(key);
        }
    }
}
```

## Debug Cache Contents

```apex
public class CacheDebugger {
    public static void debugTransactionCache() {
        Set<String> keys = CacheManager.ApexTransaction.getKeys();

        System.debug('=== Transaction Cache Contents ===');
        for (String key : keys) {
            Object value = CacheManager.ApexTransaction.get(key);
            System.debug(key + ' => ' + value);
        }
        System.debug('Total keys: ' + keys.size());
    }
}
```

[API Reference →](/api)
