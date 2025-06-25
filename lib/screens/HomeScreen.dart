import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:time_tracker/screens/AddTimeEntryScreen.dart';
import 'package:time_tracker/widget/app_drawer.dart';
import '../providers/time_entry_provider.dart';
import '../models/time_entry.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final entries = context.watch<TimeEntryProvider>().entries;
    final grouped = <String, List<TimeEntry>>{};
    for (var e in entries) {
      grouped.putIfAbsent(e.projectId, () => []).add(e);
    }

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Time Tracking'),
          backgroundColor: const Color(0xFF419688),
          bottom: const TabBar(
            indicatorColor: Colors.amber,
            labelColor: Colors.white,
            unselectedLabelColor: Colors.white38,
            tabs: [
              Tab(text: 'All Entries'),
              Tab(text: 'Grouped by Projects'),
            ],
          ),
        ),
        drawer: const AppDrawer(),
        body: TabBarView(
          children: [
            // — All Entries Tab —
            entries.isEmpty
                ? Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: const [
                        Icon(
                          Icons.hourglass_empty,
                          size: 64,
                          color: Colors.grey,
                        ),
                        SizedBox(height: 8),
                        Text('No time entries yet!'),
                        Text('Tap the + button to add your first entry.'),
                      ],
                    ),
                  )
                : ListView.builder(
                    itemCount: entries.length,
                    itemBuilder: (_, i) {
                      final e = entries[i];
                      return ListTile(
                        title: Text(
                          '${e.totalMinutes ~/ 60}h ${e.totalMinutes % 60}m',
                        ),
                        subtitle: Text(DateFormat.yMMMd().format(e.date)),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete),
                          onPressed: () =>
                              context.read<TimeEntryProvider>().remove(e.id),
                        ),
                      );
                    },
                  ),

            // — Grouped by Projects Tab —
            grouped.isEmpty
                ? const SizedBox.shrink()
                : ListView(
                    children: grouped.entries.map((grp) {
                      final total = grp.value.fold<int>(
                        0,
                        (sum, e) => sum + e.totalMinutes,
                      );
                      return ExpansionTile(
                        title: Text('Project: ${grp.key}'),
                        subtitle: Text('${total ~/ 60}h ${total % 60}m total'),
                        children: grp.value.map((e) {
                          return ListTile(
                            title: Text(
                              '${e.totalMinutes ~/ 60}h ${e.totalMinutes % 60}m',
                            ),
                            subtitle: Text(DateFormat.yMMMd().format(e.date)),
                          );
                        }).toList(),
                      );
                    }).toList(),
                  ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: const Color(0xFF419688),
          child: const Icon(Icons.add),
          onPressed: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const AddTimeEntryScreen()),
          ),
        ),
      ),
    );
  }
}
