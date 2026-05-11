class AppStrings {
  static bool isEnglish = false;

  // APP

  static String get appName =>
      "EcoScan AI";

  // AUTH

  static String get login =>
      isEnglish
          ? "Login"
          : "Iniciar sesión";

  static String get register =>
      isEnglish
          ? "Register"
          : "Crear cuenta";

  static String get email =>
      isEnglish
          ? "Email"
          : "Correo";

  static String get password =>
      isEnglish
          ? "Password"
          : "Contraseña";

  static String get logout =>
      isEnglish
          ? "Logout"
          : "Cerrar sesión";

  // REPORT SCREEN

  static String get aiEnvironmentalAnalysis =>
      isEnglish
          ? "AI Environmental Analysis"
          : "Análisis Ambiental con IA";

  static String get analyzeEnvironmentalWaste =>
      isEnglish
          ? "Analyze environmental waste with artificial intelligence"
          : "Analiza residuos ambientales con inteligencia artificial";

  static String get noImageSelected =>
      isEnglish
          ? "No image selected"
          : "Ninguna imagen seleccionada";

  static String get captureImage =>
      isEnglish
          ? "Capture Image"
          : "Capturar imagen";

  static String get analyze =>
      isEnglish
          ? "Analyze with AI"
          : "Analizar con IA";

  static String get saveReport =>
      isEnglish
          ? "Save Report"
          : "Guardar reporte";

  static String get detectedWaste =>
      isEnglish
          ? "Detected Waste"
          : "Residuo detectado";

  static String get environmentalImpact =>
      isEnglish
          ? "Environmental Impact"
          : "Impacto ambiental";

  static String get aiDescription =>
      isEnglish
          ? "AI Description"
          : "Descripción IA";

  static String get reportSaved =>
      isEnglish
          ? "Report saved successfully"
          : "Reporte guardado correctamente";

  // DASHBOARD

  static String get environmentalDashboard =>
      isEnglish
          ? "Environmental Dashboard"
          : "Panel Ambiental";

  static String get dashboardSubtitle =>
      isEnglish
          ? "AI-powered environmental monitoring dashboard"
          : "Panel de monitoreo ambiental impulsado por IA";

  static String get reports =>
      isEnglish
          ? "Reports"
          : "Reportes";

  static String get highImpact =>
      isEnglish
          ? "High Impact"
          : "Impacto Alto";

  static String get medium =>
      isEnglish
          ? "Medium"
          : "Medio";

  static String get low =>
      isEnglish
          ? "Low"
          : "Bajo";

  static String get recentReports =>
      isEnglish
          ? "Recent Reports"
          : "Reportes recientes";

  static String get noReports =>
      isEnglish
          ? "No reports yet"
          : "No hay reportes";

  // HISTORY

  static String get reportsHistory =>
      isEnglish
          ? "Reports History"
          : "Historial de reportes";

  static String get noReportsFound =>
      isEnglish
          ? "No reports found"
          : "No se encontraron reportes";

  static String get searchReports =>
      isEnglish
          ? "Search reports..."
          : "Buscar reportes...";

  static String get all =>
      isEnglish
          ? "All"
          : "Todos";

  static String get newest =>
      isEnglish
          ? "Newest"
          : "Más recientes";

  static String get oldest =>
      isEnglish
          ? "Oldest"
          : "Más antiguos";

  // NAVIGATION

  static String get scan =>
      isEnglish
          ? "Scan"
          : "Escanear";

  static String get map =>
      isEnglish
          ? "Map"
          : "Mapa";

  static String get stats =>
      isEnglish
          ? "Stats"
          : "Estadísticas";
}