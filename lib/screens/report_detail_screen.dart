import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../services/supabase_service.dart';
import 'report_edit_screen.dart';

class ReportDetailScreen extends StatelessWidget {
  final Map<String, dynamic> report;

  const ReportDetailScreen({
    super.key,
    required this.report,
  });

  Color getImpactColor(String impact) {
    final value = impact.toLowerCase();

    if (value.contains('high')) {
      return Colors.redAccent;
    }

    if (value.contains('medium')) {
      return Colors.orangeAccent;
    }

    return Colors.greenAccent;
  }

  IconData getImpactIcon(String impact) {
    final value = impact.toLowerCase();

    if (value.contains('high')) {
      return Icons.warning_rounded;
    }

    if (value.contains('medium')) {
      return Icons.info_rounded;
    }

    return Icons.eco_rounded;
  }

  Future<void> openLocation(BuildContext context) async {
    final latitude = report['latitude'];
    final longitude = report['longitude'];

    if (latitude == null || longitude == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: Colors.redAccent,
          content: Text('Location not available'),
        ),
      );

      return;
    }

    final uri = Uri.parse(
      'https://www.google.com/maps/search/?api=1&query=$latitude,$longitude',
    );

    if (!await launchUrl(
      uri,
      mode: LaunchMode.externalApplication,
    )) {
      if (!context.mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: Colors.redAccent,
          content: Text('Could not open location'),
        ),
      );
    }
  }

  Future<void> openEditScreen(BuildContext context) async {
    final wasUpdated = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ReportEditScreen(
          report: report,
        ),
      ),
    );

    if (wasUpdated == true && context.mounted) {
      Navigator.pop(context, true);
    }
  }

  Future<void> confirmDelete(BuildContext context) async {
    final id = report['id'];

    if (id == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: Colors.redAccent,
          content: Text('Invalid report ID'),
        ),
      );

      return;
    }

    final shouldDelete = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          backgroundColor: const Color(0xFF11212D),
          title: const Text(
            'Delete report',
            style: TextStyle(color: Colors.white),
          ),
          content: const Text(
            'Are you sure you want to delete this report?',
            style: TextStyle(color: Colors.white70),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext, false);
              },
              child: const Text(
                'Cancel',
                style: TextStyle(color: Colors.white70),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext, true);
              },
              child: const Text(
                'Delete',
                style: TextStyle(color: Colors.redAccent),
              ),
            ),
          ],
        );
      },
    );

    if (shouldDelete != true) return;

    try {
      await SupabaseService().deleteReport(id);

      if (!context.mounted) return;

      Navigator.pop(context, true);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: Colors.green,
          content: Text('Report deleted successfully'),
        ),
      );
    } catch (e) {
      if (!context.mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.redAccent,
          content: Text('Error deleting report: $e'),
        ),
      );
    }
  }

  Widget buildActionButton({
    required String label,
    required IconData icon,
    required Color color,
    required VoidCallback onPressed,
  }) {
    return SizedBox(
      height: 52,
      child: ElevatedButton.icon(
        onPressed: onPressed,
        icon: Icon(icon),
        label: Text(
          label,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          foregroundColor: Colors.black,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
      ),
    );
  }

  Widget buildDetailCard({
    required String title,
    required String value,
    required IconData icon,
    required Color color,
  }) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: const Color(0xFF11212D),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: color.withOpacity(0.25),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            icon,
            color: color,
            size: 28,
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white54,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  value.isEmpty ? 'Not available' : value,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    height: 1.4,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final type = report['type']?.toString() ?? 'Unknown';
    final impact = report['impact']?.toString() ?? 'Unknown';
    final description = report['description']?.toString() ?? '';
    final toxicity = report['toxicity_level']?.toString() ?? '';
    final recycling =
        report['recycling_recommendation']?.toString() ?? '';
    final ecoAction = report['eco_action']?.toString() ?? '';
    final latitude = report['latitude']?.toString() ?? 'Not available';
    final longitude = report['longitude']?.toString() ?? 'Not available';
    final date = report['created_at']?.toString().substring(0, 10) ??
        'Not available';

    final impactColor = getImpactColor(impact);

    return Scaffold(
      backgroundColor: const Color(0xFF07111A),
      appBar: AppBar(
        backgroundColor: const Color(0xFF07111A),
        elevation: 0,
        title: const Text(
          'Report Details',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        iconTheme: const IconThemeData(
          color: Colors.greenAccent,
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(22),
            decoration: BoxDecoration(
              color: const Color(0xFF11212D),
              borderRadius: BorderRadius.circular(26),
              border: Border.all(
                color: impactColor.withOpacity(0.4),
              ),
              boxShadow: [
                BoxShadow(
                  color: impactColor.withOpacity(0.15),
                  blurRadius: 25,
                ),
              ],
            ),
            child: Column(
              children: [
                Icon(
                  getImpactIcon(impact),
                  color: impactColor,
                  size: 58,
                ),
                const SizedBox(height: 14),
                Text(
                  type,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 18,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: impactColor.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Text(
                    impact,
                    style: TextStyle(
                      color: impactColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          Row(
            children: [
              Expanded(
                child: buildActionButton(
                  label: 'Edit',
                  icon: Icons.edit_rounded,
                  color: Colors.lightBlueAccent,
                  onPressed: () {
                    openEditScreen(context);
                  },
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: buildActionButton(
                  label: 'Open location',
                  icon: Icons.location_on_rounded,
                  color: Colors.greenAccent,
                  onPressed: () {
                    openLocation(context);
                  },
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          buildActionButton(
            label: 'Delete report',
            icon: Icons.delete_rounded,
            color: Colors.redAccent,
            onPressed: () {
              confirmDelete(context);
            },
          ),

          const SizedBox(height: 24),

          buildDetailCard(
            title: 'Description',
            value: description,
            icon: Icons.description_rounded,
            color: Colors.white70,
          ),
          buildDetailCard(
            title: 'Toxicity level',
            value: toxicity,
            icon: Icons.dangerous_rounded,
            color: Colors.redAccent,
          ),
          buildDetailCard(
            title: 'Recycling recommendation',
            value: recycling,
            icon: Icons.recycling_rounded,
            color: Colors.greenAccent,
          ),
          buildDetailCard(
            title: 'Suggested eco action',
            value: ecoAction,
            icon: Icons.task_alt_rounded,
            color: Colors.lightBlueAccent,
          ),
          buildDetailCard(
            title: 'Location',
            value: 'Latitude: $latitude\nLongitude: $longitude',
            icon: Icons.location_on_rounded,
            color: Colors.orangeAccent,
          ),
          buildDetailCard(
            title: 'Date',
            value: date,
            icon: Icons.calendar_month_rounded,
            color: Colors.purpleAccent,
          ),
        ],
      ),
    );
  }
}