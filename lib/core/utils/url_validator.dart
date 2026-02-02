/// URL validation utility to prevent SSRF attacks
///
/// Only allows loading images from trusted domains to prevent
/// server-side request forgery and data exfiltration.
class UrlValidator {
  UrlValidator._();

  /// Allowed domains for image loading
  /// Add your Supabase project URL domain here
  static const _allowedDomains = [
    'supabase.co',
    'supabase.in',
  ];

  /// Additional allowed domain patterns (for custom domains)
  static const _allowedPatterns = <RegExp>[];

  /// Check if a URL is from an allowed domain for image loading
  static bool isAllowedImageUrl(String? url) {
    if (url == null || url.isEmpty) return false;

    try {
      final uri = Uri.parse(url);

      // Only allow HTTPS
      if (uri.scheme != 'https') return false;

      // Check against allowed domains
      final host = uri.host.toLowerCase();

      // Check exact domain or subdomain match
      for (final domain in _allowedDomains) {
        if (host == domain || host.endsWith('.$domain')) {
          return true;
        }
      }

      // Check against patterns
      for (final pattern in _allowedPatterns) {
        if (pattern.hasMatch(host)) {
          return true;
        }
      }

      return false;
    } catch (_) {
      return false;
    }
  }

  /// Validate a URL is well-formed and uses HTTPS
  static bool isValidHttpsUrl(String? url) {
    if (url == null || url.isEmpty) return false;

    try {
      final uri = Uri.parse(url);
      return uri.scheme == 'https' && uri.host.isNotEmpty;
    } catch (_) {
      return false;
    }
  }

  /// Check if URL points to localhost or private networks (for SSRF prevention)
  static bool isPrivateOrLocalUrl(String? url) {
    if (url == null || url.isEmpty) return true;

    try {
      final uri = Uri.parse(url);
      final host = uri.host.toLowerCase();

      // Block localhost
      if (host == 'localhost' || host == '127.0.0.1' || host == '::1') {
        return true;
      }

      // Block private IP ranges
      final ipPattern = RegExp(r'^(\d{1,3})\.(\d{1,3})\.(\d{1,3})\.(\d{1,3})$');
      final match = ipPattern.firstMatch(host);
      if (match != null) {
        final first = int.parse(match.group(1)!);
        final second = int.parse(match.group(2)!);

        // 10.x.x.x
        if (first == 10) return true;
        // 172.16.x.x - 172.31.x.x
        if (first == 172 && second >= 16 && second <= 31) return true;
        // 192.168.x.x
        if (first == 192 && second == 168) return true;
        // 169.254.x.x (link-local)
        if (first == 169 && second == 254) return true;
      }

      return false;
    } catch (_) {
      return true;
    }
  }
}
