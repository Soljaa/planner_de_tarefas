import 'package:flutter/material.dart';
import '../databases/taskDatabase.dart'as task_bd;
import 'taskBoards.dart';

class TasksView extends StatefulWidget {
  List<Map<String, dynamic>> taskList;
  final String boardName;
  final int boardId;
  final Map<String, dynamic> user;
  final int cor;

  TasksView({Key? key, required this.taskList, required this.boardName, required this.user, required this.boardId, required this.cor}) : super(key: key);

  @override
  State<TasksView> createState() => TasksViewState();
}

class TasksViewState extends State<TasksView> {

  static const Color roxo = Color(0xFF6354B2);
  final GlobalKey<TaskTableState> _taskTableKey = GlobalKey<TaskTableState>();


  Future<void> updateTaskList() async{
    List<Map<String, dynamic>> taskList = await task_bd.consultarDadosTask(widget.boardId);
    setState(() {
      widget.taskList = taskList;
      _taskTableKey.currentState?.updateTaskList(List.generate(taskList.length, (index) => false));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.boardName),
        backgroundColor: Color(widget.cor), //usar cor do board
        leading: IconButton(
    icon: const Icon(Icons.arrow_back, color: Colors.white), //arrow color based on the board color
    onPressed: () => Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) =>  TaskBoards(user: widget.user))),
      ),),
      body: SingleChildScrollView(child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const Text(
              "Crie, complete, altere ou remova tarefas!",
              style: TextStyle(color: roxo, fontSize: 22, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  builder: (BuildContext context) {
                    return Container(
                      padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          TaskForm(userId: widget.user["id"], boardId: widget.boardId, onUpdate: updateTaskList)
                        ],
                      ),
                    );
                  },
                );
              },
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(roxo),
                textStyle: MaterialStateProperty.all<TextStyle>(
                  const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                  const EdgeInsets.symmetric(vertical: 12, horizontal: 30),
                ),
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                ),
              ),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text("Criar Tarefa"),
                  SizedBox(width: 8),
                  Icon(Icons.add),
                ],
              ),
            ),
            const SizedBox(height: 20),
            if (widget.taskList.isEmpty)
              const Text("Sem tarefas")
            else
              TaskTable(key: _taskTableKey,taskDataList: widget.taskList, boardId: widget.boardId, onUpdate: updateTaskList)
          ],
        ),
      ),)
    );
  }
}

class TaskForm extends StatefulWidget {
  final int boardId;
  final int userId;
  final void Function() onUpdate;

  const TaskForm({Key? key, required this.userId, required this.boardId, required this.onUpdate}) : super(key: key);

  @override
  TaskFormState createState() => TaskFormState();
}

class TaskFormState extends State<TaskForm> {
  TextEditingController titleController = TextEditingController();
  TextEditingController noteController = TextEditingController();

  DateTime selectedDate = DateTime.now();
  TimeOfDay selectedStartTime = TimeOfDay.now();
  TimeOfDay selectedEndTime = TimeOfDay.now();

  bool isCompleted = false;

