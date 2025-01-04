# Cache Manager

```java
CacheManager.ApexTransaction.put(
    UserInfo.getUserId(),
    [SELECT Id, Name, Country FROM User WHERE Id = :UserInfo.getUserId()]
);

User currentUser = (User) CacheManager.ApexTransaction.get(UserInfo.getUserId());
```

# License notes:
- For proper license management each repository should contain LICENSE file similar to this one.
- each original class should contain copyright mark: © Copyright 2025, Beyond The Cloud Sp. z o.o. (BeyondTheCloud.Dev)
