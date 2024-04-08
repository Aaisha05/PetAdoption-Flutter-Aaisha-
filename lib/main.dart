import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:confetti/confetti.dart';

void main() {
  runApp(PetAdoptionApp());
}

class Pet {
  final String name;
  final int age;
  final double price;
  final String imagePath; 
  bool isAdopted;

  Pet({
    required this.name,
    required this.age,
    required this.price,
    required this.imagePath,
    this.isAdopted = false,
  });
}

class PetAdoptionApp extends StatelessWidget {
  final List<Pet> adoptedPets = [];

  @override
  Widget build(BuildContext context) {
    return PetAdoptionAppState(
      adoptedPets: adoptedPets,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData.light().copyWith(
          appBarTheme: AppBarTheme(
            backgroundColor: Colors.white,
            elevation: 0,
            iconTheme: IconThemeData(color: Colors.black),
          ),
        ),
        darkTheme: ThemeData.dark().copyWith(
          appBarTheme: AppBarTheme(
            backgroundColor: Colors.black,
            elevation: 0,
            iconTheme: IconThemeData(color: Colors.white),
          ),
          primaryTextTheme: TextTheme(
            headline6: TextStyle(color: Colors.white),
          ),
        ),
        home: HomePage(),
      ),
    );
  }
}

class PetAdoptionAppState extends InheritedWidget {
  final List<Pet> adoptedPets;

  PetAdoptionAppState({
    required Widget child,
    required this.adoptedPets,
  }) : super(child: child);

  static PetAdoptionAppState of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<PetAdoptionAppState>()!;
  }

  void adoptPet(Pet pet) {
    adoptedPets.add(pet);
  }

  @override
  bool updateShouldNotify(PetAdoptionAppState oldWidget) {
    return adoptedPets != oldWidget.adoptedPets;
  }
}

class HomePage extends StatefulWidget {
  final List<Pet> pets = [
    Pet(
      name: 'Fluffy',
      age: 2,
      price: 100.0,
      imagePath: 'assets/images/one.jpg',
    ),
    Pet(
      name: 'Buddy',
      age: 3,
      price: 150.0,
     imagePath: 'assets/images/two.jpg',
    ),
    Pet(
      name: 'Max',
      age: 4,
      price: 120.0,
      imagePath: 'assets/images/three.jpg',
    ),
    Pet(
      name: 'Bob',
      age: 41,
      price: 20.0,
      imagePath: 'assets/images/four.jpg',
    ),
    Pet(
      name: 'Rock',
      age: 4,
      price: 20.0,
      imagePath: 'assets/images/six.jpg',
    ),
    Pet(
      name: 'Brown',
      age: 491,
      price: 20.0,
      imagePath: 'assets/images/seven.jpg',
    ),
    Pet(
      name: 'Aren',
      age: 491,
      price: 20.0,
      imagePath: 'assets/images/nine.jpg',
    ),
    Pet(
      name: 'Justin',
      age: 491,
      price: 20.0,
      imagePath: 'assets/images/one.jpg',
    ),
    Pet(
      name: 'Blake',
      age: 491,
      price: 20.0,
      imagePath: 'assets/images/four.jpg',
    ),
    Pet(
      name: 'Robin',
      age: 491,
      price: 20.0,
      imagePath: 'assets/images/three.jpg',
    ),
    Pet(
      name: 'Brown',
      age: 491,
      price: 20.0,
      imagePath: 'assets/images/two.jpg',
    ),
  ];

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int pageSize = 6;
  int currentPage = 0;
  int selectedCardIndex = -1; // Track the selected card index
  List<Pet> filteredPets = [];
  bool isDarkTheme = false;
  late TextEditingController _searchController;

