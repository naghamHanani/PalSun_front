import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'screens/home.dart';
// void main() {
//   runApp(const MyApp());
// }

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

 final TextEditingController _emailController = TextEditingController();
 final TextEditingController _passwordController = TextEditingController();
 String _email = '';
 String _password = '';

 String res=" test";


  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      
      home: Builder(
      builder: (context) => Scaffold(
        appBar: AppBar(title: const Text("Login",style:TextStyle(color:Colors.white),),backgroundColor: Colors.blue,),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
             mainAxisAlignment: MainAxisAlignment.center,
            children:<Widget> [
              TextField( 
              controller: _emailController,
              decoration: const InputDecoration(
                labelText: 'Email',
                border: OutlineInputBorder(),
              ),),
              const SizedBox(height: 20),
              TextField(
              controller: _passwordController,
              obscureText: true, // To hide the password text
              decoration: const InputDecoration(
                labelText: 'Password',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 30),
             SizedBox(
              width: 120,height: 50,
              child: ElevatedButton(
                onPressed: () async {

                        setState(() {
      _email = _emailController.text;
       _password = _passwordController.text;
      });

    if (_email.isNotEmpty && _password.isNotEmpty) {
      try{
        print('Email: $_email, Password: $_password');
        final response = await http.post(Uri.parse('http://10.0.2.2:3000/loginTest'),
        body: {
        "email": _email,
        "password": _password});

        print('Email: $_email, Password: $_password');
        ('Response status: ${response.statusCode}');
        print('Response body: ${response.body}');

        // Decode the JSON response
        final Map<String, dynamic> data = jsonDecode(response.body);

        // Access the "message" field
        String res;
        if (data['success'] == true) {
        // If the request was successful, get the "message" field
        res = data['message'].toString();
        Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => HomePage()),
          );
        } else {
          res = "Login failed: ${data['message']}";
        }

          // Update the UI
        setState(() {
         this.res = res;
        });
     
      }
      catch(e){
       res='Error connecting to server: $e';
      }
    }else {
      res='Please fill in all fields';
    }


                },
                child: const Text('Enter',style:TextStyle(color:Colors.blue,fontSize: 20)),
              )
            ),
            const SizedBox(height: 30),
            Text(res,style: TextStyle(color: Colors.red,backgroundColor: Colors.yellow),),
            ],
          ),
        )
      ),
      )
    );
  }
}


 
