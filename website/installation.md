# Installation

Install Cache Manager in your Salesforce org.

## Using Salesforce CLI

### Deploy Source Code

```bash
# Clone the repository
git clone https://github.com/beyond-the-cloud-dev/cache-manager.git
cd cache-manager

# Deploy to your org
sf project deploy start --target-org your-org-alias
```

## Manual Installation

### Using Setup UI

1. Navigate to **Setup** → **Apex Classes**
2. Click **New**
3. Copy the code from [CacheManager.cls](https://github.com/beyond-the-cloud-dev/cache-manager/blob/main/force-app/main/default/classes/CacheManager.cls)
4. Save the class

## Platform Cache Setup

For org and session cache, you need to set up Platform Cache partitions:

1. Go to **Setup** → **Platform Cache**
2. Create a partition named `Default`
3. Allocate capacity for org and session cache

## Dependencies

Cache Manager has **zero code dependencies**. It only requires Platform Cache be available in your org.

## API Version

Requires Salesforce API version **57.0** or higher.

## Verification

Test the installation:

```apex
// Test transaction cache
CacheManager.ApexTransaction.put('test', 'value');
String value = (String) CacheManager.ApexTransaction.get('test');
System.assertEquals('value', value);

// Test org cache (requires Platform Cache setup)
CacheManager.DefaultOrgCache.put('test', 'value');
String orgValue = (String) CacheManager.DefaultOrgCache.get('test');
System.assertEquals('value', orgValue);
```

If these work, you're all set! ✅

## Next Steps

- [Getting Started Guide](/getting-started)
- [API Reference](/api)
- [Examples](/examples)
