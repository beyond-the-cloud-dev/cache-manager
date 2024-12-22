# Cache Manager

```java
CacheManager.ApexTransaction.put(
    UserInfo.getUserId(),
    [SELECT Id, Name, Country FROM User WHERE Id = :UserInfo.getUserId()]
);

User currentUser = (User) CacheManager.ApexTransaction.get(UserInfo.getUserId());
```

## Cache Configuration

Object: `CacheConfiguration__mdt`
Fields:
- `DeveloperName`
- `OrgCacheTimeToLive__c`
- `SessionCacheTimeToLive__c`
- `Enabled__c`
- `FallbackInTransactionCache__c`
- `Visibility__c`
- `IsCacheImmutable__c`

# License notes:
- For proper license management each repository should contain LICENSE file similar to this one.
- each original class should contain copyright mark: © Copyright 2024, BEYOND THE CLOUD Sp. z o.o. (BeyondTheCloud.Dev)
