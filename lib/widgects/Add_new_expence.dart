import 'package:expence_master/models/expence.dart';
import 'package:flutter/material.dart';

class AddNewExpence extends StatefulWidget {
  final void Function(ExpenceModel expence) onAddExpence;
  const AddNewExpence({super.key, required this.onAddExpence});

  @override
  State<AddNewExpence> createState() => _AddNewExpenceState();
}

class _AddNewExpenceState extends State<AddNewExpence> {
  final _titleController = TextEditingController();
  final _amountController = TextEditingController();

  late Category _selectedCategory = Category.leasure;

  //date variables
  final DateTime initialdate = DateTime.now();
  final DateTime firstDate = DateTime(
      DateTime.now().year - 1, DateTime.now().month, DateTime.now().day);
  final DateTime lastDate = DateTime(
      DateTime.now().year + 1, DateTime.now().month, DateTime.now().day);

  DateTime _selectedDate = DateTime.now();

  //date picker
  Future<void> _openDataModel() async {
    try {
      //show the date model then store user selected date
      final pickedDate = await showDatePicker(
          context: context, firstDate: firstDate, lastDate: lastDate);

      setState(() {
        _selectedDate = pickedDate!;
      });
    } catch (err) {
      print(err.toString());
    }
  }

  //handle form submit
  void _handleFormSubmit() {
    //form validation
    //convert the amount in to a double
    final userAmount = double.parse(_amountController.text.trim());
    if (_titleController.text.trim().isEmpty || userAmount <= 0) {
      showDialog(
        context: context,
        builder: (context) {
          return (AlertDialog(
            title: const Text("Enter valid Data"),
            content: const Text(
                "Please enter valid data for the title and the amont here the title can't be empty and the amount can't be less than zero."),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text("Close"),
              ),
            ],
          ));
        },
      );
    } else {
      //ctreate the new expence
      ExpenceModel newExpence = ExpenceModel(
          amount: userAmount,
          date: _selectedDate,
          title: _titleController.text.trim(),
          category: _selectedCategory);
      //save the data
      widget.onAddExpence(newExpence);
      Navigator.pop(context);
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          // Title text field
          TextField(
            controller: _titleController,
            decoration: const InputDecoration(
              hintText: "Add new expense title",
              labelText: "Title",
            ),
            keyboardType: TextInputType.text,
            maxLength: 50,
          ),
          const SizedBox(height: 10), // Added SizedBox for spacing

          Row(
            children: [
              // Amount text field
              Expanded(
                child: TextField(
                  controller: _amountController,
                  decoration: const InputDecoration(
                    helperText: "Enter the amount",
                    labelText: "Amount",
                  ),
                  keyboardType: TextInputType.number,
                ),
              ),

              // Date picker
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(formattedDate.format(_selectedDate)),
                    IconButton(
                      onPressed: _openDataModel,
                      icon: const Icon(Icons.date_range_outlined),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 10), // Added SizedBox for spacing

          // Dropdown for selecting category
          Row(
            children: [
              DropdownButton(
                value: _selectedCategory,
                items: Category.values
                    .map((category) => DropdownMenuItem(
                          value: category,
                          child: Text(category.name), // Changed to value.name
                        ))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedCategory = value!;
                  });
                },
              ),
              Expanded(
                  child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  //close the model button
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    style: const ButtonStyle(
                      backgroundColor:
                          MaterialStatePropertyAll(Colors.redAccent),
                    ),
                    child: const Text("Close"),
                  ),

                  const SizedBox(
                    width: 10,
                  ),
                  ElevatedButton(
                    onPressed: _handleFormSubmit,
                    style: const ButtonStyle(
                      backgroundColor: MaterialStatePropertyAll(Colors.green),
                    ),
                    child: const Text("Save"),
                  ),
                  //save the data and close the model button
                ],
              ))
            ],
          ),
        ],
      ),
    );
  }
}
