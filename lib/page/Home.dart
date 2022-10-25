import 'package:flutter/material.dart';
import 'package:gestio/db/DatabaseHelper.dart';
import 'package:gestio/document/EngagementRepository.dart';
import 'package:gestio/document/machine/MachineRepository.dart';
import 'package:gestio/document/customer/Customer.dart';
import 'package:gestio/document/customer/CustomerRepository.dart';
import 'package:gestio/document/Engagement.dart';
import 'package:intl/intl.dart';
import 'package:month_picker_dialog_2/month_picker_dialog_2.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentSortColumn = 0;
  bool _isSortAsc = true;

  late AppLocalizations t;
  late CustomerRepository _customerRepository;
  late MachineRepository _machineRepository;

  final EngagementRepository engagementRepository = EngagementRepository();

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

  final TextEditingController _searchController = TextEditingController();

  DateTime? _selectedMonth;
  DateTime? _lastDeadline;
  DateTime? _lastMark;
  DateTime? _deadline;

  Future<Stream<List<Engagement>>>? _documents;

  // This function will be triggered when the floating button is pressed
  // It will also be triggered when you want to update an item
  void _showForm(Engagement? engagement) async {
    if (engagement != null) {
         _firstnameController.text = engagement.firstname;
         _lastnameController.text = engagement.lastname;
         _addressController.text = engagement.address;
         _phoneController.text = engagement.phone ?? '';
         _modelController.text = engagement.model;
         _fluelController.text = engagement.fluel;
         _numberController.text = engagement.number;
         _registeredCodeController.text = engagement.registeredCode;
         _lastDeadline = engagement.lastDeadline;
         _lastDeadlineController.text = engagement.lastDeadline != null
             ? DateFormat('dd/MM/yyyy').format(engagement.lastDeadline!) : '';
         _lastMark = engagement.lastMark;
         _lastMarkController.text = engagement.lastMark != null
             ? DateFormat('dd/MM/yyyy').format(engagement.lastMark!) : '';
         _deadline = engagement.deadline;
         _deadlineController.text = DateFormat('dd/MM/yyyy')
             .format(engagement.deadline);
    }

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
                    decoration: InputDecoration(hintText: t.firstname),
                  )),
                  const SizedBox(
                    width: 10,
                  ),
                  Flexible(child: TextField(
                    controller: _lastnameController,
                    decoration: InputDecoration(hintText: t.lastname),
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
                    decoration: InputDecoration(hintText: t.address),
                  )),
                  const SizedBox(
                    width: 10,
                  ),
                  Flexible(child: TextField(
                    controller: _phoneController,
                    decoration: InputDecoration(hintText: t.phone),
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
                    decoration: InputDecoration(hintText: t.model),
                  )),
                  const SizedBox(
                    width: 10,
                  ),
                  Flexible(child: TextField(
                    controller: _fluelController,
                    decoration: InputDecoration(hintText: t.fluel),
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
                    decoration: InputDecoration(hintText: t.number),
                  )),
                  const SizedBox(
                    width: 10,
                  ),
                  Flexible(child: TextField(
                    controller: _registeredCodeController,
                    decoration: InputDecoration(hintText: t.registeredCode),
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
                    decoration: InputDecoration(
                      icon: const Icon(Icons.calendar_today),
                      hintText: t.lastMark
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
                    decoration: InputDecoration(
                        icon: const Icon(Icons.calendar_today),
                        hintText: t.lastDeadline
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
                    decoration: InputDecoration(
                        icon: const Icon(Icons.calendar_today),
                        hintText: t.deadline
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
                  if (engagement == null) {
                    await _addItem();
                  }

                  if (engagement != null) {
                    await _updateItem(engagement);
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
                child: Text(engagement?.id == null ? t.createItem : t.updateItem),
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

  Future<void> _updateItem(Engagement engagement) async {
    await _customerRepository.updateCustomer(engagement.ownerID, _firstnameController.text,
        _lastnameController.text, _addressController.text, _phoneController.text);
    await _machineRepository.updateMachine(engagement.id, engagement.ownerID,
        _modelController.text, _fluelController.text, _numberController.text,
        _registeredCodeController.text, _lastMark, _lastDeadline, _deadline);
  }

  void _deleteItem(String id) async {
    await _customerRepository.deleteCustomer(id);
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      content: Text('Successfully deleted a journal!'),
    ));
  }

  @override
  void initState() {
    _documents = engagementRepository.allDocumentStream(
        DateTime(DateTime.now().year, DateTime.now().month, 1),
        DateTime(DateTime.now().year, DateTime.now().month +1, 0)
    );
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    t = AppLocalizations.of(context)!;
    _customerRepository = CustomerRepository(DatabaseHelper.instance.database!);
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.appTitle),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 0.0, horizontal: 10.0),
            child: IconButton(onPressed: () async {
                _selectedMonth = await showMonthPicker(
                    context: context,
                    firstDate: DateTime(DateTime.now().year - 1, 5),
                    lastDate: DateTime(DateTime.now().year + 1, 9),
                    initialDate: _selectedMonth ?? DateTime.now(),
                );
                if (_selectedMonth != null) {
                  var lastDayDateTime = (_selectedMonth!.month < 12) ?
                  DateTime(_selectedMonth!.year, _selectedMonth!.month + 1, 0) :
                  DateTime(_selectedMonth!.year + 1, 1, 0);
                  setState(() {
                    _documents = engagementRepository.allDocumentStream(
                        _selectedMonth!,
                        lastDayDateTime
                    );
                  });
                }
              }, icon: const Icon(Icons.calendar_month))
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 0.0, horizontal: 10.0),
            child: new ListTile(
              leading: Icon(Icons.search),
              title: new TextField(
                controller: _searchController,
                decoration: new InputDecoration(
                  hintText: t.search,
                  border: InputBorder.none
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 0.0, horizontal: 10.0),
            child: IconButton(onPressed: () {}, icon: const Icon(Icons.settings),),
          )
        ],
      ),
      body: SafeArea(
        child: SizedBox(
          width: double.infinity,
          child: FutureBuilder(
              future: _documents,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                } else if (snapshot.hasError) {
                  return const Text('Error!');
                } else if (snapshot.connectionState == ConnectionState.done) {
                  return StreamBuilder(
                    stream: snapshot.data,
                    builder: (context, snapshot) {
                      var customers = snapshot.data;
                      if (customers != null && customers.isNotEmpty) {
                        return SingleChildScrollView(
                            scrollDirection: Axis.vertical,
                            child: FittedBox(
                              child:DataTable(
                                sortColumnIndex: _currentSortColumn,
                                sortAscending: _isSortAsc,
                                columns: [
                                  DataColumn(label: Text(t.owner)),
                                  DataColumn(label: Text(t.address)),
                                  DataColumn(label: Text(t.model)),
                                  DataColumn(label: Text(t.number)),
                                  DataColumn(label: Text(t.registeredCode)),
                                  DataColumn(label: Text(t.lastMark)),
                                  DataColumn(label: Text(t.lastDeadline)),
                                  DataColumn(label: Text(t.deadline)),
                                  DataColumn(label: Text(t.actions)),
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
                                  DataCell(IconButton(
                                    onPressed: () => _showForm(customer),
                                    icon: const Icon(Icons.edit),
                                  )),
                                ])).toList())
                            )
                        );
                      }
                      return const Text('no data');
                    }
                  );
                }
                return const Text('no data');
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