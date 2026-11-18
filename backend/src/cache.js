/**
 * Tiny in-memory TTL cache. Railway data is expensive upstream, so identical
 * reads within a short window are served locally.
 */
const store = new Map();

export function cached(key, ttlMs, loader) {
  const now = Date.now();
  const hit = store.get(key);
  if (hit && hit.expiresAt > now) {
    return Promise.resolve(hit.value);
  }

  return Promise.resolve(loader()).then((value) => {
    store.set(key, { value, expiresAt: now + ttlMs });
    if (store.size > 500) {
      for (const [entryKey, entry] of store) {
        if (entry.expiresAt <= now) store.delete(entryKey);
      }
    }
    return value;
  });
}

export function clearCache() {
  store.clear();
}
