/**
 * Copyright (c) 2025 BEYOND THE CLOUD Sp. z o.o. (BeyondTheCloud.Dev)
 * Licensed under the MIT License (https://github.com/beyond-the-cloud-dev/cache-manager/blob/main/LICENSE)
 *
 * PMD False Positives:
 * TBD
**/
public with sharing class CacheManager {
    public interface Cacheable {
        Boolean contains(String key);
        Object get(String key);
        Set<String> getKeys();
        void put(String key, Object value);
        void remove(String key);
    }

    public final static Cacheable ApexTransaction = new ApexTransactionCache();
    public final static Cacheable DefaultOrgCache {
        get { return getOrgCache('Default'); }
    }
    public final static Cacheable DefaultSessionCache {
        get { return getSessionCache('Default'); }
    }
    // more cache partitions here

    // Implementation

    private enum CacheType { ORG, SESSION }

    private final static Map<CacheType, Map<String, Cacheable>> CACHE_MAP = new Map<CacheType, Map<String, Cacheable>>{
        CacheType.ORG => new Map<String, Cacheable>(),
        CacheType.SESSION => new Map<String, Cacheable>()
    };

    private static Cacheable getOrgCache(String partitionName) {
        if (!CACHE_MAP.get(CacheType.ORG).containsKey(partitionName)) {
            CACHE_MAP.get(CacheType.ORG).put(partitionName, new OrgPlatformCache(partitionName));
        }
        return CACHE_MAP.get(CacheType.ORG).get(partitionName);
    }

    private static Cacheable getSessionCache(String partitionName) {
        if (!CACHE_MAP.get(CacheType.SESSION).containsKey(partitionName)) {
            CACHE_MAP.get(CacheType.SESSION).put(partitionName, new SessionPlatformCache(partitionName));
        }
        return CACHE_MAP.get(CacheType.SESSION).get(partitionName);
    }

    private CacheManager() {}

    private static void validateKey(String key) {
        if (!Pattern.compile('^[a-zA-Z0-9]+$').matcher(key).matches()) {
            throw new IllegalArgumentException('Key must be alphanumeric, received key: ' + key);
        }
    }

    private class ApexTransactionCache implements Cacheable {
        private final Map<String, Object> TRANSACTION_CACHE = new Map<String, Object>();

        public Boolean contains(String key) {
            return this.TRANSACTION_CACHE.containsKey(key);
        }

        public Set<String> getKeys() {
            return TRANSACTION_CACHE.keySet();
        }

        public Object get(String key) {
            return this.TRANSACTION_CACHE.get(key);
        }

        public void put(String key, Object value) {
            validateKey(key);
            this.TRANSACTION_CACHE.put(key, value);
        }

        public void remove(String key) {
            this.TRANSACTION_CACHE.remove(key);
        }
    }

    private abstract class PlatformCache implements Cacheable {
        private Cache.Partition platformCachePartition;
        private CacheConfiguration__mdt configuration;
        private String partitionName;

        public PlatformCache(String partitionName) {
            this.partitionName = partitionName;
            this.setCacheConfiguration();
            this.platformCachePartition = getPartition();
        }

        private void setCacheConfiguration() {
            this.configuration = Schema.CacheConfiguration__mdt.getInstance(this.partitionName);

            if (this.configuration == null) {
               // throw new CacheManager.PlatformCacheException('Cache Configuration not found for the partition \'' + partitionName + '\'');
            }
        }

        abstract Cache.Partition getPartition();

        public Boolean contains(String key) {
            return this.platformCachePartition.contains(key);
        }

        public Set<String> getKeys() {
            return this.platformCachePartition.getKeys();
        }

        public Object get(String key) {
            return this.platformCachePartition?.get(key);
        }

        public void remove(String key) {
            this.platformCachePartition.remove(key);
        }

        public void put(String key, Object value) {
            validateKey(key);

            this.platformCachePartition?.put(
                key,
                value,
                1000,
                Cache.Visibility.valueOf(this.configuration.Visibility__c.toUpperCase()),
                this.configuration.IsCacheImmutable__c
            );
        }
    }

    private class OrgPlatformCache extends PlatformCache {
        public OrgPlatformCache(String partitionName) {
            super(partitionName);
        }

        public override Cache.Partition getPartition() {
            try {
                return Cache.Org.getPartition(this.partitionName);
            }  catch (Cache.Org.OrgCacheException orgCacheException) {
                return null;
                // No-op if the partition can't be found - the rest of the code will fallback to using the transaction cache
            }
        }
    }

    private class SessionPlatformCache extends PlatformCache {
        public SessionPlatformCache(String partitionName) {
            super(partitionName);
        }

        public override Cache.Partition getPartition() {
            try {
                return Cache.Session.getPartition(this.partitionName);
            }  catch (Cache.Session.SessionCacheException orgCacheException) {
                return null;
                // No-op if the partition can't be found - the rest of the code will fallback to using the transaction cache
            }
        }
    }
}
