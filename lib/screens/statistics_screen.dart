import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:fl_chart/fl_chart.dart';
import '../providers/events_provider.dart';
import '../models/event.dart';

class StatisticsScreen extends ConsumerWidget {
  const StatisticsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text(AppLocalizations.of(context)!.statistics),
          bottom: TabBar(
            tabs: [
              Tab(
                icon: const Icon(Icons.restaurant),
                text: AppLocalizations.of(context)!.meals,
              ),
              Tab(
                icon: const Icon(Icons.fitness_center),
                text: AppLocalizations.of(context)!.workouts,
              ),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _buildMealStats(context, ref),
            _buildWorkoutStats(context, ref),
          ],
        ),
      ),
    );
  }

  Widget _buildMealStats(BuildContext context, WidgetRef ref) {
    final events = ref.watch(eventsProvider);
    final mealEvents = events.whereType<MealEvent>().toList();

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildMealSummaryCard(context, mealEvents),
          const SizedBox(height: 16),
          _buildMealActivityChart(context, mealEvents),
        ],
      ),
    );
  }

  Widget _buildWorkoutStats(BuildContext context, WidgetRef ref) {
    final events = ref.watch(eventsProvider);
    final workoutEvents = events.whereType<WorkoutEvent>().toList();

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildWorkoutSummaryCard(context, workoutEvents),
          const SizedBox(height: 16),
          _buildWorkoutActivityChart(context, workoutEvents),
        ],
      ),
    );
  }

  Widget _buildMealSummaryCard(BuildContext context, List<MealEvent> events) {
    // Compter les repas par type
    final breakfastCount = events.where((e) => e.type == MealType.breakfast).length;
    final lunchCount = events.where((e) => e.type == MealType.lunch).length;
    final dinnerCount = events.where((e) => e.type == MealType.dinner).length;
    final snackCount = events.where((e) => e.type == MealType.snack).length;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              AppLocalizations.of(context)!.mealSummary,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            _buildStatRow(
              context,
              Icons.breakfast_dining,
              AppLocalizations.of(context)!.breakfast,
              breakfastCount.toString(),
              Colors.orange[300]!,
            ),
            const SizedBox(height: 8),
            _buildStatRow(
              context,
              Icons.lunch_dining,
              AppLocalizations.of(context)!.lunch,
              lunchCount.toString(),
              Colors.orange[500]!,
            ),
            const SizedBox(height: 8),
            _buildStatRow(
              context,
              Icons.dinner_dining,
              AppLocalizations.of(context)!.dinner,
              dinnerCount.toString(),
              Colors.orange[700]!,
            ),
            const SizedBox(height: 8),
            _buildStatRow(
              context,
              Icons.fastfood,
              AppLocalizations.of(context)!.snack,
              snackCount.toString(),
              Colors.orange[900]!,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWorkoutSummaryCard(BuildContext context, List<WorkoutEvent> events) {
    // Compter les workouts par type
    final runningCount = events.where((e) => e.type == WorkoutType.running).length;
    final cyclingCount = events.where((e) => e.type == WorkoutType.cycling).length;
    final fitnessCount = events.where((e) => e.type == WorkoutType.fitness).length;
    final strengthCount = events.where((e) => e.type == WorkoutType.strength).length;

    // Calculer les stats globales
    final totalDuration = events.fold<Duration>(
      Duration.zero,
      (total, event) => total + event.duration,
    );
    final totalCalories = events
        .map((e) => e.caloriesBurned ?? 0)
        .fold<int>(0, (total, calories) => total + calories);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              AppLocalizations.of(context)!.workoutSummary,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            _buildStatRow(
              context,
              Icons.directions_run,
              AppLocalizations.of(context)!.running,
              runningCount.toString(),
              Colors.blue[300]!,
            ),
            const SizedBox(height: 8),
            _buildStatRow(
              context,
              Icons.directions_bike,
              AppLocalizations.of(context)!.cycling,
              cyclingCount.toString(),
              Colors.blue[500]!,
            ),
            const SizedBox(height: 8),
            _buildStatRow(
              context,
              Icons.fitness_center,
              AppLocalizations.of(context)!.fitness,
              fitnessCount.toString(),
              Colors.blue[700]!,
            ),
            const SizedBox(height: 8),
            _buildStatRow(
              context,
              Icons.sports_gymnastics,
              AppLocalizations.of(context)!.strength,
              strengthCount.toString(),
              Colors.blue[900]!,
            ),
            const Divider(height: 24),
            _buildStatRow(
              context,
              Icons.timer,
              AppLocalizations.of(context)!.totalDuration,
              '${totalDuration.inHours}h ${totalDuration.inMinutes.remainder(60)}m',
              Colors.green,
            ),
            const SizedBox(height: 8),
            _buildStatRow(
              context,
              Icons.local_fire_department,
              AppLocalizations.of(context)!.totalCalories,
              '$totalCalories kcal',
              Colors.red,
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

  Widget _buildMealActivityChart(BuildContext context, List<MealEvent> events) {
    return _buildActivityChart(
      context,
      events,
      AppLocalizations.of(context)!.mealActivity,
      Colors.orange,
    );
  }

  Widget _buildWorkoutActivityChart(BuildContext context, List<WorkoutEvent> events) {
    return _buildActivityChart(
      context,
      events,
      AppLocalizations.of(context)!.workoutActivity,
      Colors.blue,
    );
  }

  Widget _buildActivityChart(BuildContext context, List<Event> events, String title, Color color) {
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
              title,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 200,
              child: LineChart(
                LineChartData(
                  gridData: const FlGridData(show: false),
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
                      color: color,
                      barWidth: 3,
                      dotData: const FlDotData(show: true),
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