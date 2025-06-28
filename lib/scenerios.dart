import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

const String baseURL = 'http://pollutionviz-3hta.onrender.com';

class ScenariosPage extends StatefulWidget {
  const ScenariosPage({super.key});

  @override
  State<ScenariosPage> createState() => _ScenariosPageState();
}

class _ScenariosPageState extends State<ScenariosPage> {
  late Future<List<dynamic>> _scenariosData;
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    _scenariosData = _fetchScenariosData();
  }

  Future<List<dynamic>> _fetchScenariosData() async {
    try {
      final response = await http.get(
        Uri.parse('$baseURL/get_scenario_presets'),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data is List) {
          return data;
        } else {
          throw Exception('Expected list but got ${data.runtimeType}');
        }
      } else {
        throw Exception('Failed to load scenarios: ${response.statusCode}');
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Error loading scenarios: ${e.toString()}';
      });
      return [];
    }
  }

  Future<void> _refreshData() async {
    setState(() {
      _scenariosData = _fetchScenariosData();
      _errorMessage = '';
    });
    // Optionally wait for the data to finish loading
    await _scenariosData;
  }

  Color _getAqiColor(String aqiLabel) {
    final label = aqiLabel.toLowerCase();
    if (label.contains('good')) return Colors.green;
    if (label.contains('moderate')) return Colors.yellow;
    if (label.contains('unhealthy for sensitive')) return Colors.orange;
    if (label.contains('unhealthy')) return Colors.red;
    if (label.contains('very unhealthy')) return Colors.purple;
    if (label.contains('hazardous')) return Colors.deepPurple.shade900;
    return Colors.grey;
  }

  Color _getAqiTextColor(String aqiLabel) {
    return Colors.white;
  }

  Widget _buildPollutantRiskChips(List<dynamic> pollutants) {
    if (pollutants.isEmpty) return const SizedBox();

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.red.shade50,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.warning, size: 18, color: Colors.red.shade800),
              const SizedBox(width: 8),
              Text(
                'Pollutant Risks',
                style: GoogleFonts.montserrat(
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                  color: Colors.red.shade800,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: pollutants.map<Widget>((p) {
              final increase = p['increase_percent']?.toDouble() ?? 0.0;
              final pollutantName = p['pollutant']?.toString() ?? 'Unknown';
              return Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.red.shade100),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      pollutantName,
                      style: GoogleFonts.montserrat(
                        fontWeight: FontWeight.w500,
                        fontSize: 12,
                      ),
                    ),
                    Text(
                      '+${increase.toStringAsFixed(1)}%',
                      style: GoogleFonts.montserrat(
                        color: Colors.red,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoChips(
    String title,
    List<dynamic> items,
    Color color,
    IconData icon,
  ) {
    if (items.isEmpty) return const SizedBox();

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 18, color: color),
              const SizedBox(width: 8),
              Text(
                title,
                style: GoogleFonts.montserrat(
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                  color: color,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: items.map((item) {
              return Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: color.withOpacity(0.2)),
                ),
                child: Text(
                  item.toString(),
                  style: GoogleFonts.montserrat(fontSize: 12),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildScenarioCard(
    Map<String, dynamic> scenario,
    BuildContext context,
  ) {
    final pollutants = scenario['top_pollutant_risks'] ?? [];
    final healthRisks = scenario['health_risks'] ?? [];
    final sources = scenario['main_sources'] ?? [];
    final aqiLabel = scenario['aqi_label']?.toString() ?? 'Unknown';
    final location = "Nagpur";
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Card(
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        scenario['name']?.toString() ?? 'Unnamed Scenario',
                        style: GoogleFonts.montserrat(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          color: isDark ? Colors.white : Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Icon(
                            Icons.location_on,
                            size: 16,
                            color: isDark ? Colors.white70 : Colors.black54,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            location,
                            style: GoogleFonts.montserrat(
                              fontSize: 13,
                              color: isDark ? Colors.white70 : Colors.black54,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: _getAqiColor(aqiLabel),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Text(
                    aqiLabel,
                    style: GoogleFonts.montserrat(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: _getAqiTextColor(aqiLabel),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              scenario['description'] ?? 'No description available',
              style: GoogleFonts.montserrat(
                fontSize: 14,
                color: isDark ? Colors.white70 : Colors.black87,
                height: 1.4,
              ),
            ),
            const SizedBox(height: 16),
            _buildPollutantRiskChips(pollutants),
            _buildInfoChips(
              'Main Sources',
              sources,
              Colors.orange,
              Icons.local_shipping,
            ),
            _buildInfoChips(
              'Health Risks',
              healthRisks,
              Colors.red,
              Icons.medical_services,
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Pollution Scenarios',
          style: GoogleFonts.montserrat(
            fontWeight: FontWeight.bold,
            color: isDark ? Colors.white : Colors.black87,
          ),
        ),
        elevation: 0,
        centerTitle: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _refreshData,
            tooltip: 'Refresh scenarios',
          ),
        ],
      ),
      body: FutureBuilder<List<dynamic>>(
        future: _scenariosData,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(
                      Theme.of(context).primaryColor,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Analyzing pollution scenarios...',
                    style: GoogleFonts.montserrat(
                      color: isDark ? Colors.white70 : Colors.black54,
                    ),
                  ),
                ],
              ),
            );
          }

          if (_errorMessage.isNotEmpty) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.error_outline, color: Colors.red, size: 48),
                    const SizedBox(height: 16),
                    Text(
                      _errorMessage,
                      style: GoogleFonts.montserrat(color: Colors.red),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton.icon(
                      icon: const Icon(Icons.refresh),
                      label: Text('Try Again', style: GoogleFonts.montserrat()),
                      onPressed: _refreshData,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 12,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }

          if (snapshot.data == null || snapshot.data!.isEmpty) {
            return Center(
              child: Text(
                'No scenarios available',
                style: GoogleFonts.montserrat(
                  color: isDark ? Colors.white70 : Colors.black54,
                ),
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: _refreshData,
            color: Theme.of(context).primaryColor,
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                return _buildScenarioCard(snapshot.data![index], context);
              },
            ),
          );
        },
      ),
    );
  }
}
