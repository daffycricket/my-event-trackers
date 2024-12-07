import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../providers/events_provider.dart';
import '../models/event.dart';
import 'package:fl_chart/fl_chart.dart';

class StatisticsScreen extends ConsumerWidget {
  const StatisticsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final events = ref.watch(eventsProvider);
    
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.statistics),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildEventTypesCard(context, events),
            const SizedBox(height: 16),
            _buildWeeklyActivityChart(context, events),
          ],
        ),
      ),
    );
  }

  Widget _buildEventTypesCard(BuildContext context, List<Event> events) {
    final mealCount = events.where((e) => e is MealEvent).length;
    final workoutCount = events.where((e) => e is WorkoutEvent).length;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              AppLocalizations.of(context)!.eventSummary,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            _buildStatRow(
              context,
              Icons.restaurant,
              AppLocalizations.of(context)!.meals,
              mealCount.toString(),
              Colors.orange,
            ),
            const SizedBox(height: 8),
            _buildStatRow(
              context,
              Icons.fitness_center,
              AppLocalizations.of(context)!.workouts,
              workoutCount.toString(),
              Colors.blue,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatRow(BuildContext context, IconData icon, String label, String value, Color color) {
    return Row(
      children: [
        Icon(icon, color: color),
        const SizedBox(width: 8),
        Text(label),
        const Spacer(),
        Text(
          value,
          style: Theme.of(context).textTheme.titleMedium,
        ),
      ],
    );
  }

  Widget _buildWeeklyActivityChart(BuildContext context, List<Event> events) {
    // Obtenir les 7 derniers jours
    final now = DateTime.now();
    final dates = List.generate(7, (index) => 
      DateTime(now.year, now.month, now.day - index));

    // Compter les événements par jour
    final dailyCounts = dates.map((date) => events.where((event) =>
      event.date.year == date.year &&
      event.date.month == date.month &&
      event.date.day == date.day
    ).length.toDouble()).toList();

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              AppLocalizations.of(context)!.weeklyActivity,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 200,
              child: LineChart(
                LineChartData(
                  gridData: FlGridData(show: false),
                  titlesData: FlTitlesData(
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, meta) {
                          final date = dates[value.toInt()];
                          return Text('${date.day}/${date.month}');
                        },
                      ),
                    ),
                  ),
                  borderData: FlBorderData(show: false),
                  lineBarsData: [
                    LineChartBarData(
                      spots: List.generate(7, (index) => 
                        FlSpot(index.toDouble(), dailyCounts[index])),
                      isCurved: true,
                      color: Theme.of(context).primaryColor,
                      barWidth: 3,
                      dotData: FlDotData(show: true),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
} 