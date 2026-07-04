# Streamlit Performance Patterns

This document describes performance optimization patterns for Streamlit applications.

## Session State Management

### Initialization Pattern

```python
# Initialize session state safely
if "key" not in st.session_state:
    st.session_state.key = default_value
```

**Best practices:**
- Always initialize session state variables before use
- Use descriptive key names
- Group related state variables with prefixes (e.g., `user_name`, `user_email`)

### State Persistence Pattern

```python
# Persist feedback across reruns
if "feedback" not in st.session_state:
    st.session_state.feedback = ""

if st.button("Submit"):
    st.session_state.feedback = "Success!"
    st.rerun()

# Display persisted feedback
if st.session_state.feedback:
    st.success(st.session_state.feedback)
```

## Caching Strategies

### Data Caching Pattern

```python
@st.cache_data(ttl=300)  # 5 minutes for semi-static data
def fetch_config():
    return load_configuration()

@st.cache_data(ttl=5)  # 5 seconds for frequently-changing data
def fetch_status():
    return get_current_status()
```

**TTL Guidelines:**
- Static data (config, provider lists): 60-300 seconds
- Semi-static data (user lists, task lists): 10-30 seconds
- Dynamic data (status, metrics): 3-5 seconds

### Resource Caching Pattern

```python
@st.cache_resource
def get_redis_client():
    return redis.Redis(host='localhost', port=6379, db=0)

@st.cache_resource
def get_http_session():
    return requests.Session()
```

**Use cases:**
- Database connections
- HTTP sessions
- Redis clients
- ML model instances

### Cache Invalidation Pattern

```python
def update_data(new_data):
    # Update data source
    save_data(new_data)
    
    # Clear cache to force refresh
    st.cache_data.clear()
    
    # Rerun to display updated data
    st.rerun()
```

## Rerun Optimization

### Batch State Changes Pattern

```python
# BAD: Multiple reruns
st.session_state.value1 = x
st.rerun()
st.session_state.value2 = y
st.rerun()

# GOOD: Batch changes, single rerun
st.session_state.value1 = x
st.session_state.value2 = y
st.rerun()
```

### Fragment Pattern for Auto-Refresh

```python
with st.fragment():
    if st.button("Refresh"):
        st.rerun()
    
    # Auto-refresh every 5 seconds
    time.sleep(5)
    st.rerun()
```

## UI Performance Patterns

### Lazy Loading Pattern

```python
# Only load expensive components when needed
if st.checkbox("Show Advanced Options"):
    with st.expander("Advanced"):
        # Expensive component
        render_advanced_options()
```

### Conditional Rendering Pattern

```python
# Avoid rendering expensive components unnecessarily
if should_show_component:
    render_expensive_component()
```

## Memory Management

### Cleanup Pattern

```python
# Clean up temporary files
import tempfile
import os

def process_data(data):
    with tempfile.NamedTemporaryFile(delete=False) as tmp:
        tmp.write(data)
        tmp_path = tmp.name
    
    try:
        result = process_file(tmp_path)
        return result
    finally:
        # Always clean up
        if os.path.exists(tmp_path):
            os.unlink(tmp_path)
```

## Common Performance Issues

### Issue: Expensive Operations on Every Rerun

**Problem:** Heavy computations run on every script execution

**Solution:** Use `@st.cache_data` for expensive operations

```python
@st.cache_data
def expensive_computation(input_data):
    # Heavy computation here
    return result
```

### Issue: Excessive Reruns

**Problem:** Too many `st.rerun()` calls causing performance issues

**Solution:** Batch state changes and use single rerun

### Issue: Memory Leaks

**Problem:** Session state grows unbounded

**Solution:** Implement cleanup strategies and use appropriate TTLs

## Customization Notes

When customizing these patterns for your project:

1. **Add project-specific caching requirements** based on your data characteristics
2. **Include project-specific session state patterns** your application uses
3. **Add project-specific performance thresholds** (response times, etc.)
4. **Include project-specific UI patterns** your team follows
5. **Add project-specific memory management strategies** for your data types