  Future<void> selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
    );

    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  Future<void> selectStartTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: selectedStartTime,
    );

    if (picked != null && picked != selectedStartTime) {
      setState(() {
        selectedStartTime = picked;
      });
    }
  }

  Future<void> selectEndTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: selectedEndTime,
    );

    if (picked != null && picked != selectedEndTime) {
      setState(() {
        selectedEndTime = picked;
      });
    }
  }

  Future<void> saveTask(BuildContext context) async {
    await task_bd.inserirDadosTask(widget.userId, widget.boardId, titleController.text, noteController.text, selectedDate.toString().split(" ")[0], selectedStartTime.format(context), selectedEndTime.format(context), isCompleted ? 1 : 0);
    widget.onUpdate();
  }

  @override
  Widget build(BuildContext context) {

    const Color roxo = Color(0xFF6354B2);

    return Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: titleController,
                decoration: const InputDecoration(labelText: 'Título'),
              ),
              TextFormField(
                controller: noteController,
                decoration: const InputDecoration(labelText: 'Notas'),
              ),
              Row(
                children: [
                  Expanded(
                    child: InkWell(
                      onTap: () => selectDate(context),
                      child: InputDecorator(
                        decoration: const InputDecoration(
                          labelText: 'Data',
                        ),
                        child: Text(
                          "${selectedDate.toLocal()}".split(' ')[0],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Expanded(
                    child: InkWell(
                      onTap: () => selectStartTime(context),
                      child: InputDecorator(
                        decoration: const InputDecoration(
                          labelText: 'Início',
                        ),
                        child: Text(
                          selectedStartTime.format(context),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: InkWell(
                      onTap: () => selectEndTime(context),
                      child: InputDecorator(
                        decoration: const InputDecoration(
                          labelText: 'Fim',
                        ),
                        child: Text(
                          selectedEndTime.format(context),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Checkbox(
                    value: isCompleted,
                    activeColor: Colors.green,
                    onChanged: (value) {
                      setState(() {
                        isCompleted = value!;
                      });
                    },
                  ),
                  const Text('Concluída'),
                ],
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    saveTask(context);
                    Navigator.pop(context);
                  });
                },
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(roxo),
                  textStyle: MaterialStateProperty.all<TextStyle>(
                    const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                    const EdgeInsets.symmetric(vertical: 12, horizontal: 30),
                  ),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                  ),
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text("Criar Tarefa"),
                    SizedBox(width: 8),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
  }
}

class TaskTable extends StatefulWidget {
  List<Map<String, dynamic>> taskDataList;
  final int boardId;
  final void Function() onUpdate;

  TaskTable({super.key, required this.taskDataList, required this.boardId, required this.onUpdate});

  @override
  TaskTableState createState() => TaskTableState();
}

class TaskTableState extends State<TaskTable> {
  List<bool> _isOpen = [];
  List<bool> isCheckedList = [];

  @override
  void initState() {
    super.initState();
    _isOpen = List.generate(widget.taskDataList.length, (index) => false);
    for(var task in widget.taskDataList){
      isCheckedList.add(task["isCompleted"] == 1);
    }
  }

  void updateTaskList(List<bool> newList){
    setState(() {
      _isOpen = newList;
    });
  }


  @override
  Widget build(BuildContext context) {
    return ExpansionPanelList(
      elevation: 1,
      expandedHeaderPadding: const EdgeInsets.all(0),
      children: [
        for (var index = 0; index < widget.taskDataList.length; index++)
          ExpansionPanel(
            headerBuilder: (BuildContext context, bool isExpanded) {
              var taskData = widget.taskDataList[index];
              return Row(
                children: [
                  Checkbox(
                    value: isCheckedList[index],
                    activeColor: Colors.green,
                    onChanged: (value) async {
                      await task_bd.changeTaskState(value!, taskData["id"]);
                      setState(() {
                        isCheckedList[index] = value;
                      });
                    },
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(taskData['title'] ?? ''),
                        Text(taskData['date'] ?? ''),
                      ],
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      setState(() async {
                        await task_bd.deleteTask(taskData["id"]);
                        widget.onUpdate();
                      });
                    },
                    child: const Icon(Icons.delete, color: Colors.red,),
                  )
                ],
              );
            },
            body: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Início:  ${widget.taskDataList[index]['startTime'] ?? ''}'),
                      Text('Fim:     ${widget.taskDataList[index]['endTime'] ?? ''}'),
                    ],
                  ),
                  const SizedBox(width: 16,),
                  Flexible(child: Text('Notas: ${widget.taskDataList[index]['note'] ?? ''}')),
                ],
              ),
            ),
            isExpanded: _isOpen[index],
            canTapOnHeader: true,
          ),
      ],
      expansionCallback: (index, isOpen) =>
          setState(() {
            _isOpen[index] = isOpen;
          }),
    );

  }
}



