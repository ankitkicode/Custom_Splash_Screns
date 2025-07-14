import 'dart:ui';
import 'dart:async';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class TaskItem {
  final String title;
  bool completed;
  TaskItem({required this.title, this.completed = false});
}

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  List<TaskItem> tasks = [
    TaskItem(title: "Update UI theme"),
    TaskItem(title: "Fix chart bug"),
    TaskItem(title: "Add productivity metric", completed: true),
    TaskItem(title: "Refactor widgets"),
  ];

  int get total => tasks.length;
  int get completed => tasks.where((t) => t.completed).length;
  int get pending => total - completed;
  double get productivityScore => (completed / total) * 100;

  void _toggleTask(TaskItem task) {
    setState(() {
      task.completed = !task.completed;
    });
  }

  void _showTaskPopup(TaskItem task) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: Colors.black87,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text("Task Detail", style: TextStyle(color: Colors.white)),
        content: Text(task.title, style: const TextStyle(color: Colors.white70)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Close", style: TextStyle(color: Colors.cyanAccent)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Stack(
        children: [
          _buildBackground(),
          SafeArea(
            child: CustomScrollView(
              slivers: [
                _buildHeader(),
                _buildStatsGrid(),
                _buildProductivityTile(),
                _buildChart(screenWidth),
                _buildTaskList(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBackground() {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF0F2027), Color(0xFF2C5364)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return SliverAppBar(
      pinned: true,
      backgroundColor: Colors.transparent,
      elevation: 0,
      flexibleSpace: Padding(
        padding: const EdgeInsets.all(14.0),
        child: Align(
          alignment: Alignment.bottomLeft,
          child: Text(
            "Dashboard Overview",
            style: const TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStatsGrid() {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: LayoutBuilder(
          builder: (context, constraints) {
            int crossAxisCount = 2;
            if (constraints.maxWidth > 1000) {
              crossAxisCount = 4;
            } else if (constraints.maxWidth > 600) {
              crossAxisCount = 2;
            }

            return GridView.count(
              crossAxisCount: crossAxisCount,
              shrinkWrap: true,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              physics: const NeverScrollableScrollPhysics(),
              childAspectRatio: 1.2,
              children: [
                _buildGlassCard("Total", total.toString(), Colors.lightBlueAccent),
                _buildGlassCard("Done", completed.toString(), Colors.greenAccent),
                _buildGlassCard("Pending", pending.toString(), Colors.orangeAccent),
                _buildGlassCard("Focus Mode", "Active", Colors.purpleAccent),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildProductivityTile() {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        child: _buildGlassContainer(
          height: 80,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text("Productivity Score", style: TextStyle(fontSize: 16, color: Colors.white70)),
              Text(
                "${productivityScore.toStringAsFixed(1)}%",
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.cyanAccent),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildChart(double screenWidth) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        child: AspectRatio(
          aspectRatio: screenWidth < 600 ? 1.4 : 2.4,
          child: _buildGlassContainer(
            child: LineChart(
              LineChartData(
                lineBarsData: [
                  LineChartBarData(
                    isCurved: true,
                    spots: const [
                      FlSpot(0, 1),
                      FlSpot(1, 1.5),
                      FlSpot(2, 1.7),
                      FlSpot(3, 2.2),
                      FlSpot(4, 2.6),
                      FlSpot(5, 3),
                    ],
                    color: Colors.cyanAccent,
                    barWidth: 4,
                    belowBarData: BarAreaData(
                      show: true,
                      color: Colors.cyanAccent.withOpacity(0.15),
                    ),
                    dotData: FlDotData(show: false),
                  ),
                ],
                gridData: FlGridData(show: false),
                titlesData: FlTitlesData(show: false),
                borderData: FlBorderData(show: false),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTaskList() {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        child: _buildGlassContainer(
          child: ListView.builder(
            itemCount: tasks.length,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) {
              final task = tasks[index];
              return ListTile(
                leading: Radio<bool>(
                  value: true,
                  groupValue: task.completed,
                  onChanged: (_) => _toggleTask(task),
                  activeColor: Colors.greenAccent,
                ),
                title: Text(
                  task.title,
                  style: TextStyle(
                    fontSize: 16,
                    color: task.completed ? Colors.white54 : Colors.white,
                    decoration: task.completed ? TextDecoration.lineThrough : null,
                  ),
                ),
                onTap: () => _showTaskPopup(task),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildGlassCard(String label, String value, Color color) {
    return _buildGlassContainer(
      height: 80,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(label, style: const TextStyle(fontSize: 13, color: Colors.white70)),
          const SizedBox(height: 6),
          Text(value,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: color)),
        ],
      ),
    );
  }

  Widget _buildGlassContainer({required Widget child, double? height}) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 14, sigmaY: 14),
        child: Container(
          height: height,
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.05),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.white.withOpacity(0.1)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: child,
        ),
      ),
    );
  }
}
