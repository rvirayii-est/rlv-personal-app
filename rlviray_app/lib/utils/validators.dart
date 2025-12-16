class Validators {
  // Email validation
  static bool isValidEmail(String email) {
    if (email.isEmpty) return false;
    final emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );
    return emailRegex.hasMatch(email);
  }

  // Name validation
  static bool isValidName(String name) {
    if (name.isEmpty) return false;
    if (name.length < 2) return false;
    if (name.length > 50) return false;
    final nameRegex = RegExp(r'^[a-zA-Z\s]+$');
    return nameRegex.hasMatch(name);
  }

  // Password validation
  static bool isValidPassword(String password) {
    if (password.isEmpty) return false;
    return password.length >= 6;
  }

  // Phone number validation (basic)
  static bool isValidPhone(String phone) {
    if (phone.isEmpty) return false;
    final phoneRegex = RegExp(r'^\+?[\d\s\-()]+$');
    return phoneRegex.hasMatch(phone) && phone.replaceAll(RegExp(r'[\s\-()]'), '').length >= 10;
  }

  // URL validation
  static bool isValidUrl(String url) {
    if (url.isEmpty) return false;
    try {
      final uri = Uri.parse(url);
      return uri.hasScheme && uri.hasAuthority;
    } catch (e) {
      return false;
    }
  }

  // Empty string check
  static bool isNotEmpty(String? value) {
    return value != null && value.trim().isNotEmpty;
  }

  // Length validation
  static bool hasMinLength(String value, int minLength) {
    return value.length >= minLength;
  }

  static bool hasMaxLength(String value, int maxLength) {
    return value.length <= maxLength;
  }

  // Numeric validation
  static bool isNumeric(String value) {
    if (value.isEmpty) return false;
    return double.tryParse(value) != null;
  }

  // Integer validation
  static bool isInteger(String value) {
    if (value.isEmpty) return false;
    return int.tryParse(value) != null;
  }
}

class ValidationMessages {
  static const String requiredField = 'This field is required';
  static const String invalidEmail = 'Please enter a valid email address';
  static const String invalidName = 'Please enter a valid name (2-50 characters)';
  static const String invalidPassword = 'Password must be at least 6 characters';
  static const String invalidPhone = 'Please enter a valid phone number';
  static const String invalidUrl = 'Please enter a valid URL';
  static const String invalidNumeric = 'Please enter a valid number';
}
