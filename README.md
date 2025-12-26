<div align="center">
  <a href="https://apexfluently.beyondthecloud.dev/libraries/cache-manager.html">
    <picture>
      <source media="(prefers-color-scheme: dark)" srcset="./website/public/logo.png">
      <img alt="Async Lib logo" src="./website/public/logo.png" height="98">
    </picture>
  </a>
  <h1>Cache Manager</h1>

<a href="https://beyondthecloud.dev"><img alt="Beyond The Cloud logo" src="https://img.shields.io/badge/MADE_BY_BEYOND_THE_CLOUD-555?style=for-the-badge"></a>

<img alt="API version" src="https://img.shields.io/badge/api-v65.0-blue?style=for-the-badge">
<a href="https://github.com/beyond-the-cloud-dev/soql-lib/blob/main/LICENSE"><img alt="License" src="https://img.shields.io/badge/license-mit-green?style=for-the-badge"></a>
<img alt="GitHub Repo stars" src="https://img.shields.io/github/stars/beyond-the-cloud-dev/cache-manager?style=for-the-badge&logo=github&color=blue">
<img alt="GitHub Release" src="https://img.shields.io/github/v/release/beyond-the-cloud-dev/cache-manager?display_name=tag&style=for-the-badge&color=blue">
<img alt="Codecov" src="https://img.shields.io/codecov/c/github/beyond-the-cloud-dev/cache-manager?style=for-the-badge">
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
