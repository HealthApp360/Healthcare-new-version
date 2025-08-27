import 'package:flutter/material.dart';
import 'package:healthcare_app/services/AuthServices.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 225, 238, 246),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset('assets/welcome.jpg'),
                const SizedBox(height: 50),
                const Text(
                  'Doctors at',
                  style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
                const Text(
                  'your Doorstep',
                  style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 50),

//                 Container(
//                   width: double.infinity,
//                   height: 70,
//                   //color: Colors.amber,
//                   decoration: BoxDecoration(
//                     borderRadius: BorderRadius.circular(10),
//                     gradient:const LinearGradient(
//                       colors: [
//                         const Color(0xFF3366FF),
//                         const Color(0xFF00CCFF),
//                       ],
//                       begin: const FractionalOffset(0.0, 0.0),
//                       end: const FractionalOffset(1.0, 0.0),
//                       stops: [0.0, 1.0],
//                       tileMode: TileMode.clamp,
//                     ),
//                   ),

//                   child:const Align(
//                     alignment: AlignmentGeometry.center,
//                     child: Text(
//                       'Sign Up',
//                       style: TextStyle(
//                         color: Colors.white,
//                         fontSize: 22,
//                         fontWeight: FontWeight.w400,
//                       ),
//                     ),
//                   ),
//                 ),
// SizedBox(height: 20,),

                TextFormField(
                  controller: _usernameController,
                  decoration: const InputDecoration(
                    labelText: "Username",
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.person),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Please enter username";
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                /// Password field
                TextFormField(
                  controller: _passwordController,
                  decoration: const InputDecoration(
                    labelText: "Password",
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.lock),
                  ),
                  obscureText: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Please enter password";
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 24),

                // Login Button
                // ElevatedButton(
                //   onPressed: () async {
                //     if (_formKey.currentState!.validate()) {
                //       // TODO: Call AuthService for email/password login
                //       // ScaffoldMessenger.of(context).showSnackBar(
                //       //   SnackBar(
                //       //     content: Text(
                //       //       "Username: ${_usernameController.text}, Password: ${_passwordController.text}",
                //       //     ),
                //       //   ),
                //       // );
                //       await AuthService.signInWithEmailAndPassword(
                //         context,
                //         _usernameController.text,
                //         _passwordController.text,
                //       );
                //     }
                //   },
                //   style: ElevatedButton.styleFrom(
                //     minimumSize: const Size(double.infinity, 50),
                //     shape: RoundedRectangleBorder(
                //       borderRadius: BorderRadius.circular(30),
                //     ),
                //   ),
                //   child: const Text("Login"),
                // ),
                GestureDetector(
                  onTap: () async{
                    //  await AuthService.signInWithEmailAndPassword(
                    //     context,
                    //     _usernameController.text,
                    //     _passwordController.text,
                    //   );
                    await AuthService.signInUser(context: context,email: _usernameController.text,password: _passwordController.text,useGoogle: false,role: "doctor");
                  },
                  child: Container(
                    width: double.infinity,
                    height: 70,
                    //color: Colors.amber,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.lightBlue,width: 2),
                    ),
                  
                    child:const Align(
                      alignment: AlignmentGeometry.center,
                      child: Text(
                        'Login',
                        style: TextStyle(
                          color: Colors.lightBlue,
                          fontSize: 22,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 10,),

                /// Username field
                // TextFormField(
                //   controller: _usernameController,
                //   decoration: const InputDecoration(
                //     labelText: "Username",
                //     border: OutlineInputBorder(),
                //     prefixIcon: Icon(Icons.person),
                //   ),
                //   validator: (value) {
                //     if (value == null || value.isEmpty) {
                //       return "Please enter username";
                //     }
                //     return null;
                //   },
                // ),
                // const SizedBox(height: 16),

                // /// Password field
                // TextFormField(
                //   controller: _passwordController,
                //   decoration: const InputDecoration(
                //     labelText: "Password",
                //     border: OutlineInputBorder(),
                //     prefixIcon: Icon(Icons.lock),
                //   ),
                //   obscureText: true,
                //   validator: (value) {
                //     if (value == null || value.isEmpty) {
                //       return "Please enter password";
                //     }
                //     return null;
                //   },
                // ),
                // const SizedBox(height: 24),

                /// Login Button
                // ElevatedButton(
                //   onPressed: () async {
                //     if (_formKey.currentState!.validate()) {
                //       // TODO: Call AuthService for email/password login
                //       // ScaffoldMessenger.of(context).showSnackBar(
                //       //   SnackBar(
                //       //     content: Text(
                //       //       "Username: ${_usernameController.text}, Password: ${_passwordController.text}",
                //       //     ),
                //       //   ),
                //       // );
                //       await AuthService.signInWithEmailAndPassword(
                //         context,
                //         _usernameController.text,
                //         _passwordController.text,
                //       );
                //     }
                //   },
                //   style: ElevatedButton.styleFrom(
                //     minimumSize: const Size(double.infinity, 50),
                //     shape: RoundedRectangleBorder(
                //       borderRadius: BorderRadius.circular(30),
                //     ),
                //   ),
                //   child: const Text("Login"),
                // ),
                const SizedBox(height: 30),

                /// Divider
                const Row(
                  children: const [
                    Expanded(child: Divider(thickness: 1)),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8),
                      child: Text("Login with social account",style: TextStyle(color: Colors.grey),),
                    ),
                    Expanded(child: Divider(thickness: 1)),
                  ],
                ),
                const SizedBox(height: 30),

                /// Google Sign-In
                _buildGoogleSignInButton(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildGoogleSignInButton(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: () async {
        // await AuthService.signInWithGoogle(context);
        await AuthService.signInUser(context: context,email: "",password: "",role: "user",useGoogle: true);
      },
      icon: Image.asset('assets/google_logo.png', height: 24.0),
      label: const Text('Sign in with Google'),
      style: ElevatedButton.styleFrom(
        foregroundColor: Colors.black87,
        backgroundColor: Colors.white,
        minimumSize: const Size(double.infinity, 50),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        elevation: 3,
      ),
    );
  }
}
