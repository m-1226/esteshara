import 'package:esteshara/features/specialists/presentation/views/widgets/specialists_view_body.dart';
import 'package:flutter/material.dart';

class SpecialistsView extends StatelessWidget {
  const SpecialistsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Available Specialists'),
        actions: [
          IconButton(
            icon: const Icon(
              Icons.search,
              color: Colors.black,
            ),
            onPressed: () {
              // We'll implement search later
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                    content: Text('Search functionality coming soon')),
              );
            },
          ),
        ],
      ),
      body: SpecialistsViewBody(),
    );
  }
}
