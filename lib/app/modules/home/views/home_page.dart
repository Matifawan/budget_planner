import 'package:budget_planner/app/modules/home/controllers/home_controller.dart';
import 'package:budget_planner/app/modules/home/views/onboarding.dart';
import 'package:budget_planner/core/firebaseservice.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:get/get.dart';

import 'package:syncfusion_flutter_charts/charts.dart';

class HomePage extends StatefulWidget {
  final User user; // Define the user property

  const HomePage({super.key, required this.user});

  @override
  // ignore: library_private_types_in_public_api
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController budgetController = TextEditingController();
  final TextEditingController expensesController = TextEditingController();
  final TextEditingController savingsController = TextEditingController();
  List<String> logs = [];
  List<double> pieChartData = [0, 0, 0]; // Budget, Expenses, Savings
  int _currentIndex = 0; // Remove 'final' to allow changing the value
  void _showSnackBar(String message, BuildContext context) {
    final snackBar = SnackBar(
      content: Text(message),
      duration: const Duration(seconds: 5),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  late String userId;

  @override
  void initState() {
    super.initState();
    userId = 'user1';
  }

  @override
  Widget build(BuildContext context) {
    String userEmail = widget.user.email ?? '';

    return MaterialApp(
      home: Scaffold(
        drawer: Drawer(
          backgroundColor: const Color.fromARGB(255, 207, 161, 219),
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              DrawerHeader(
                decoration: const BoxDecoration(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(
                      Icons.account_circle,
                      color: Colors.white,
                      size: 64,
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Welcome back', // Replace with the actual user's name
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                      ),
                    ),
                    Text(
                      userEmail,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
              ListTile(
                leading:
                    const Icon(Icons.update, size: 30, color: Colors.white),
                title: const Text('Monthly Data'),
                onTap: () {
                  Navigator.pop(context); // Close the drawer
                  // Implement logic for updating data
                },
              ),
              ListTile(
                leading: const Icon(Icons.list, size: 30, color: Colors.white),
                title: const Text('Create model on its own'),
                onTap: () {
                  Navigator.pop(context); // Close the drawer
                  // Implement logic for showing logs
                },
              ),
              ListTile(
                leading: const Icon(Icons.air_outlined,
                    size: 30, color: Colors.white),
                title: const Text('AI data generator'),
                onTap: () {
                  Navigator.pop(context); // Close the drawer
                  // Implement logic for showing charts
                  // Assuming homeController is an instance of your HomeController
                },
              ),
              ListTile(
                leading: const Icon(Icons.exit_to_app,
                    size: 30, color: Colors.white),
                title: const Text('Logout'),
                onTap: () async {
                  await FirebaseAuth.instance.signOut();

                  var homeController = HomeController(FirebaseService());
                  Get.offAll(() => Onboarding(controller: homeController));
                },
              ),
            ],
          ),
        ),
        body: CustomScrollView(
          slivers: [
            const SliverAppBar(
              expandedHeight: 50.0,
              pinned: true,
              backgroundColor: Colors.transparent,
              flexibleSpace: FlexibleSpaceBar(),
            ),
            SliverToBoxAdapter(
              child: Column(
                children: [
                  Image.asset(
                    'assets/images/z.png',
                    height: 220,
                    width: 330,
                    fit: BoxFit.cover, // Adjust the height as needed
                  ),
                ],
              ),
            ),
            SliverFillRemaining(
              child: _buildBody(),
            ),
          ],
        ),
        //

        bottomNavigationBar: BottomNavigationBar(
          backgroundColor: Colors.orange,
          selectedItemColor: Colors.white,
          unselectedItemColor: Colors.black,
          currentIndex: _currentIndex,
          onTap: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
          items: [
            BottomNavigationBarItem(
              icon: Icon(
                _currentIndex == 0 ? Icons.home : Icons.home_outlined,
              ),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(
                _currentIndex == 1 ? Icons.list : Icons.list_alt_outlined,
              ),
              label: 'Reports',
            ),
            BottomNavigationBarItem(
              icon: Icon(
                _currentIndex == 2 ? Icons.pie_chart : Icons.pie_chart_outline,
              ),
              label: 'Charts',
            ),
          ],
        ),
        //
//
        //
        //
      ),
//

      ///
/////
/////
/////
////
      ///
    );
  }

  Widget _buildBody() {
    switch (_currentIndex) {
      case 0:
        return _buildUpdateDataTab();
      case 1:
        return _buildShowLogsTab();
      case 2:
        return _buildShowChartsTab();
      default:
        return Container();
    }
  }

  Widget _buildInputField({
    required String label,
    required TextEditingController controller,
    required IconData icon,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.transparent, // Set transparent background
        border: Border.all(
            color: const Color.fromARGB(255, 39, 6, 129)), // Add border
        borderRadius: BorderRadius.circular(10),
      ),
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
      margin: const EdgeInsets.only(bottom: 10),
      child: TextField(
        controller: controller,
        keyboardType: TextInputType.number,
        decoration: InputDecoration(
          hintText: 'Enter $label', // Display label as hint text
          hintStyle: const TextStyle(color: Colors.grey),
          border: InputBorder.none,
          prefixIcon: Padding(
            padding: const EdgeInsets.only(right: 10),
            child: Icon(
              icon,
              size: 38,
              color: Colors.deepPurpleAccent,
            ),
          ),
          suffixIcon: Padding(
            padding: const EdgeInsets.only(left: 10),
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 12, // Set a smaller font size
                fontWeight: FontWeight.bold,
                color: Colors.deepPurpleAccent,
              ),
            ),
          ),
        ),
      ),
    );
  }
  //

  Widget _buildUpdateDataTab() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: ListView(
        children: [
          _buildInputField(
            label: 'Budget',
            controller: budgetController,
            icon: Icons.attach_money,
          ),
          _buildInputField(
            label: 'Expenses',
            controller: expensesController,
            icon: Icons.shopping_cart,
          ),
          _buildInputField(
            label: 'Savings',
            controller: savingsController,
            icon: Icons.account_balance_wallet,
          ),
          const SizedBox(height: 5),
          Align(
            alignment: Alignment.topRight,
            child: SizedBox(
              width: 130,
              child: ElevatedButton.icon(
                onPressed: () {
                  updateUserData();
                  _showSnackBar('Data saved!', context);
                  _showSuccessDialog();
                },
                icon: const Icon(Icons.save),
                label: const Text('Save Data'),
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: const Color.fromARGB(255, 142, 17, 17),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  padding:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildShowLogsTab() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 20),
          Expanded(
            child: ListView.builder(
              itemCount: logs.length,
              itemBuilder: (context, index) {
                return _buildLogCard(index, logs[index]);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLogCard(int index, String log) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.deepPurpleAccent),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Column(
            children: [
              Icon(
                Icons.details,
                size: 30,
                color: Colors.deepPurpleAccent,
              ),
              SizedBox(height: 8),
              Text(
                'Details',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: Colors.deepPurpleAccent,
                ),
              ),
            ],
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  log,
                  style: const TextStyle(fontSize: 16),
                ),
              ],
            ),
          ),
          Container(
            alignment: Alignment.topRight,
            child: Text(
              'Index: $index',
              style: const TextStyle(
                fontSize: 12,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildShowChartsTab() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: SfCircularChart(
        legend: const Legend(
          isVisible: true,
          position: LegendPosition.bottom,
          orientation: LegendItemOrientation.vertical,
          iconHeight: 13,
          iconWidth: 25,
        ),
        series: <PieSeries<Map<String, dynamic>, String>>[
          PieSeries<Map<String, dynamic>, String>(
            dataSource: _generateSections(),
            xValueMapper: (Map<String, dynamic> data, _) => data['title'],
            yValueMapper: (Map<String, dynamic> data, _) =>
                data['value'] as num?,
            dataLabelSettings: const DataLabelSettings(isVisible: true),
            explode: true,
            radius: '80',
            pointColorMapper: (Map<String, dynamic> datum, _) => datum['color'],
            dataLabelMapper: (Map<String, dynamic> datum, _) =>
                '${datum['title']}: ${datum['value']}',
          ),
        ],
      ),
    );
  }

  void updateUserData() {
    int budget = int.tryParse(budgetController.text) ?? 0;
    int expenses = int.tryParse(expensesController.text) ?? 0;
    int savings = int.tryParse(savingsController.text) ?? 0;

    updateUserDataInFirebase(userId, budget, expenses, savings);

    logData(userId, budget, expenses, savings);

    // Update Pie Chart data
    setState(() {
      pieChartData = [
        budget.toDouble(),
        expenses.toDouble(),
        savings.toDouble()
      ];
    });
// Show the success snackbar using GetX

    // Show the success snackbar using GetX

    Get.snackbar(
      'Data Added!',
      '',
      snackPosition: SnackPosition.TOP,
      duration: const Duration(seconds: 4),
      backgroundColor: Colors.deepPurple,
      colorText: Colors.white,
      isDismissible: true,
      forwardAnimationCurve: Curves.easeOut,
      reverseAnimationCurve: Curves.easeIn,
      icon: const Icon(
        Icons.save,
        color: Colors.white,
      ),
      shouldIconPulse: true,
      mainButton: TextButton(
        onPressed: () {
          Get.back(); // Close the snackbar
        },
        child: const Text(
          'Done!',
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }

  void showLogs() {
    // Implementation of showing logs
    // You can use logs list to display logs
  }

  void updateUserDataInFirebase(
      String userId, int budget, int expenses, int savings) {
    DatabaseReference userRef =
        // ignore: deprecated_member_use
        FirebaseDatabase.instance.reference().child('users').child(userId);
    userRef.update({
      'budget': budget,
      'expenses': expenses,
      'savings': savings,
    });
  }

  void logData(String userId, int budget, int expenses, int savings) {
    String log = 'User $userId inserted data: '
        'Budget: $budget, Expenses: $expenses, Savings: $savings';
    setState(() {
      logs.add(log);
    });
  }

  List<Map<String, dynamic>> _generateSections() {
    List<Map<String, dynamic>> sections = [
      {
        'color': const Color.fromARGB(255, 5, 181, 11),
        'value': pieChartData[0],
        'title': 'Budget',
        'radius': 40,
        'titleStyle': const TextStyle(color: Colors.white),
      },
      {
        'color': const Color.fromARGB(255, 3, 7, 65),
        'value': pieChartData[1],
        'title': 'Expenses',
        'radius': 40,
        'titleStyle': const TextStyle(color: Colors.white),
      },
      {
        'color': const Color.fromARGB(255, 32, 107, 168),
        'value': pieChartData[2],
        'title': 'Savings',
        'radius': 40,
        'titleStyle': const TextStyle(color: Colors.white),
      },
    ];

    return sections;
  }

  void _showSuccessDialog() {
    Get.defaultDialog(
      title: 'Success',
      content: const Text('Check Reports \n Charts'),
      textCancel: 'Done!',
      onCancel: () {
        Get.back();
      },
    );
  }

// Assuming HomeController is accessible in the scope where logout is called
  Future<void> logout() async {
    await FirebaseAuth.instance.signOut();
    // Instantiate HomeController before navigating and pass it to Onboarding
    var homeController = HomeController(
        FirebaseService()); // Adjust this based on your actual implementation
    Get.offAll(() => Onboarding(controller: homeController));
  }

//
}
