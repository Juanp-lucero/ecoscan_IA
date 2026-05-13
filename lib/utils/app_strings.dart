class AppStrings {
  static bool isEnglish = false;

  // APP
  static String get appName =>
      isEnglish ? "EcoScan AI" : "EcoScan AI";

  // AUTH
  static String get login =>
      isEnglish ? "Login" : "Iniciar sesión";

  static String get register =>
      isEnglish ? "Register" : "Crear cuenta";

  static String get email =>
      isEnglish ? "Email" : "Correo";

  static String get password =>
      isEnglish ? "Password" : "Contraseña";

  static String get logout =>
      isEnglish ? "Logout" : "Cerrar sesión";

  // VALIDATIONS
  static String get emailRequired =>
      isEnglish
          ? "Email required"
          : "Falta ingresar el correo";

  static String get invalidEmail =>
      isEnglish
          ? "Invalid email"
          : "Correo inválido";

  static String get passwordRequired =>
      isEnglish
          ? "Password required"
          : "Falta ingresar la contraseña";

  static String get minCharacters =>
      isEnglish
          ? "Minimum 6 characters"
          : "Mínimo 6 caracteres";

  static String get noAccount =>
      isEnglish
          ? "Don't have an account? Register"
          : "¿No tienes cuenta? Crear cuenta";

  static String get alreadyAccount =>
      isEnglish
          ? "Already have an account? Login"
          : "¿Ya tienes cuenta? Iniciar sesión";

  // REPORT SCREEN
  static String get takePhoto =>
      isEnglish ? "Take Photo" : "Tomar foto";

  static String get analyze =>
      isEnglish
          ? "Analyze with AI"
          : "Analizar con IA";

  static String get analyzeEnvironmentalWaste =>
      isEnglish
          ? "AI Environmental Analysis"
          : "Análisis Ambiental con IA";

  static String get analyzeEnvironmentalWasteSubtitle =>
      isEnglish
          ? "Analyze environmental waste with artificial intelligence"
          : "Analiza residuos ambientales con inteligencia artificial";

  static String get aiEnvironmentalAnalysis =>
      isEnglish
          ? "AI Environmental Analysis"
          : "Análisis Ambiental con IA";

  static String get noImageSelected =>
      isEnglish
          ? "No image selected"
          : "No hay imagen seleccionada";

  static String get captureImage =>
      isEnglish
          ? "Capture Image"
          : "Capturar Imagen";

  static String get saveReport =>
      isEnglish
          ? "Save Report"
          : "Guardar Reporte";

  static String get reportSaved =>
      isEnglish
          ? "Report saved successfully"
          : "Reporte guardado correctamente";

  static String get detectedWaste =>
      isEnglish
          ? "Detected Waste"
          : "Residuo Detectado";

  static String get environmentalImpact =>
      isEnglish
          ? "Environmental Impact"
          : "Impacto Ambiental";

  static String get aiDescription =>
      isEnglish
          ? "AI Description"
          : "Descripción IA";

  // DASHBOARD
  static String get stats =>
      isEnglish ? "Stats" : "Estadísticas";

  static String get environmentalDashboard =>
      isEnglish
          ? "Environmental Dashboard"
          : "Panel Ambiental";

  static String get dashboardSubtitle =>
      isEnglish
          ? "AI-powered environmental monitoring dashboard"
          : "Panel de monitoreo ambiental impulsado por IA";

  static String get reports =>
      isEnglish ? "Reports" : "Reportes";

  static String get highImpact =>
      isEnglish
          ? "High Impact"
          : "Alto Impacto";

  static String get high =>
      isEnglish ? "High" : "Alto";

  static String get medium =>
      isEnglish ? "Medium" : "Medio";

  static String get low =>
      isEnglish ? "Low" : "Bajo";

  static String get impactDistribution =>
      isEnglish
          ? "Impact Distribution"
          : "Distribución de Impacto";

  static String get recentReports =>
      isEnglish
          ? "Recent Reports"
          : "Reportes Recientes";

  static String get noReports =>
      isEnglish
          ? "No reports yet"
          : "No hay reportes";

  // MAP
  static String get map =>
      isEnglish ? "Map" : "Mapa";

  static String get environmentalHotspots =>
      isEnglish
          ? "Environmental Hotspots"
          : "Zonas Ambientales";

  static String get hotspotDescription =>
      isEnglish
          ? "Monitor high-impact pollution zones in real time."
          : "Monitorea zonas de contaminación de alto impacto en tiempo real.";

  static String get highPollutionArea =>
      isEnglish
          ? "High Pollution Area"
          : "Zona de Alta Contaminación";

  static String get plasticWasteDetected =>
      isEnglish
          ? "Plastic Waste Detected"
          : "Residuos Plásticos Detectados";

  // HISTORY
  static String get reportsHistory =>
      isEnglish
          ? "Reports History"
          : "Historial de Reportes";

  static String get searchReports =>
      isEnglish
          ? "Search reports..."
          : "Buscar reportes...";

  static String get allImpacts =>
      isEnglish
          ? "All Impacts"
          : "Todos los Impactos";

  static String get newest =>
      isEnglish ? "Newest" : "Más recientes";

  static String get oldest =>
      isEnglish ? "Oldest" : "Más antiguos";

  static String get noReportsFound =>
      isEnglish
          ? "No reports found"
          : "No se encontraron reportes";
}