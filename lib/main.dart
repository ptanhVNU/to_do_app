import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:task_manager/models/popup_item.dart';
import 'package:task_manager/models/popup_items.dart';
import 'package:task_manager/models/task.dart';
import 'package:task_manager/widgets/add_screen.dart';
import 'package:task_manager/widgets/edit_screen.dart';
import 'package:task_manager/widgets/search_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tasks Manager',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      debugShowCheckedModeBanner: false,
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final List<Task> _tasks = [
    Task(
      id: 'p1',
      title: 'Read some articles in Medium',
      description:
          'I Finished today the UX design course 1 of 7 for Google UX Design Professional Certificate, and the experience was amazing. Everything about this User Experience (UX) Design course split into 4 weeks was perfect and very well structured, for me this course provides a good start in UX design, learning from key frameworks in the field to how to craft a UX portfolio.',
    ),
    Task(
      id: 'p2',
      title: 'Lorem ipsum dolor',
      description: 'Viverra turpis sed eu curabitur sed eget malesuada sed.',
    ),
  ];

  void _addNewTask(String title, String description) {
    final newTask = Task(
      id: DateTime.now().toString(),
      title: title,
      description: description,
    );
    setState(() {
      _tasks.add(newTask);
    });
  }

  void _updateTask(String id, Task newTask) {
    final prodIndex = _tasks.indexWhere((task) => task.id == id);

    setState(() {
      _tasks[prodIndex] = newTask;
    });
  }

  void deleteTask(String id) {
    setState(() {
      _tasks.removeWhere((element) => element.id == id);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.15,
        title: const Text(
          'Todos',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () => showSearch(
              context: context,
              delegate: Search(_tasks, _updateTask),
            ),
            icon: const Icon(Icons.search, color: Colors.black),
          ),
          PopupMenuButton<PopUpItem>(
            onSelected: (item) => onSelected(context, item),
            icon: const Icon(Icons.more_vert_rounded, color: Colors.black),
            itemBuilder: (context) => [
              ...PopUpItems.itemFirst.map(buildItem).toList(),
            ],
          ),
        ],
      ),
      body: _buildGridView(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddScreen(
                addTx: _addNewTask,
              ),
            ),
          );
        },
        backgroundColor: Colors.white,
        child: const Icon(
          Icons.add,
          color: Colors.black,
        ),
      ),
    );
  }

  PopupMenuItem<PopUpItem> buildItem(PopUpItem item) => PopupMenuItem(
        value: item,
        child: Row(
          children: [
            Text(item.text),
            const SizedBox(width: 12),
            Icon(item.icon, color: Colors.black, size: 20),
          ],
        ),
      );

  void onSelected(BuildContext context, PopUpItem item) {
    switch (item) {
      case PopUpItems.itemSortBy:
        showMenu(
          context: context,
          position: const RelativeRect.fromLTRB(100.0, 40.0, 0.0, 100.0),
          items: [
            ...PopUpItems.itemSecond.map(buildItem).toList(),
          ],
        );

        break;
      case PopUpItems.itemDelete:
        showDialog(
          context: context,
          builder: (_) => AlertDialog(
            title: const Text('Delete everything?'),
            content: const Text('Are you sure you want to remove everything'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text(
                  'No',
                  style: TextStyle(
                    color: Colors.black,
                  ),
                ),
              ),
              TextButton(
                onPressed: () {
                  setState(() {
                    _tasks.clear();
                  });
                  Navigator.pop(context);
                },
                child: const Text(
                  'Yes',
                  style: TextStyle(
                    color: Colors.red,
                  ),
                ),
              ),
            ],
          ),
        );
        break;
    }
  }

  Padding _buildGridView() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(15, 30, 15, 30),
      child: GridView.builder(
        shrinkWrap: true,
        itemCount: _tasks.length,
        gridDelegate: SliverWovenGridDelegate.count(
          crossAxisCount: 2,
          mainAxisSpacing: 6,
          crossAxisSpacing: 6,
          pattern: [
            const WovenGridTile(0.95),
            const WovenGridTile(
              7 / 8,
              crossAxisRatio: 0.9,
              alignment: AlignmentDirectional.centerEnd,
            ),
          ],
        ),
        itemBuilder: (BuildContext context, int index) {
          return ClipRRect(
            borderRadius: BorderRadius.circular(30),
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => EditScreen(
                      task: _tasks[index],
                      updateTask: _updateTask,
                    ),
                  ),
                );
              },
              child: Card(
                clipBehavior: Clip.antiAlias,
                elevation: 3,
                child: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _tasks[index].title,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Roboto',
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        _tasks[index].description,
                        maxLines: 5,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
