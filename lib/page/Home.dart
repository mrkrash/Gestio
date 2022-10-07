import 'package:cbl/cbl.dart';
import 'package:flutter/material.dart';
import '../customer/Customer.dart';
import '../customer/CustomerRepository.dart';
import '../db/DatabaseHelper.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentSortColumn = 0;
  bool _isSortAsc = true;
  late List<Customer> _customers;
  late CustomerRepository _customerRepository;
  final TextEditingController _firstnameController = TextEditingController();
  final TextEditingController _lastnameController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();

  // This function will be triggered when the floating button is pressed
  // It will also be triggered when you want to update an item
  void _showForm(String? id) async {
    if (id != null) {
      // id == null -> create new item
      // id != null -> update an existing item
      final existingCustomer =
      _customers.firstWhere((element) => element.id == id);
      _firstnameController.text = existingCustomer.firstname;
      _lastnameController.text = existingCustomer.lastname;
      _addressController.text = existingCustomer.address;
    }

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
              TextField(
                controller: _firstnameController,
                decoration: const InputDecoration(hintText: 'Firstname'),
              ),
              const SizedBox(
                height: 10,
              ),
              TextField(
                controller: _lastnameController,
                decoration: const InputDecoration(hintText: 'Lastname'),
              ),
              const SizedBox(
                height: 10,
              ),
              TextField(
                controller: _addressController,
                decoration: const InputDecoration(hintText: 'Address'),
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

                  // Close the bottom sheet
                  Navigator.of(context).pop();
                },
                child: Text(id == null ? 'Create New' : 'Update'),
              )
            ],
          ),
        ));
  }

// Insert a new journal to the database
  Future<void> _addItem() async {
    await _customerRepository.createCustomer(_firstnameController.text,
        _lastnameController.text, _addressController.text, null, null);
  }

  // Update an existing journal
  Future<void> _updateItem(String id) async {
    await _customerRepository.updateCustomer(id, _firstnameController.text,
        _lastnameController.text, _addressController.text, null);
  }

  // Delete an item
  void _deleteItem(String id) async {
    await _customerRepository.deleteCustomer(id);
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      content: Text('Successfully deleted a journal!'),
    ));
  }

  @override
  Widget build(BuildContext context) {
    _customerRepository = CustomerRepository(DatabaseHelper.instance.database!);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Gestio'),
      ),
      body: SafeArea(
        child: Center(
          child: StreamBuilder(
              stream: _customerRepository.allCustomerStream(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator();
                } else if (snapshot.connectionState == ConnectionState.done) {
                  return Text('done');
                } else if (snapshot.hasError) {
                  return Text('Error!');
                } else {
                  var customers = snapshot.data?.toList();
                  if (customers != null && customers.isNotEmpty) {
                    return DataTable(
                        sortColumnIndex: _currentSortColumn,
                        sortAscending: _isSortAsc,
                        columns: [
                          DataColumn(
                            label: Text('Firstname'),
                            onSort: (columnIndex, _) {
                              setState(() {
                                _currentSortColumn = columnIndex;
                                if (_isSortAsc) {
                                  customers.sort((a, b) =>
                                      b.firstname.compareTo(a.firstname));
                                } else {
                                  customers.sort((a, b) =>
                                      a.firstname.compareTo(b.firstname));
                                }
                                _isSortAsc = !_isSortAsc;
                              });
                            },
                          ),
                          DataColumn(label: Text('Lastname')),
                          DataColumn(label: Text('Address')),
                        ],
                        rows: customers
                            .map((customer) => DataRow(cells: [
                          DataCell(Text(customer.firstname)),
                          DataCell(Text(customer.lastname)),
                          DataCell(Text(customer.address)),
                        ]))
                            .toList());
                  }
                  return Text('no data');
                }
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