  @override
  void initState() {
    super.initState();
    filteredPets = widget.pets;
    _loadPets();
    _searchController = TextEditingController();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _loadPets() {
    setState(() {
      filteredPets =
          widget.pets.skip(currentPage * pageSize).take(pageSize).toList();
    });
  }

  void _filterPets(String query) {
    List<Pet> filtered = widget.pets
        .where((pet) => pet.name.toLowerCase().contains(query.toLowerCase()))
        .toList();
    setState(() {
      filteredPets = filtered;
      if (filtered.length != filteredPets.length) {
        currentPage = 0;
      }
      _loadPets();
    });
    // Navigate to details page if only one pet is found in the search
    if (filtered.length == 1) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => DetailsPage(pet: filtered.first),
        ),
      );
    }
  }

  void _nextPage() {
    setState(() {
      currentPage++;
      _loadPets();
    });
  }

  void _previousPage() {
    setState(() {
      currentPage--;
      _loadPets();
    });
  }

  void _toggleTheme() {
    setState(() {
      isDarkTheme = !isDarkTheme;
    });
  }

  void _handleSubmitted(String value) {
    _filterPets(value);
  }

  void _navigateToHistoryPage() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => History()),
    );
  }

  void _onCardTapped(int index) {
    setState(() {
      selectedCardIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: isDarkTheme ? ThemeData.dark() : ThemeData.light(),
      home: Scaffold(
        appBar: AppBar(
          title: Text(
            'Pet Adoption',
            style: TextStyle(
              color: isDarkTheme ? Colors.white : Colors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
          actions: [
            IconButton(
              onPressed: _toggleTheme,
              icon: Icon(isDarkTheme ? Icons.light_mode : Icons.dark_mode),
            ),
            IconButton(
              onPressed: _navigateToHistoryPage,
              icon: Icon(Icons.history),
            ),
          ],
        ),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: _searchController,
                onChanged: _filterPets,
                onSubmitted: _handleSubmitted,
                decoration: InputDecoration(
                  hintText: 'Search by Name',
                  prefixIcon: Icon(Icons.search),
                ),
              ),
            ),
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                padding: EdgeInsets.all(8.0),
                mainAxisSpacing: 8.0,
                crossAxisSpacing: 8.0,
                children: List.generate(filteredPets.length, (index) {
                  return GestureDetector(
                    onTap: () {
                      _onCardTapped(index); // Handle card tap
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              DetailsPage(pet: filteredPets[index]),
                        ),
                      );
                    },
                    child: Card(
                      elevation: 2,
                      color: selectedCardIndex == index ? Colors.grey[400] : null, // Set background color based on selection
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Expanded(
                            child: ClipRRect(
                              borderRadius: BorderRadius.vertical(
                                  top: Radius.circular(15.0)),
                              child: Image.asset(
                                filteredPets[index].imagePath,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              filteredPets[index].name,
                              style: TextStyle(
                                fontSize: 16.0,
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                if (currentPage > 0)
                  ElevatedButton(
                    onPressed: _previousPage,
                    child: Text('Previous'),
                  ),
                Text(
                  'Page ${currentPage + 1} of ${(widget.pets.length / pageSize).ceil()}',
                ),
                if ((currentPage + 1) * pageSize < widget.pets.length)
                  ElevatedButton(
                    onPressed: _nextPage,
                    child: Text('Next'),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}




class DetailsPage extends StatefulWidget {
  final Pet pet;

  DetailsPage({required this.pet});

  @override
  _DetailsPageState createState() => _DetailsPageState();
}

class _DetailsPageState extends State<DetailsPage> {
  bool isAdopted = false;
  bool isCardSelected = false;

  @override
  void initState() {
    super.initState();
    isAdopted = widget.pet.isAdopted;
  }

  @override
  Widget build(BuildContext context) {
    final adoptedPets = PetAdoptionAppState.of(context).adoptedPets;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Pet Details',
          style: TextStyle(
            color: Theme.of(context).appBarTheme.iconTheme?.color,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: PhotoView(
              imageProvider: AssetImage(widget.pet.imagePath),
              minScale: PhotoViewComputedScale.contained * 0.8,
              maxScale: PhotoViewComputedScale.covered * 2.5,
              backgroundDecoration: BoxDecoration(color: Colors.black),
              initialScale: PhotoViewComputedScale.contained,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.pet.name,
                  style: TextStyle(
                    fontSize: 24.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 8.0),
                Text(
                  'Age: ${widget.pet.age.toString()}',
                  style: TextStyle(fontSize: 18.0),
                ),
                SizedBox(height: 8.0),
                Text(
                  'Price: \$${widget.pet.price.toString()}',
                  style: TextStyle(fontSize: 18.0),
                ),
                SizedBox(height: 16.0),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      isCardSelected = !isCardSelected;
                      if (isAdopted) {
                        // If already adopted, unadopt
                        adoptedPets.remove(widget.pet);
                        widget.pet.isAdopted = false;
                        isAdopted = false;
                      } else {
                        // If not adopted, adopt
                        adoptedPets.add(widget.pet);
                        widget.pet.isAdopted = true;
                        isAdopted = true;
                        _showAdoptionConfirmation(context, widget.pet.name);
                      }
                    });
                  },
                  child: Text(isAdopted ? 'Already adopted' : 'Adopt Me'),
                ),
              ],
            ),
          ),
        ],
      ),
      backgroundColor: isCardSelected ? Colors.grey[600] : null,
    );
  }

  void _showAdoptionConfirmation(BuildContext context, String petName) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('You have adopted $petName'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Close'),
            ),
          ],
          content: ConfettiWidget(
            confettiController: ConfettiController(duration: const Duration(seconds: 1)),
            blastDirectionality: BlastDirectionality.explosive,
            shouldLoop: false,
            numberOfParticles: 20,
            gravity: 0.2,
            colors: const [
              Colors.green,
              Colors.blue,
              Colors.pink,
              Colors.orange,
              Colors.purple,
            ],
          ),
        );
      },
    );
  }
}


class History extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final adoptedPets =
        PetAdoptionAppState.of(context).adoptedPets.toSet().toList();

    return Scaffold(
      appBar: AppBar(
        title: Text('Adoption History'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Adopted Pets',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10),
            Expanded(
              child: ListView.builder(
                itemCount: adoptedPets.length,
                itemBuilder: (context, index) {
                  final pet = adoptedPets[index];
                  return Card(
                    elevation: 2,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.asset(
                              pet.imagePath,
                              width: 80,
                              height: 80,
                              fit: BoxFit.cover,
                            ),
                          ),
                          SizedBox(width: 10),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  pet.name,
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(height: 4),
                                Text(
                                  'Age: ${pet.age}',
                                  style: TextStyle(fontSize: 16),
                                ),
                                SizedBox(height: 4),
                                Text(
                                  'Price: \$${pet.price.toStringAsFixed(2)}',
                                  style: TextStyle(fontSize: 16),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

