import 'package:cbl/cbl.dart';
import 'package:flutter/material.dart';
import 'package:gestio/document/EngagementRepository.dart';
import 'package:gestio/document/machine/MachineRepository.dart';
import 'package:gestio/document/customer/Customer.dart';
import 'package:gestio/document/customer/CustomerRepository.dart';
import 'package:gestio/db/DatabaseHelper.dart';
import 'package:gestio/document/machine/Machine.dart';
import 'package:intl/intl.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentSortColumn = 0;
  bool _isSortAsc = true;
  late List<Machine> _machines;

  late CustomerRepository _customerRepository;
  late MachineRepository _machineRepository;

  final TextEditingController _firstnameController = TextEditingController();
  final TextEditingController _lastnameController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();

  final TextEditingController _modelController = TextEditingController();
  final TextEditingController _fluelController = TextEditingController();
  final TextEditingController _numberController = TextEditingController();
  final TextEditingController _registeredCodeController = TextEditingController();

  final TextEditingController _lastDeadlineController = TextEditingController();
  final TextEditingController _lastMarkController = TextEditingController();
  final TextEditingController _deadlineController = TextEditingController();

  DateTime? _lastDeadline = null;
  DateTime? _lastMark = null;
  DateTime? _deadline = null;

  // This function will be triggered when the floating button is pressed
  // It will also be triggered when you want to update an item
  void _showForm(String? id) async {
    // if (id != null) {
    //   // id == null -> create new item
    //   // id != null -> update an existing item
    //   final existingMachine = _machines.firstWhere((element) => element.id == id);
    //   final existingCustomer =
    //   _customers.firstWhere((element) => element.id == id);
    //   _firstnameController.text = existingCustomer.firstname;
    //   _lastnameController.text = existingCustomer.lastname;
    //   _addressController.text = existingCustomer.address;
    //   _phoneController.text = existingCustomer.phone ?? '';
    // }



    _machineRepository = MachineRepository(DatabaseHelper.instance.database!);

    showModalBottomSheet(
        context: context,
        elevation: 5,
        isScrollControlled: true,
        builder: (_) => Container(
          padding: EdgeInsets.only(
            top: 15,
            left: 15,
            right: 15,
            // this will prevent the soft keyboard from covering the text fields
            bottom: MediaQuery.of(context).viewInsets.bottom + 120,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Row(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Flexible(child: TextField(
                    controller: _firstnameController,
                    decoration: const InputDecoration(hintText: 'Firstname'),
                  )),
                  const SizedBox(
                    width: 10,
                  ),
                  Flexible(child: TextField(
                    controller: _lastnameController,
                    decoration: const InputDecoration(hintText: 'Lastname'),
                  ))
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              Row(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Flexible(child: TextField(
                    controller: _addressController,
                    decoration: const InputDecoration(hintText: 'Address'),
                  )),
                  const SizedBox(
                    width: 10,
                  ),
                  Flexible(child: TextField(
                    controller: _phoneController,
                    decoration: const InputDecoration(hintText: 'Phone'),
                  ))
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              Row(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Flexible(child: TextField(
                    controller: _modelController,
                    decoration: const InputDecoration(hintText: 'Model'),
                  )),
                  const SizedBox(
                    width: 10,
                  ),
                  Flexible(child: TextField(
                    controller: _fluelController,
                    decoration: const InputDecoration(hintText: 'Fluel'),
                  ))
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              Row(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Flexible(child: TextField(
                    controller: _numberController,
                    decoration: const InputDecoration(hintText: 'Number'),
                  )),
                  const SizedBox(
                    width: 10,
                  ),
                  Flexible(child: TextField(
                    controller: _registeredCodeController,
                    decoration: const InputDecoration(hintText: 'RegisteredCode'),
                  ))
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              Row(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Flexible(child: TextField(
                    controller: _lastMarkController,
                    decoration: const InputDecoration(
                      icon: Icon(Icons.calendar_today),
                      hintText: 'Last Mark'
                    ),
                    readOnly: true,
                    onTap: () async {
                      _lastMark = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(2000),
                          lastDate: DateTime(2060));
                      if (_lastMark != null) {
                        setState(() {
                          _lastMarkController.text = DateFormat('dd/MM/yyyy').format(_lastMark!);
                        });
                      }
                    },
                  )),
                  const SizedBox(
                    width: 10,
                  ),
                  Flexible(child: TextField(
                    controller: _lastDeadlineController,
                    decoration: const InputDecoration(
                        icon: Icon(Icons.calendar_today),
                        hintText: 'Last Deadline'
                    ),
                    readOnly: true,
                    onTap: () async {
                      _lastDeadline = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(2000),
                          lastDate: DateTime(2060));
                      if (_lastDeadline != null) {
                        setState(() {
                          _lastDeadlineController.text = DateFormat('dd/MM/yyyy').format(_lastDeadline!);
                        });
                      }
                    },
                  )),
                  const SizedBox(
                    width: 10,
                  ),
                  Flexible(child: TextField(
                    controller: _deadlineController,
                    decoration: const InputDecoration(
                        icon: Icon(Icons.calendar_today),
                        hintText: 'Next Deadline'
                    ),
                    readOnly: true,
                    onTap: () async {
                      _deadline = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(2000),
                          lastDate: DateTime(2060));
                      if (_deadline != null) {
                        setState(() {
                          _deadlineController.text = DateFormat('dd/MM/yyyy').format(_deadline!);
                        });
                      }
                    },
                  )),
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              ElevatedButton(
                onPressed: () async {
                  // Save new journal
                  if (id == null) {
                    await _addItem();
                  }

                  if (id != null) {
                    await _updateItem(id);
                  }

                  // Clear the text fields
                  _firstnameController.text = '';
                  _lastnameController.text = '';
                  _addressController.text = '';
                  _phoneController.text = '';
                  _modelController.text = '';
                  _fluelController.text = '';
                  _numberController.text = '';
                  _registeredCodeController.text = '';
                  _lastDeadlineController.text = '';
                  _lastMarkController.text = '';
                  _deadlineController.text = '';
                  _lastDeadline = null;
                  _lastMark = null;
                  _deadline = null;

                  // Close the bottom sheet
                  Navigator.of(context).pop();
                },
                child: Text(id == null ? 'Create New' : 'Update'),
              )
            ],
          ),
        ));
  }

  Future<void> _addItem() async {
    final Customer customer = await _customerRepository.createCustomer(_firstnameController.text,
        _lastnameController.text, _addressController.text, _phoneController.text);
    await _machineRepository.createMachine(customer.id, _modelController.text,
        _fluelController.text, _numberController.text,
        _registeredCodeController.text, _lastMark, _lastDeadline, _deadline
    );
  }

  Future<void> _updateItem(String id) async {
    await _customerRepository.updateCustomer(id, _firstnameController.text,
        _lastnameController.text, _addressController.text, null);
  }

  void _deleteItem(String id) async {
    await _customerRepository.deleteCustomer(id);
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      content: Text('Successfully deleted a journal!'),
    ));
  }

  @override
  Widget build(BuildContext context) {
    final EngagementRepository engagementRepository = EngagementRepository();
    _customerRepository = CustomerRepository(DatabaseHelper.instance.database!);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Gestio'),
      ),
      body: SafeArea(
        child: Container(
          width: double.infinity,
          child: FutureBuilder(
              future: engagementRepository.allDocumentStream(
                  new DateTime(2020),
                  new DateTime(2023)
              ),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator();
                } else if (snapshot.hasError) {
                  return Text('Error!');
                } else if (snapshot.connectionState == ConnectionState.done) {
                  return StreamBuilder(
                    stream: snapshot.data,
                    builder: (context, snapshot) {
                      var customers = snapshot.data;
                      if (customers != null && customers.isNotEmpty) {
                        return DataTable(
                            sortColumnIndex: _currentSortColumn,
                            sortAscending: _isSortAsc,
                            columns: [
                              DataColumn(label: Text('Owner')),
                              DataColumn(label: Text('Address')),
                              DataColumn(label: Text('Model')),
                              DataColumn(label: Text('Number')),
                              DataColumn(label: Text('Registered Code')),
                              DataColumn(label: Text('Last Mark')),
                              DataColumn(label: Text('Last Deadline')),
                              DataColumn(label: Text('Deadline')),
                            ],
                            rows: customers
                                .map((customer) => DataRow(cells: [
                              DataCell(Text(customer.owner)),
                              DataCell(Text(customer.address)),
                              DataCell(Text(customer.model)),
                              DataCell(Text(customer.number)),
                              DataCell(Text(customer.registeredCode)),
                              DataCell(Text(
                                  customer.lastMark != null ?
                                  DateFormat('dd/MM/yyyy').format(customer.lastMark!) :
                                  ''
                              )),
                              DataCell(Text(
                                  customer.lastDeadline != null ?
                                  DateFormat('dd/MM/yyyy').format(customer.lastDeadline!) :
                                  ''
                              )),
                              DataCell(Text(
                                  customer.deadline != null ?
                                  DateFormat('dd/MM/yyyy').format(customer.deadline!) :
                                  ''
                              )),
                            ]))
                                .toList());
                      }
                      return Text('no data');
                    }
                  );
                }
                return Text('no data');
              }),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () => _showForm(null),
      ),
    );
  }
}