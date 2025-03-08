import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:pengingat_pr/firebase/sync_service.dart';
import 'package:pengingat_pr/util/google_sign.dart';

class Register extends StatelessWidget {
  const Register({super.key});

  @override
  Widget build(BuildContext context) {
    final nameController = TextEditingController();
    final emailController = TextEditingController();
    final passwordController = TextEditingController();
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Color.fromARGB(255, 0, 173, 181),
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 0, 173, 181),
        leadingWidth: 90,
        leading: Container(
          decoration: BoxDecoration(
            color: Colors.black,
            shape: BoxShape.circle,
          ),
          child: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            color: Color.fromARGB(255, 0, 173, 181),
            icon: Icon(
              Icons.chevron_left_rounded,
              size: 40,
            ),
          ),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding:
                const EdgeInsets.only(right: 8, top: 8, bottom: 8, left: 20),
            child: Text(
              'Welcome',
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 30,
                  fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: Container(
              margin: EdgeInsets.only(top: 120),
              decoration: BoxDecoration(
                color: Color.fromARGB(255, 34, 40, 49),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.elliptical(45, 23),
                  topRight: Radius.elliptical(45, 23),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.only(top: 20),
                child: Column(
                  children: [
                    //input name
                    Padding(
                      padding:
                          const EdgeInsets.only(top: 20, left: 10, right: 10),
                      child: Container(
                        padding: EdgeInsets.only(left: 10, right: 10),
                        decoration: BoxDecoration(
                          boxShadow: List.filled(
                            3,
                            BoxShadow(
                              color: Color.fromRGBO(0, 0, 0, 0.1),
                              blurRadius: 2,
                            ),
                          ),
                          color: Color.fromARGB(255, 57, 62, 70),
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            width: 0.01,
                            color: Color.fromARGB(255, 0, 173, 181),
                          ),
                        ),
                        child: TextField(
                          controller: nameController,
                          style: TextStyle(
                              color: Color.fromARGB(255, 238, 238, 238)),
                          decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: 'nama',
                              hintStyle: TextStyle(
                                  color: Color.fromARGB(100, 238, 238, 238)),
                              icon: Icon(
                                Icons.person_outline,
                                color: Color.fromARGB(255, 0, 173, 181),
                              )),
                        ),
                      ),
                    ),
                    //input email
                    Padding(
                      padding:
                          const EdgeInsets.only(top: 20, left: 10, right: 10),
                      child: Container(
                        padding: EdgeInsets.only(left: 10, right: 10),
                        decoration: BoxDecoration(
                          boxShadow: List.filled(
                            3,
                            BoxShadow(
                              color: Color.fromRGBO(0, 0, 0, 0.1),
                              blurRadius: 2,
                            ),
                          ),
                          color: Color.fromARGB(255, 57, 62, 70),
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            width: 0.01,
                            color: Color.fromARGB(255, 0, 173, 181),
                          ),
                        ),
                        child: TextField(
                          controller: emailController,
                          style: TextStyle(
                              color: Color.fromARGB(255, 238, 238, 238)),
                          decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: 'email',
                              hintStyle: TextStyle(
                                  color: Color.fromARGB(100, 238, 238, 238)),
                              icon: Icon(
                                Icons.email_outlined,
                                color: Color.fromARGB(255, 0, 173, 181),
                              )),
                        ),
                      ),
                    ),
                    //input password
                    Padding(
                      padding:
                          const EdgeInsets.only(top: 20, left: 10, right: 10),
                      child: Container(
                        padding: EdgeInsets.only(left: 10, right: 10),
                        decoration: BoxDecoration(
                          boxShadow: List.filled(
                            3,
                            BoxShadow(
                              color: Color.fromRGBO(0, 0, 0, 0.1),
                              blurRadius: 2,
                            ),
                          ),
                          color: Color.fromARGB(255, 57, 62, 70),
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            width: 0.01,
                            color: Color.fromARGB(255, 0, 173, 181),
                          ),
                        ),
                        child: TextField(
                          controller: passwordController,
                          style: TextStyle(
                              color: Color.fromARGB(255, 238, 238, 238)),
                          decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: 'password',
                              hintStyle: TextStyle(
                                  color: Color.fromARGB(100, 238, 238, 238)),
                              icon: Icon(
                                Icons.lock_outlined,
                                color: Color.fromARGB(255, 0, 173, 181),
                              )),
                        ),
                      ),
                    ),
                    //submit button
                    Padding(
                      padding: const EdgeInsets.only(top: 20),
                      child: ElevatedButton(
                        onPressed: () async {
                          FocusManager.instance.primaryFocus?.unfocus();
                          final name = nameController.text.trim();
                          final email = emailController.text.trim();
                          final password = passwordController.text.trim();

                          if (name.isEmpty ||
                              email.isEmpty ||
                              password.isEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Harap isi semua field'),
                                backgroundColor: Colors.red,
                              ),
                            );
                            return;
                          }

                          try {
                            showDialog(
                              context: context,
                              barrierDismissible: false,
                              useRootNavigator: true, // Penting!
                              builder: (context) => const Center(
                                  child: CircularProgressIndicator()),
                            );
                            await Future.delayed(
                                const Duration(milliseconds: 50));
                            final credential = await FirebaseAuth.instance
                                .createUserWithEmailAndPassword(
                              email: email,
                              password: password,
                            );

                            await credential.user!.updateDisplayName(name);
                            
                            if (context.mounted) {
                              SyncService syncServiceLogin = SyncService();
                              await syncServiceLogin.syncOnLogin(context);
                            }
                            // Mulai real-time sync jika diperlukan
                            SyncService syncService = SyncService();
                            syncService.startRealTimeSync();

                            if (context.mounted) {
                              Navigator.of(context, rootNavigator: true).pop();
                            }

                            if (context.mounted) {
                              Navigator.pushNamedAndRemoveUntil(
                                context,
                                '/profile',
                                (route) => false,
                              );
                            }
                          } on FirebaseAuthException catch (e) {
                            if (context.mounted) {
                              Navigator.of(context, rootNavigator: true).pop();
                            }
                            String errorMessage;
                            if (e.code == 'weak-password') {
                              errorMessage = 'Password terlalu lemah';
                            } else if (e.code == 'email-already-in-use') {
                              errorMessage = 'Email sudah terdaftar';
                            } else if (e.code == 'invalid-email') {
                              errorMessage = 'Format email tidak valid';
                            } else {
                              errorMessage = 'Terjadi kesalahan: ${e.message}';
                            }

                            if (context.mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(errorMessage),
                                  backgroundColor: Colors.red,
                                ),
                              );
                            }
                          } catch (e) {
                            if (context.mounted) {
                              Navigator.of(context, rootNavigator: true).pop();
                            }

                            if (context.mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('Terjadi kesalahan: $e'),
                                  backgroundColor: Colors.red,
                                ),
                              );
                            }
                          }
                        },
                        style: ButtonStyle(
                          shadowColor: WidgetStatePropertyAll(
                              Color.fromRGBO(0, 0, 0, 0.1)),
                          elevation: WidgetStatePropertyAll(5),
                          backgroundColor: WidgetStatePropertyAll(
                              Color.fromARGB(192, 0, 172, 181)),
                        ),
                        child: Container(
                          width: 200,
                          decoration: BoxDecoration(),
                          child: Center(
                            child: Text(
                              'SIGN UP',
                              style: TextStyle(color: Colors.black),
                            ),
                          ),
                        ),
                      ),
                    ),
                    //text or
                    Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(right: 8.0),
                            child: Text(
                              '──────────',
                              style: TextStyle(
                                color: Colors.white12,
                              ),
                            ),
                          ),
                          Text(
                            'OR',
                            style: TextStyle(color: Colors.white30),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 8.0),
                            child: Text(
                              '──────────',
                              style: TextStyle(color: Colors.white12),
                            ),
                          ),
                        ],
                      ),
                    ),
                    //google button
                    ElevatedButton(
                      style: ButtonStyle(
                        maximumSize: WidgetStatePropertyAll(Size(250, 60)),
                      ),
                      onPressed: () async {
                        showDialog(
                          context: context,
                          barrierDismissible: false,
                          useRootNavigator: true, // Penting!
                          builder: (context) =>
                              const Center(child: CircularProgressIndicator()),
                        );
                        await Future.delayed(const Duration(milliseconds: 50));
                        await signInWithGoogle();

                        SyncService syncServiceLogin = SyncService();
                            await syncServiceLogin.syncOnLogin(context);

                            // Mulai real-time sync jika diperlukan
                            SyncService syncService = SyncService();
                            syncService.startRealTimeSync();

                        if (context.mounted) {
                          Navigator.of(context, rootNavigator: true).pop();
                        }

                        if (context.mounted) {
                          Navigator.pushNamedAndRemoveUntil(
                            context,
                            '/profile',
                            (route) => false,
                          );
                        }
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            'assets/icon-google.png', // Path ikon
                            height: 24, // Ukuran ikon
                          ),
                          SizedBox(width: 8), // Jarak antara ikon dan teks
                          Text(
                            "Sign up with Google",
                            style: TextStyle(
                                fontSize: 16,
                                color: Color.fromARGB(255, 2, 110, 116)),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
