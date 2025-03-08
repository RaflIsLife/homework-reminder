import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pengingat_pr/database/boxes.dart';
import 'package:pengingat_pr/main.dart';

class Profile extends StatefulWidget {
  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 34, 40, 49),
      appBar: AppBar(
        leadingWidth: 90,
        leading: Container(
          decoration: BoxDecoration(
            color: Colors.black,
            shape: BoxShape.circle,
          ),
          child: IconButton(
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => MyApp()),
              );
            },
            color: Color.fromARGB(255, 0, 173, 181),
            icon: Icon(
              Icons.chevron_left_rounded,
              size: 40,
            ),
          ),
        ),
        title: Text('Profil Pengguna',
            style: TextStyle(
                color: Colors.white,
                fontSize: 21,
                fontWeight: FontWeight.bold)),
        elevation: 0,
        centerTitle: true,
        backgroundColor: Color.fromARGB(255, 0, 173, 181),
        foregroundColor: Colors.teal[800],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              // Profile Photo Section
              Stack(
                alignment: Alignment.bottomRight,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                        colors: [Colors.teal, Colors.blue.shade400],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 10,
                          spreadRadius: 2,
                        )
                      ],
                    ),
                    padding: EdgeInsets.all(3),
                    child: CircleAvatar(
                      radius: 60,
                      backgroundImage: AssetImage('assets/default_profile.jpg'),
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.edit, color: Colors.white),
                    onPressed: () {},
                    style: IconButton.styleFrom(
                      backgroundColor: Colors.teal[800],
                      padding: EdgeInsets.all(8),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),

              // Name Section
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    FirebaseAuth.instance.currentUser?.displayName ?? 'Guest',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.teal[900],
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.edit_note, color: Colors.teal[800]),
                    onPressed: () {},
                  ),
                ],
              ),
              SizedBox(height: 40),

              // Stats Cards
              Row(
                children: [
                  Expanded(
                    child: _buildStatsCard(
                      icon: Icons.access_time_filled,
                      value: boxPengingat.length.toString(),
                      label: 'Pengingat Aktif',
                      color: Colors.teal,
                    ),
                  ),
                  SizedBox(width: 15),
                  Expanded(
                    child: _buildStatsCard(
                      icon: Icons.history,
                      value: boxHistory.length.toString(),
                      label: 'Riwayat',
                      color: Colors.blue,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 30),
              ElevatedButton(
                  onPressed: () async {
                    await FirebaseAuth.instance.signOut();
                    if (context.mounted) {

                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => MyApp()),
                    );
                    }
                  },
                  style: ButtonStyle(
                      backgroundColor: WidgetStateProperty.all(Colors.red),
                      fixedSize: WidgetStatePropertyAll(Size(150, 50))),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.logout,
                        color: Colors.white,
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      Text(
                        "Logout",
                        style: TextStyle(color: Colors.white),
                      ),
                    ],
                  ))
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatsCard({
    required IconData icon,
    required String value,
    required String label,
    required Color color,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 20),
      decoration: BoxDecoration(
        color: Color.fromARGB(255, 57, 62, 70),
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(color: Colors.black12, blurRadius: 10, spreadRadius: 2)
        ],
      ),
      child: Column(
        children: [
          Icon(icon, size: 40, color: color),
          SizedBox(height: 10),
          Text(value,
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: color,
              )),
          Text(label,
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 14,
              )),
        ],
      ),
    );
  }
}
