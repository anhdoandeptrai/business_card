import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // Để đọc file JSON
import 'package:get/get.dart';

class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();

  // Controllers for input fields
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController fullNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();

  String gender = "Nam"; // Default gender
  DateTime? dateOfBirth;
  String selectedCountryCode = "+84"; // Default country code (Vietnam)
  List<Map<String, String>> countryCodes = []; // List of country codes

  @override
  void initState() {
    super.initState();
    _loadCountryCodes(); // Load country codes from JSON
  }

  // Load country codes from JSON file
  Future<void> _loadCountryCodes() async {
    final String response =
        await rootBundle.loadString('assets/dial_code.json');
    final data = json.decode(response);
    setState(() {
      countryCodes = (data['countries'] as List)
          .map((country) => {
                'name': country['name'].toString(),
                'dial_code': country['dial_code'].toString(),
              })
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Đăng ký"),
        backgroundColor: Colors.blue.shade400,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Username
                TextFormField(
                  controller: usernameController,
                  decoration: InputDecoration(
                    labelText: "Tên đăng nhập",
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Vui lòng nhập tên đăng nhập";
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16),

                // Password
                TextFormField(
                  controller: passwordController,
                  decoration: InputDecoration(
                    labelText: "Mật khẩu",
                    border: OutlineInputBorder(),
                  ),
                  obscureText: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Vui lòng nhập mật khẩu";
                    }
                    if (value.length < 6) {
                      return "Mật khẩu phải có ít nhất 6 ký tự";
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16),

                // Full Name
                TextFormField(
                  controller: fullNameController,
                  decoration: InputDecoration(
                    labelText: "Họ và tên",
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Vui lòng nhập họ và tên";
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16),

                // Date of Birth
                TextButton(
                  onPressed: () async {
                    final pickedDate = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(1900),
                      lastDate: DateTime.now(),
                    );
                    if (pickedDate != null) {
                      setState(() {
                        dateOfBirth = pickedDate;
                      });
                    }
                  },
                  child: Text(
                    dateOfBirth == null
                        ? "Chọn ngày sinh"
                        : "Ngày sinh: ${dateOfBirth!.toLocal()}".split(' ')[0],
                  ),
                ),
                SizedBox(height: 16),

                // Gender
                DropdownButtonFormField<String>(
                  value: gender,
                  items: ["Nam", "Nữ", "Other"]
                      .map((gender) => DropdownMenuItem(
                            value: gender,
                            child: Text(gender),
                          ))
                      .toList(),
                  onChanged: (value) {
                    setState(() {
                      gender = value!;
                    });
                  },
                  decoration: InputDecoration(
                    labelText: "Giới tính",
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 16),

                // Phone Number with Country Code
                Row(
                  children: [
                    // Country Code Dropdown
                    DropdownButton<String>(
                      value: selectedCountryCode,
                      items: countryCodes
                          .map((code) => DropdownMenuItem(
                                value: code['dial_code'],
                                child: Text(
                                    "${code['name']} (${code['dial_code']})"),
                              ))
                          .toList(),
                      onChanged: (value) {
                        setState(() {
                          selectedCountryCode = value!;
                        });
                      },
                    ),
                    SizedBox(width: 10),

                    // Phone Number Input
                    Expanded(
                      child: TextFormField(
                        controller: phoneController,
                        decoration: InputDecoration(
                          labelText: "Số điện thoại",
                          border: OutlineInputBorder(),
                        ),
                        keyboardType: TextInputType.phone,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Vui lòng nhập số điện thoại";
                          }
                          if (!RegExp(r'^[0-9]{7,15}$').hasMatch(value)) {
                            return "Số điện thoại không hợp lệ";
                          }
                          return null;
                        },
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 16),

                // Email
                TextFormField(
                  controller: emailController,
                  decoration: InputDecoration(
                    labelText: "Email",
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Vui lòng nhập email";
                    }
                    if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                      return "Email không hợp lệ";
                    }
                    return null;
                  },
                ),
                SizedBox(height: 20),

                // Register Button
                Center(
                  child: ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        // Hiển thị thông báo
                        Get.snackbar(
                          "Đăng ký thành công",
                          "Thông tin sẽ được gửi đến email: ${emailController.text}",
                          snackPosition: SnackPosition.BOTTOM,
                          backgroundColor: Colors.green.shade400,
                          colorText: Colors.white,
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      padding:
                          EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                      backgroundColor: Colors.blue.shade400,
                    ),
                    child: Text("Đăng ký", style: TextStyle(fontSize: 18)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
