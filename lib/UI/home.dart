import 'package:flutter/material.dart';
import '../API/fetch_data.dart';
import '../Data/user_model.dart';
import '../Util/dbHelp.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
 late Future<List<User>> _futureUser;

  @override
  void initState() {
    super.initState();
    // 1) Initialize to an empty or existing DB query:
    _futureUser = DatabaseHelper().getUsers();                // :contentReference[oaicite:6]{index=6}
    // 2) Fetch from API & store, then refresh the future:
    fetchData()
        .fetchAndSave()
        .then((_) => setState(() {
      _futureUser = DatabaseHelper().getUsers();            // :contentReference[oaicite:7]{index=7}
    }));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Interview Demo', style: TextStyle(
          color: Colors.cyanAccent
        ),),
        backgroundColor: Colors.black54,
      ),
      backgroundColor: Colors.white,
      body: SafeArea(child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            const SizedBox(height: 20,),
            const Row(
              children: [
                Expanded(child: Text('Demo showcaseing the different requirements of the interview'))
              ],
            ),
            const SizedBox(height: 20,),
            FutureBuilder<List<User>>(
              future: _futureUser,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator();
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Text('No users found.');
                } else {
                  final users = snapshot.data!;
                  return Expanded(
                    child: ListView.builder(
                      itemCount: users.length,
                      itemBuilder: (_, i) {
                        final user = users[i];
                        return ListTile(
                          title: Text(user.fullName),
                          subtitle: Text(user.description ?? 'No description'),
                          leading: CircleAvatar(
                            backgroundImage: NetworkImage(user.avatarUrl),
                          ),
                          trailing: IconButton(
                            icon: const Icon(Icons.delete,
                            color: Colors.red,),
                            onPressed: () async {
                              await DatabaseHelper().deleteUser(user.id!);
                              setState((){
                                _futureUser = DatabaseHelper().getUsers();
                              });
                            },
                          ),
                        );
                      },
                    ),
                  );
                }
              },
            )
          ],
        ),
      )),
    );

  }
}
