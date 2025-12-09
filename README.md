<div align="center">
  <a href="https://apexfluently.beyondthecloud.dev/libraries/cache-manager.html">
    <picture>
      <source media="(prefers-color-scheme: dark)" srcset="./assets/cache_manager.png">
      <img alt="Async Lib logo" src="./assets/cache_manager.png" height="98">
    </picture>
  </a>
  <h1>Cache Manager</h1>

<a href="https://beyondthecloud.dev"><img alt="Beyond The Cloud logo" src="https://img.shields.io/badge/MADE_BY_BEYOND_THE_CLOUD-555?style=for-the-badge"></a>
<a ><img alt="API version" src="https://img.shields.io/badge/api-v57.0-blue?style=for-the-badge"></a>
<a href="https://github.com/beyond-the-cloud-dev/cache-manager/blob/main/LICENSE"><img alt="License" src="https://img.shields.io/badge/license-mit-green?style=for-the-badge"></a>

[![CI](https://github.com/beyond-the-cloud-dev/cache-manager/actions/workflows/ci.yml/badge.svg?branch=main)](https://github.com/beyond-the-cloud-dev/cache-manager/actions/workflows/ci.yml)
[![codecov](https://codecov.io/gh/beyond-the-cloud-dev/cache-manager/branch/main/graph/badge.svg)](https://codecov.io/gh/beyond-the-cloud-dev/cache-manager)
</div>

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
