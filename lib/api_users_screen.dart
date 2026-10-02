import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ApiUsersScreen extends StatefulWidget {
  const ApiUsersScreen({super.key});

  @override
  State<ApiUsersScreen> createState() => _ApiUsersScreenState();
}

class _ApiUsersScreenState extends State<ApiUsersScreen> {
  late Future<List<dynamic>> _usersFuture;

  @override
  void initState() {
    super.initState();
    _usersFuture = _fetchUsers();
  }

  Future<List<dynamic>> _fetchUsers() async {
    final response = await http
        .get(Uri.parse('https://jsonplaceholder.typicode.com/users'))
        .timeout(const Duration(seconds: 15));

    if (response.statusCode == 200) {
      return jsonDecode(response.body) as List<dynamic>;
    }

    throw Exception('Unable to load data. Status: ${response.statusCode}');
  }

  void _retry() {
    setState(() {
      _usersFuture = _fetchUsers();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('API Student Data'),
        actions: [
          IconButton(
            onPressed: _retry,
            tooltip: 'Refresh data',
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      body: FutureBuilder<List<dynamic>>(
        future: _usersFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 16),
                  Text('Loading data from REST API...'),
                ],
              ),
            );
          }

          if (snapshot.hasError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.cloud_off, color: Colors.red, size: 60),
                    const SizedBox(height: 16),
                    const Text(
                      'Unable to load API data.',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Check your internet connection and try again.',
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton.icon(
                      onPressed: _retry,
                      icon: const Icon(Icons.refresh),
                      label: const Text('Try Again'),
                    ),
                  ],
                ),
              ),
            );
          }

          final users = snapshot.data ?? [];

          if (users.isEmpty) {
            return const Center(child: Text('No data available.'));
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: users.length,
            itemBuilder: (context, index) {
              final user = users[index] as Map<String, dynamic>;
              final address = user['address'] as Map<String, dynamic>?;
              final company = user['company'] as Map<String, dynamic>?;

              return Card(
                margin: const EdgeInsets.only(bottom: 12),
                child: ListTile(
                  contentPadding: const EdgeInsets.all(16),
                  leading: CircleAvatar(
                    backgroundColor: Colors.indigo.shade100,
                    child: Text(
                      '${user['id']}',
                      style: const TextStyle(
                        color: Colors.indigo,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  title: Text(
                    '${user['name'] ?? 'Unknown'}',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Username: ${user['username'] ?? '-'}'),
                        Text('Email: ${user['email'] ?? '-'}'),
                        Text('Phone: ${user['phone'] ?? '-'}'),
                        Text('City: ${address?['city'] ?? '-'}'),
                        Text('Company: ${company?['name'] ?? '-'}'),
                      ],
                    ),
                  ),
                  isThreeLine: false,
                ),
              );
            },
          );
        },
      ),
    );
  }
}
