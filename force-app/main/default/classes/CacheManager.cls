public with sharing class CacheManager {
    public interface Cacheable {
        Object get(String key);
        void put(String key, Object value);
    }

    public interface PlatformCacheable {
        PlatformCacheable partition(String partitionName);
        Object get(String key);
        void put(String key, Object value);
    }

    public interface TransactionCacheable {
        Object get(String key);
        void put(String key, Object value);
    }

    public static TransactionCacheable TransactionCache {
        get {
            if (TransactionCache == null) {
                TransactionCache = new ApexTransactionCache();
            }
            return  new ApexTransactionCache();
        }
        private set;
    }

    public static PlatformCacheable OrgCache {
        get {
            if (OrgCache == null) {
                OrgCache = new OrgPlatformCache();
            }
            return OrgCache;
        }
        private set;
    }

    public static PlatformCacheable SessionCache {
        get {
            if (SessionCache == null) {
                SessionCache = new SessionPlatformCache();
            }
            return SessionCache;
        }
        private set;
    }

    // Implementation

    // PlatformCacheConfig =>
    //     partitionA => {
    //         ttl: 3600,
    //         cacheVisibility: Cache.Visibility.ALL,
    //         cannotBeOverride: true
    //     },
    //     partitionB => {
    //         ttl: 3600,
    //         cacheVisibility: Cache.Visibility.ALL,
    //         cannotBeOverride: true
    //     }
    // }
    // if no config save to default partition
    // throw error that parition config is not provided


    private CacheManager() {}

    // Transaction

    private class ApexTransactionCache implements TransactionCacheable {
        public Object get(String key) {
            return null;
        }

        public void put(String key, Object value) {

        }
    }

    // Platform Cache

    private static final Map<String, PlatformCacheConfig> PARTITION_CONFIGURATION = new Map<String, PlatformCacheConfig>{
        'partitionA' => new PlatformCacheConfig().orgCacheTimeToLive(86400).sessionCacheTimeToLive(28800),
        'partitionB' => new PlatformCacheConfig().orgCacheTimeToLive(86400).sessionCacheTimeToLive(28800)
    };

    private class PlatformCacheConfig {
        public Integer sessionCacheTimeToLive = 28800;
        public Integer orgCacheTimeToLive = 86400;
        public Boolean isCacheImmutable = false;
        public Cache.Visibility cacheVisibility = Cache.Visibility.ALL;

        public PlatformCacheConfig orgCacheTimeToLive(Integer timeToLive) {
            this.orgCacheTimeToLive = timeToLive;
            return this;
        }

        public PlatformCacheConfig sessionCacheTimeToLive(Integer timeToLive) {
            this.sessionCacheTimeToLive = timeToLive;
            return this;
        }

        public PlatformCacheConfig cacheVisibility(Cache.Visibility cacheVisibility) {
            this.cacheVisibility = cacheVisibility;
            return this;
        }

        public PlatformCacheConfig cacheImmutable() {
            this.isCacheImmutable = true;
            return this;
        }
    }

    private abstract class PlatformCache implements PlatformCacheable {
        private Cache.Partition platformCachePartition;

        abstract Cache.Partition getPartition(String partitionName);

        public PlatformCacheable partition(String partitionName) {
            this.platformCachePartition = getPartition(partitionName);
            return this;
        }

        public Object get(String key) {
            return this.platformCachePartition?.get(key);
        }

        public void put(String key, Object value) {
            this.platformCachePartition?.put(key, value, cacheTtlSeconds, cacheVisiblity, isCacheImmutable);

        }
    }

    private class OrgPlatformCache extends PlatformCache {
        public override Cache.Partition getPartition(String partitionName) {
            return Cache.Org.getPartition(partitionName);
        }
    }

    private class SessionPlatformCache extends PlatformCache {
        public override Cache.Partition getPartition(String partitionName) {
            return Cache.Session.getPartition(partitionName);
        }
    }
}

// CacheManager.organizationCache().put('myKey', 'myValue', 3600);
// CacheManager.organizationCache().get('myKey');
// CacheManager.organizationCache().remove('myKey');
// CacheManager.organizationCache().contains('myKey');

// CacheManager.TransactionCache.put('Account', [SELECT Id, Name FROM Account]);

/*
0. Metadata (optional)
1. Different partition should be supported.
2. PlatformCacheable and TransactionCacheable should have different methods. eg. ttl does not apply to TransactionCacheable
*/


// CacheManager.OrgCache.partition('SOQL').put('Account', [SELECT Id FROM Account]);
// CacheManager.TransactionCacheable.put('Account', [SELECT Id FROM Account]);
