public with sharing class CacheManager {
    public interface PlatformCacheable {
        PlatformCacheable partition(String partitionName);
        Boolean contains(String key);
        Object get(String key);
        void put(String key, Object value);
        void remove(String key);
    }

    public interface TransactionCacheable {
        Boolean contains(String key);
        Object get(String key);
        void put(String key, Object value);
        void remove(String key);
    }

    public static TransactionCacheable TransactionCache = new ApexTransactionCache();
    public static PlatformCacheable OrgCache = new OrgPlatformCache();
    public static PlatformCacheable SessionCache = new SessionPlatformCache();

    // Implementation

    private CacheManager() {}

    // Transaction

    private class ApexTransactionCache implements TransactionCacheable {
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

    // Platform Cache

    private abstract class PlatformCache implements PlatformCacheable {
        private Cache.Partition platformCachePartition;
        private CacheConfiguration__mdt configuration;

        abstract Cache.Partition getPartition(String partitionName);

        public PlatformCacheable partition(String partitionName) {
            this.platformCachePartition = getPartition(partitionName);
            this.configuration = Schema.CacheConfiguration__mdt.getInstance(partitionName);
            return this;
        }

        public Object get(String key) {
            return this.platformCachePartition?.get(key);
        }

        public void put(String key, Object value) {
            // this.platformCachePartition?.put(key, value, cacheTtlSeconds, cacheVisiblity, isCacheImmutable);

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
