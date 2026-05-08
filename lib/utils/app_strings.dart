class AppStrings {
  static bool isEnglish = false;

  static String get appName =>
      isEnglish ? "EcoScan AI" : "EcoScan AI";

  static String get login =>
      isEnglish ? "Login" : "Iniciar sesión";

  static String get register =>
      isEnglish ? "Register" : "Crear cuenta";

  static String get email =>
      isEnglish ? "Email" : "Correo";

  static String get password =>
      isEnglish ? "Password" : "Contraseña";

  static String get takePhoto =>
      isEnglish ? "Take Photo" : "Tomar foto";

  static String get analyze =>
      isEnglish ? "Analyze with AI" : "Analizar con IA";

  static String get stats =>
      isEnglish ? "Stats" : "Estadísticas";

  static String get noReports =>
      isEnglish ? "No reports yet" : "No hay reportes";

  static String get logout =>
      isEnglish ? "Logout" : "Cerrar sesión";
}