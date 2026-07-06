import 'package:flutter/material.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  State<ChangePasswordScreen> createState() =>
      _ChangePasswordScreenState();
}

class _ChangePasswordScreenState
    extends State<ChangePasswordScreen> {

  final _formKey = GlobalKey<FormState>();

  final currentPasswordController =
      TextEditingController();

  final newPasswordController =
      TextEditingController();

  final confirmPasswordController =
      TextEditingController();

  bool currentHidden = true;
  bool newHidden = true;
  bool confirmHidden = true;

  @override
  void dispose() {
    currentPasswordController.dispose();
    newPasswordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  void changePassword() {

    if (!_formKey.currentState!.validate()) {
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        backgroundColor: Colors.green,
        content: Text(
          "Password Changed Successfully",
        ),
      ),
    );

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: const Text("Change Password"),
        centerTitle: true,
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),

        child: Form(
          key: _formKey,

          child: Column(
            children: [

              const CircleAvatar(
                radius: 50,
                backgroundColor: Colors.indigo,
                child: Icon(
                  Icons.lock_reset,
                  color: Colors.white,
                  size: 50,
                ),
              ),

              const SizedBox(height: 30),

              TextFormField(
                controller:
                    currentPasswordController,
                obscureText: currentHidden,

                decoration: InputDecoration(
                  labelText: "Current Password",
                  prefixIcon:
                      const Icon(Icons.lock),
                  suffixIcon: IconButton(
                    icon: Icon(
                      currentHidden
                          ? Icons.visibility
                          : Icons.visibility_off,
                    ),
                    onPressed: () {
                      setState(() {
                        currentHidden =
                            !currentHidden;
                      });
                    },
                  ),
                  border: OutlineInputBorder(
                    borderRadius:
                        BorderRadius.circular(12),
                  ),
                ),

                validator: (value) {
                  if (value == null ||
                      value.isEmpty) {
                    return "Enter Current Password";
                  }
                  return null;
                },
              ),

              const SizedBox(height: 20),

              TextFormField(
                controller:
                    newPasswordController,
                obscureText: newHidden,

                decoration: InputDecoration(
                  labelText: "New Password",
                  prefixIcon:
                      const Icon(Icons.lock_outline),
                  suffixIcon: IconButton(
                    icon: Icon(
                      newHidden
                          ? Icons.visibility
                          : Icons.visibility_off,
                    ),
                    onPressed: () {
                      setState(() {
                        newHidden = !newHidden;
                      });
                    },
                  ),
                  border: OutlineInputBorder(
                    borderRadius:
                        BorderRadius.circular(12),
                  ),
                ),

                validator: (value) {

                  if (value == null ||
                      value.isEmpty) {
                    return "Enter New Password";
                  }

                  if (value.length < 6) {
                    return "Minimum 6 characters";
                  }

                  return null;
                },
              ),

              const SizedBox(height: 20),

              TextFormField(
                controller:
                    confirmPasswordController,
                obscureText: confirmHidden,

                decoration: InputDecoration(
                  labelText: "Confirm Password",
                  prefixIcon:
                      const Icon(Icons.password),
                  suffixIcon: IconButton(
                    icon: Icon(
                      confirmHidden
                          ? Icons.visibility
                          : Icons.visibility_off,
                    ),
                    onPressed: () {
                      setState(() {
                        confirmHidden =
                            !confirmHidden;
                      });
                    },
                  ),
                  border: OutlineInputBorder(
                    borderRadius:
                        BorderRadius.circular(12),
                  ),
                ),

                validator: (value) {

                  if (value == null ||
                      value.isEmpty) {
                    return "Confirm Password";
                  }

                  if (value !=
                      newPasswordController.text) {
                    return "Passwords do not match";
                  }

                  return null;
                },
              ),

              const SizedBox(height: 35),
                            SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton.icon(
                  onPressed: changePassword,
                  icon: const Icon(Icons.save),
                  label: const Text(
                    "CHANGE PASSWORD",
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.indigo,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 15),

              SizedBox(
                width: double.infinity,
                height: 55,
                child: OutlinedButton.icon(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: const Icon(Icons.arrow_back),
                  label: const Text(
                    "BACK",
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  style: OutlinedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                child: const ListTile(
                  leading: CircleAvatar(
                    backgroundColor: Colors.indigo,
                    child: Icon(
                      Icons.security,
                      color: Colors.white,
                    ),
                  ),
                  title: Text(
                    "Security Tips",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  subtitle: Text(
                    "Use a strong password with at least 8 characters, including uppercase, lowercase, numbers, and special symbols.",
                  ),
                ),
              ),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}