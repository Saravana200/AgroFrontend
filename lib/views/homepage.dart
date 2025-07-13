import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:kang/widgets/slider.dart';

import '../router.dart';

@RoutePage()
class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context)
  {
    final theme = Theme.of(context);
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 150,
        backgroundColor: theme.colorScheme.surface,
        leadingWidth: 100,
        leading: Padding(
          padding: const EdgeInsets.symmetric(vertical: .0),
          child: SizedBox(
            width: 50, // Set your desired width for the image
            height: 30, // Set your desired height for the image
            child: Image.asset(
              "assets/agrifusion.jpg",
              fit: BoxFit.fill,
            ),
          ),
        ),
        title: Text(
          'Good Morning',
          style: theme.textTheme.headlineLarge,
        ),
        centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: GestureDetector(
              onTap: () {
                // Navigate to ProfileRoute
                context.router.push(ProfileRoute());
              },
              child: Icon(
                Icons.person_2_outlined,
                size: 32,
              ),
            ),
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 34),
                height: size.height * 0.18,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  color: theme.colorScheme.outlineVariant,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SliderBar(
                      theme: theme,
                      value: 23,
                      minValue: 0, // example minValue
                      maxValue: 100, // example maxValue
                      currentValue:
                          23, // make sure this is between minValue and maxValue
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.cyclone,
                          color: theme.colorScheme.onPrimaryContainer,
                          size: 25,
                        ),
                        Text(
                          "2.57 m/s",
                          style: theme.textTheme.bodyLarge,
                        ),
                      ],
                    ),
                    SliderBar(
                      theme: theme,
                      value: 50,
                      minValue: 0, // example minValue
                      maxValue: 100, // example maxValue
                      currentValue:
                          50, // make sure this is between minValue and maxValue
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 40),
            Card(
              elevation: 5.0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              child: Container(
                width: 300,
                padding: const EdgeInsets.all(20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const ListTile(
                      leading: CircleAvatar(child: Text('G')),
                      title: Text('Soil'),
                      trailing: Icon(Icons.more_vert),
                    ),
                    const SizedBox(height: 10),
                    Image.network(
                      'https://i.natgeofe.com/k/f466cabf-659a-4440-b221-e7c1d80af6f5/greenland-ice_16x9.jpg?w=1200', // Replace with your image URL
                      fit: BoxFit.fill,
                      width: 250,
                      height: 150,
                    ),
                    const SizedBox(height: 10),
                    const Text('Glaciers'),
                    const Text('Greenland'),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
