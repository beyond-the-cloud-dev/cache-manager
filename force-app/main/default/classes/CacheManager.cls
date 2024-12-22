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
        void put(String key, Object value);
        void remove(String key);
    }

    public final static Cacheable ApexTransaction = new ApexTransactionCache();
    // public final static Cacheable SOQLOrg = getOrgCache('SOQL');
    // public final static Cacheable SOQLSession = getSessionCache('SOQL');
    // more cache partitions here

    private enum CacheType { ORG, SESSION }

    private static final Map<CacheType, Map<String, Cacheable>> CACHEABLE = new Map<CacheType, Map<String, Cacheable>>{
        CacheType.ORG => new Map<String, Cacheable>(),
        CacheType.SESSION => new Map<String, Cacheable>()
    };

    private static Cacheable getOrgCache(String partitionName) {
        if (!CACHEABLE.get(CacheType.ORG).containsKey(partitionName)) {
            CACHEABLE.get(CacheType.ORG).put(partitionName, new OrgPlatformCache(partitionName));
        }
        return CACHEABLE.get(CacheType.ORG).get(partitionName);
    }

    private static Cacheable getSessionCache(String partitionName) {
        if (!CACHEABLE.get(CacheType.SESSION).containsKey(partitionName)) {
            CACHEABLE.get(CacheType.SESSION).put(partitionName, new SessionPlatformCache(partitionName));
        }
        return CACHEABLE.get(CacheType.SESSION).get(partitionName);
    }

    // Implementation

    private CacheManager() {}

    private class ApexTransactionCache implements Cacheable {
        private final Map<String, Object> TRANSACTION_CACHE = new Map<String, Object>();

        public Boolean contains(String key) {
            return this.TRANSACTION_CACHE.containsKey(key);
        }

        public Object get(String key) {
            return this.TRANSACTION_CACHE.get(key);
        }

        public void put(String key, Object value) {
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
            this.setCachePartition();
        }

        private void setCacheConfiguration() {
            this.configuration = Schema.CacheConfiguration__mdt.getInstance(this.partitionName);
            if (this.configuration == null) {
               // throw new CacheManager.PlatformCacheException('Cache Configuration not found for the partition \'' + partitionName + '\'');
            }
        }

        private void setCachePartition() {
            try {
                this.platformCachePartition = getPartition();
            }  catch (Cache.Org.OrgCacheException orgCacheException) {
                // No-op if the partition can't be found - the rest of the code will fallback to using the transaction cache
            } catch (Cache.Session.SessionCacheException sessionCacheException) {
                // No-op if the partition can't be found - the rest of the code will fallback to using the transaction cache
            }
        }

        abstract Cache.Partition getPartition();

        public Boolean contains(String key) {
            return this.platformCachePartition.contains(key);
        }

        public Object get(String key) {
            return this.platformCachePartition?.get(key);
        }

        public void remove(String key) {
            this.platformCachePartition.remove(key);
        }

        public void put(String key, Object value) {
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
            return Cache.Org.getPartition(this.partitionName);
        }
    }

    private class SessionPlatformCache extends PlatformCache {
        public SessionPlatformCache(String partitionName) {
            super(partitionName);
        }

        public override Cache.Partition getPartition() {
            return Cache.Session.getPartition(this.partitionName);
        }
    }
}
