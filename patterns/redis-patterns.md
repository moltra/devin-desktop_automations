# Redis Integration Patterns

This document describes Redis integration patterns for resilient and performant applications.

## Connection Resilience

### Connection Pool Pattern

```python
import redis
from redis.exceptions import ConnectionError, TimeoutError

redis_client = redis.Redis(
    host='localhost',
    port=6379,
    db=0,
    socket_timeout=5,
    socket_connect_timeout=5,
    retry_on_timeout=True,
    health_check_interval=30
)
```

### Error Handling Pattern

```python
def get_with_fallback(key):
    try:
        value = redis_client.get(key)
        if value is None:
            return None
        return json.loads(value)
    except (ConnectionError, TimeoutError) as e:
        logger.warning(f"Redis connection error: {e}")
        # Fallback to local cache
        return local_cache.get(key)
```

## Fallback Strategies

### Local Memory Cache Pattern

```python
import threading

class LocalCache:
    def __init__(self):
        self._cache = {}
        self._lock = threading.Lock()
    
    def get(self, key):
        with self._lock:
            return self._cache.get(key)
    
    def set(self, key, value):
        with self._lock:
            self._cache[key] = value
    
    def delete(self, key):
        with self._lock:
            self._cache.pop(key, None)

local_cache = LocalCache()
```

### Transparent Fallback Pattern

```python
def get_data(key):
    # Try Redis first
    try:
        value = redis_client.get(key)
        if value is not None:
            return json.loads(value)
    except (ConnectionError, TimeoutError) as e:
        logger.warning(f"Redis unavailable, using fallback: {e}")
    
    # Fallback to local cache
    return local_cache.get(key)

def set_data(key, value):
    serialized = json.dumps(value)
    
    # Try Redis first
    try:
        redis_client.setex(key, ttl, serialized)
    except (ConnectionError, TimeoutError) as e:
        logger.warning(f"Redis unavailable, using fallback: {e}")
    
    # Always set in local cache
    local_cache.set(key, value)
```

## Serialization Patterns

### JSON Serialization Pattern

```python
import json
import orjson  # Faster JSON library

def set_json(key, data, ttl=300):
    try:
        serialized = orjson.dumps(data)
        redis_client.setex(key, ttl, serialized)
    except (ConnectionError, TimeoutError) as e:
        logger.warning(f"Redis error: {e}")
        local_cache.set(key, data)

def get_json(key):
    try:
        value = redis_client.get(key)
        if value is None:
            return None
        return orjson.loads(value)
    except (ConnectionError, TimeoutError) as e:
        logger.warning(f"Redis error: {e}")
        return local_cache.get(key)
```

### Complex Object Serialization

```python
# BAD: Direct string conversion
redis_client.set("key", str(complex_object))

# GOOD: Explicit JSON serialization
redis_client.set("key", json.dumps(complex_object.__dict__))
```

## Pagination and Scanning

### SCAN Pattern (Avoid KEYS)

```python
# BAD: Blocks Redis server
keys = redis_client.keys("pattern*")

# GOOD: Non-blocking SCAN
cursor = 0
keys = []
while True:
    cursor, batch = redis_client.scan(cursor=cursor, match="pattern*", count=100)
    keys.extend(batch)
    if cursor == 0:
        break
```

### Sorted Set Pagination Pattern

```python
def add_to_sorted_set(key, member, score):
    redis_client.zadd(key, {member: score})

def get_paginated(key, offset=0, limit=10):
    return redis_client.zrange(key, offset, offset + limit - 1, withscores=True)
```

## TTL Management

### Automatic TTL Pattern

```python
def cache_with_ttl(key, value, ttl=300):
    """Always set TTL to prevent unbounded memory growth"""
    serialized = json.dumps(value)
    redis_client.setex(key, ttl, serialized)
```

### TTL Check Pattern

```python
def get_or_set(key, func, ttl=300):
    """Get from cache or compute and cache"""
    value = redis_client.get(key)
    if value is not None:
        return json.loads(value)
    
    # Compute and cache
    result = func()
    cache_with_ttl(key, result, ttl)
    return result
```

## Database Selection

### Database Configuration Pattern

```python
import os

REDIS_DB = int(os.getenv('REDIS_DB', '0'))  # Default to db 0

redis_client = redis.Redis(
    host='localhost',
    port=6379,
    db=REDIS_DB,
    socket_timeout=5
)
```

## Common Issues

### Issue: KEYS Command in Production

**Problem:** `KEYS *` blocks Redis server

**Solution:** Use `SCAN` with cursor

### Issue: No TTL on Cached Keys

**Problem:** Unbounded memory growth

**Solution:** Always set TTL on cached keys

### Issue: Naked Exception Handling

**Problem:** Silent failures

**Solution:** Catch specific exceptions and log

## Customization Notes

When customizing these patterns for your project:

1. **Add project-specific Redis configurations** (database numbers, connection strings)
2. **Include project-specific serialization patterns** if you use custom serializers
3. **Add project-specific fallback strategies** for your infrastructure
4. **Include project-specific TTL values** based on your data characteristics
5. **Add project-specific monitoring patterns** for Redis health
6. **Add project-specific cluster patterns** if you use Redis Cluster
