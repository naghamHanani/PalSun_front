import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:test_back/const/constant.dart';
import 'package:test_back/mainDash.dart';
import 'package:test_back/screens/home.dart';
import 'package:test_back/screens/plants.dart';
import 'package:test_back/screens/reports.dart';

class Devices extends StatefulWidget {
  const Devices({super.key});

  @override
  State<Devices> createState() => _DevicesState();
}

class _DevicesState extends State<Devices> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  final ScrollController _scrollController = ScrollController();

   FocusNode focusNode = FocusNode();
  // Device data
  List<Map<String, dynamic>> devices = [
    {
      'deviceId': 1,
      'name': 'Device 1',
      'plantId': 101,
      'timezone': 'UTC+1',
      'type': 'Inverter',
      'product': 'SolarEdge',
      'productId': 1001,
      'serial': 123456,
      'vendor': 'Vendor A',
      'generatorPower': 1000,
      'isActive': true,
      'deactivatedAt': null,
      'batteryCapacity': 500,
      'ipAddress': '192.168.1.1',
      'firmwareVersion': '1.0.3',
      'communicationProtocol': 'Modbus',
      'startUpUtc': '2025-01-01 10:00:00',
      'isResetted': false,
      'termOfGuarantee': '2026-01-01 10:00:00',
      'isSmartConnectedReady': true,
      'status': 'Active',
      'operationStatus': 'Online',
      'sets': '{"key1": "value1", "key2": "value2"}',
      'subPlantID': 2001,
    },
    {
      'deviceId': 2,
      'name': 'Device 2',
      'plantId': 102,
      'timezone': 'UTC-5',
      'type': 'Generator',
      'product': 'GE',
      'productId': 1002,
      'serial': 123457,
      'vendor': 'Vendor B',
      'generatorPower': 1500,
      'isActive': false,
      'deactivatedAt': '2024-12-01 12:00:00',
      'batteryCapacity': 1000,
      'ipAddress': '192.168.1.2',
      'firmwareVersion': '1.0.1',
      'communicationProtocol': 'SNMP',
      'startUpUtc': '2024-01-01 10:00:00',
      'isResetted': true,
      'termOfGuarantee': '2025-01-01 10:00:00',
      'isSmartConnectedReady': false,
      'status': 'Inactive',
      'operationStatus': 'Offline',
      'sets': '{"keyA": "valueA", "keyB": "valueB"}',
      'subPlantID': 2002,
    },
    // Add more devices as needed
  ];

  List<Map<String, dynamic>> filteredDevices = [];
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    filteredDevices = devices; 
  }

  void filterDevices(String query) {
    setState(() {
      if (query.isEmpty) {
        filteredDevices = devices;
      } else {
        filteredDevices = devices
            .where((device) =>
                device['name'].toLowerCase().contains(query.toLowerCase()) ||
                device['type'].toLowerCase().contains(query.toLowerCase()) ||
                device['status'].toLowerCase().contains(query.toLowerCase()))
            .toList();
      }
    });
  }

  // @override
  // void dispose() {
  //   _scrollController.dispose(); // Dispose of the ScrollController
  //   super.dispose();
  // }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      navigatorKey: navigatorKey,
      home: Scaffold(
        key: _scaffoldKey,
        backgroundColor: darkThemeBG,
        appBar: AppBar(
          backgroundColor: darkThemeBG,
          leading: IconButton(
            icon: Icon(Icons.menu, color: Colors.white),
            onPressed: () {
              _scaffoldKey.currentState?.openDrawer();
            },
          ),
          title: Text(
            '                                                               PALSUN',
            style: GoogleFonts.montserrat(
              fontSize: 20,
              fontWeight: FontWeight.w500,
              color: Colors.white,
              letterSpacing: 5.0,
            ),
          ),
        ),
        drawer: Drawer(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.zero),
          backgroundColor: Colors.blueGrey,
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              DrawerHeader(
                decoration: BoxDecoration(color: Colors.black),
                child: Text(
                  'Menu',
                  style: GoogleFonts.montserrat(
                    textStyle: TextStyle(color: Colors.white, fontSize: 24),
                  ),
                ),
              ),
              ListTile(
                leading: Icon(Icons.electrical_services, color: Colors.blueGrey),
                title: Text(
                  'Devices',
                  style: GoogleFonts.montserrat(
                    textStyle: TextStyle(
                      color: Colors.blueGrey[900],
                      fontWeight: FontWeight.w500,
                      fontSize: 16,
                    ),
                  ),
                ),
                onTap: () {
                  navigatorKey.currentState?.push(MaterialPageRoute(builder: (context) => Devices()));
                },
              ),
               ListTile(
              leading: Icon(Icons.bar_chart,color:darkThemeBG),
              title: Text(
               'Reports',
               style: GoogleFonts.montserrat(
               textStyle: TextStyle(
                color: Color.fromARGB(255, 29, 63, 90),
                fontWeight: FontWeight.w500,
                fontSize: 16,
              ),
               ), ),
              onTap: () {
                // Navigate to Link 3
                navigatorKey.currentState?.push(
                 MaterialPageRoute(builder: (context) => Reports(
                  
                 )),
                 ); // Close the drawer
              },
            ),
            ListTile(
              leading: Icon(Icons.bar_chart,color:darkThemeBG),
              title: Text(
               'Home',
               style: GoogleFonts.montserrat(
               textStyle: TextStyle(
                color: Color.fromARGB(255, 29, 63, 90),
                fontWeight: FontWeight.w500,
                fontSize: 16,
              ),
               ), ),
              onTap: () {
                // Navigate to Link 3
                navigatorKey.currentState?.push(
                 MaterialPageRoute(builder: (context) => HomePage(
                  
                 )),
                 ); // Close the drawer
              },
            ),
            ListTile(
              leading: Icon(Icons.analytics ,color:darkThemeBG),
              title: Text(
              'Dashboard',
              style: GoogleFonts.montserrat(
              textStyle: TextStyle(
                color: Color.fromARGB(255, 29, 63, 90),
                fontWeight: FontWeight.w500,
                fontSize: 16,
              ),
              ), ),
              onTap: () {
                // Navigate to Link 3
                navigatorKey.currentState?.push(
                 MaterialPageRoute(builder: (context) => MyApp()),
                ); // Close the drawer
              },
            ),

            ListTile(
              leading: Icon(Icons.eco,color:darkThemeBG),
              title: Text(
              'Plants',
              style: GoogleFonts.montserrat(
              textStyle: TextStyle(
                color: Color.fromARGB(255, 29, 63, 90),
                fontWeight: FontWeight.w500,
                fontSize: 16,
              ),
              ), ),
              onTap: () {
                // Navigate to Link 1
              navigatorKey.currentState?.push(
              MaterialPageRoute(builder: (context) => Plants()),
              );
              },
            ),
            ],
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              // Search bar
             
              TextField(
                 focusNode: focusNode,
                controller: searchController,
                onChanged: filterDevices,
                decoration: InputDecoration(
                  hintText: 'Search devices...',
                  prefixIcon: const Icon(Icons.search),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              // Paginated Table with Scrollbar
              Expanded(
                child: Scrollbar(
                  controller: _scrollController, // Pass the ScrollController
                  thumbVisibility: true, // Ensure the scrollbar is visible when scrolling
                  child: SingleChildScrollView(
                    controller: _scrollController, // Attach the ScrollController
                    scrollDirection: Axis.horizontal, // Enable horizontal scrolling
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        minWidth: MediaQuery.of(context).size.width, // Full screen width
                        maxWidth: 2000, // Max width for all columns combined
                      ),
                      child: PaginatedDataTable(
                        header: const Text('Devices'),
                        columns: const [
                          DataColumn(label: Text('ID')),
                          DataColumn(label: Text('Name')),
                          DataColumn(label: Text('Plant ID')),
                          DataColumn(label: Text('Timezone')),
                          DataColumn(label: Text('Type')),
                          DataColumn(label: Text('Product')),
                          DataColumn(label: Text('Product ID')),
                          DataColumn(label: Text('Serial')),
                          DataColumn(label: Text('Vendor')),
                          DataColumn(label: Text('Power (kW)')),
                          DataColumn(label: Text('Battery Capacity (Wh)')),
                          DataColumn(label: Text('IP Address')),
                          DataColumn(label: Text('Firmware')),
                          DataColumn(label: Text('Protocol')),
                          DataColumn(label: Text('Startup Time')),
                          DataColumn(label: Text('Guarantee End')),
                          DataColumn(label: Text('Smart Ready')),
                          DataColumn(label: Text('Status')),
                          DataColumn(label: Text('Operation')),
                        ],
                        source: DevicesDataTableSource(filteredDevices),
                        rowsPerPage: 5,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class DevicesDataTableSource extends DataTableSource {
  final List<Map<String, dynamic>> devices;

  DevicesDataTableSource(this.devices);

  @override
  DataRow? getRow(int index) {
    if (index >= devices.length) return null;

    final device = devices[index];
    return DataRow(cells: [
      DataCell(Text(device['deviceId'].toString())),
      DataCell(Text(device['name'])),
      DataCell(Text(device['plantId'].toString())),
      DataCell(Text(device['timezone'])),
      DataCell(Text(device['type'])),
      DataCell(Text(device['product'])),
      DataCell(Text(device['productId'].toString())),
      DataCell(Text(device['serial'].toString())),
      DataCell(Text(device['vendor'])),
      DataCell(Text(device['generatorPower'].toString())),
      DataCell(Text(device['batteryCapacity'].toString())),
      DataCell(Text(device['ipAddress'])),
      DataCell(Text(device['firmwareVersion'])),
      DataCell(Text(device['communicationProtocol'])),
      DataCell(Text(device['startUpUtc'])),
      DataCell(Text(device['termOfGuarantee'])),
      DataCell(Text(device['isSmartConnectedReady'] ? 'Yes' : 'No')),
      DataCell(Text(device['status'])),
      DataCell(Text(device['operationStatus'])),
    ]);
  }

  @override
  int get rowCount => devices.length;

  @override
  bool get isRowCountApproximate => false;

  @override
  int get selectedRowCount => 0;
}
