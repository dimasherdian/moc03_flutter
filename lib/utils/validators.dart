class Validators {
  static String? validateUsername(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Username wajib diisi!';
    }
    if (value.trim().length < 4) {
      return 'Username minimal 4 karakter!';
    }
    // Hanya memperbolehkan huruf dan angka (tanpa spasi)
    if (!RegExp(r'^[a-zA-Z0-9]+$').hasMatch(value)) {
      return 'Username hanya boleh berisi huruf dan angka tanpa spasi!';
    }
    return null;
  }

  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password wajib diisi!';
    }
    if (value.length < 6) {
      return 'Password minimal 6 karakter!';
    }
    return null;
  }
}
