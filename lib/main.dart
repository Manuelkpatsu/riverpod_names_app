import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

void main() {
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Display Names App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      darkTheme: ThemeData.dark(),
      themeMode: ThemeMode.dark,
      home: const HomePage(),
    );
  }
}

const names = [
  'Alice',
  'Bob',
  'Charlie',
  'David',
  'Eve',
  'Fred',
  'Ginny',
  'Harriet',
  'Ileana',
  'Joseph',
  'Kincaid',
  'Larry'
];

final tickerProvider = StreamProvider(
  (ref) => Stream.periodic(const Duration(seconds: 1), (i) => i + 1),
);

final namesProvider = StreamProvider(
  (ref) => ref.watch(tickerProvider.future).asStream().map((count) => names.getRange(0, count)),
);

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final names = ref.watch(namesProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Display Names')),
      body: names.when(
        data: (names) {
          return ListView.builder(
            itemCount: names.length,
            itemBuilder: (ctx, index) {
              return ListTile(title: Text(names.elementAt(index)));
            },
          );
        },
        error: (error, stackTrace) => const Padding(
          padding: EdgeInsets.all(16),
          child: Text('Reached the end of the list'),
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
      ),
    );
  }
}
