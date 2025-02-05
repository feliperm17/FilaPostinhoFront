class RateLimiter {
  static final Map<String, DateTime> _lastAttempts = {};
  static const _minInterval = Duration(seconds: 2);

  static bool canProceed(String action) {
    final now = DateTime.now();
    final lastAttempt = _lastAttempts[action];

    if (lastAttempt == null || now.difference(lastAttempt) > _minInterval) {
      _lastAttempts[action] = now;
      return true;
    }
    return false;
  }

  static Duration timeUntilNext(String action) {
    final lastAttempt = _lastAttempts[action];
    if (lastAttempt == null) return Duration.zero;

    final timePassed = DateTime.now().difference(lastAttempt);
    return _minInterval - timePassed;
  }
}
