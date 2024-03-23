import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:technopartner/ui/home.dart';
import 'package:technopartner/ui/menu.dart';

class LoginScreen extends StatelessWidget {
  Future<void> loginAndAccessAPI(BuildContext context) async {
    final url = Uri.parse('https://soal.staging.id/oauth/token');
    try {
      final response = await http.post(
        url,
        body: {
          'grant_type': 'password',
          'client_secret': '0a40f69db4e5fd2f4ac65a090f31b823',
          'client_id': 'e78869f77986684a',
          'username': 'support@technopartner.id',
          'password': '1234567',
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);
        final tokenType = responseData['token_type'];
        final accessToken = responseData['access_token'];

        // Menggunakan token untuk mengakses API Home
        await accessHomeAPI(context, tokenType, accessToken);

        // Menggunakan token untuk mengakses API Menu
        await accessMenuAPI(context, tokenType, accessToken);
      } else {
        // Menampilkan pesan kesalahan jika login gagal
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Error'),
              content: Text('Failed to login.'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('OK'),
                ),
              ],
            );
          },
        );
      }
    } catch (e) {
      print('Exception: $e');
    }
  }

  Future<void> accessHomeAPI(
      BuildContext context, String tokenType, String accessToken) async {
    final url = Uri.parse('https://soal.staging.id/api/home');
    try {
      final response = await http.get(
        url,
        headers: {
          'Authorization': '$tokenType $accessToken',
        },
      );

      if (response.statusCode == 200) {
        // Jika sukses, arahkan ke halaman Home
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => HomeScreen(accessToken: accessToken)),
        );
      } else {
        throw Exception('Failed to access Home API');
      }
    } catch (e) {
      print('Exception: $e');
    }
  }

  Future<void> accessMenuAPI(
      BuildContext context, String tokenType, String accessToken) async {
    final url = Uri.parse('https://soal.staging.id/api/menu');
    try {
      final response = await http.get(
        url,
        headers: {
          'Authorization': '$tokenType $accessToken',
        },
      );

      if (response.statusCode == 200) {
        // Jika sukses, arahkan ke halaman Menu
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => MenuScreen(accessToken: accessToken)),
        );
      } else {
        throw Exception('Failed to access Menu API');
      }
    } catch (e) {
      print('Exception: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Image.asset(
                'assets/gambar/logo.png',
                height: 120.0,
              ),
              SizedBox(height: 80.0),
              Center(
                child: Text(
                  'Email',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.normal,
                    color: Colors.grey,
                  ),
                ),
              ),
              SizedBox(height: 20),
              Container(
                margin: EdgeInsets.only(bottom: 20, right: 25, left: 25),
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.10),
                      spreadRadius: 1,
                      blurRadius: 6,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: TextField(
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15.0),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 10),
              Center(
                child: Text(
                  'Password',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.normal,
                    color: Colors.grey,
                  ),
                ),
              ),
              SizedBox(height: 20),
              Container(
                margin: EdgeInsets.only(bottom: 40.0, right: 25, left: 25),
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.10),
                      spreadRadius: 1,
                      blurRadius: 6,
                      offset: Offset(0, 3),
                    ),
                  ],
                ),
                child: TextField(
                  obscureText: true,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15.0),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 50),
                child: Material(
                  elevation: 4.0,
                  borderRadius: BorderRadius.circular(20),
                  shadowColor: Colors.black.withOpacity(0.25),
                  child: TextButton(
                    style: TextButton.styleFrom(
                      backgroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      padding: EdgeInsets.symmetric(vertical: 15.0),
                    ),
                    onPressed: () {
                      loginAndAccessAPI(context);
                    },
                    child: Text(
                      "Login",
                      style: TextStyle(
                        fontSize: 25,
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
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
