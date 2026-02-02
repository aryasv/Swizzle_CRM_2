import 'package:flutter/material.dart';
import 'package:swl_crm/view/companies/companies_form_page.dart';
import 'package:swl_crm/view/contacts/contacts_form_page.dart';
import 'package:swl_crm/view/splash_screen.dart';
import 'package:swl_crm/view/custom_classes/imports.dart';
import 'package:swl_crm/view/tasks/tasks_form_page.dart';


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'My App',
      theme: ThemeData(
        useMaterial3: true,
      ),
       home: const SplashScreen(),
     // home: const LoginPage(),
      // home: const NavWrapper(),
      //home: const ProductsPage(),
      //home: const NavSettings(),

       //home: const ContactsPage(),
      //home: const ContactsFormPage(),

      //home: const CompaniesPage(),
      //home: const CompaniesFormPage(),

      //home: const ProfilePage(),

      //home: const ProductsPage(),
      //home: const ProductsCreatePage(),

       // home: const NavTasks(),
      //home: const TasksFormPage(),

    );
  }
}
