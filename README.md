# UalaCities

A Swift iOS application developed as part of the Ualá mobile challenge. The app fetches a list of approximately 200,000 cities from a remote JSON source, allows users to search through them using prefix matching, view them on a map, and save favorites for quick access.

## Architecture

* **Clean Architecture**: I organized the code in layers, keeping business logic separate from UI and data handling
* **MVVM**: Views are powered by ViewModels that manage the data and logic behind each screen
* **Repository Pattern**: Interface that abstracts data sources
* **Use Case Pattern**: Each specific action the app can perform has its own dedicated class
* **Dependency Injection**: Components receive their dependencies from outside rather than creating them, making testing easier

## Key Features & Technical Details

* **Fast prefix search** with real-time filtering using SwiftUI and Combine
* **Responsive layout** adapting between portrait and landscape orientations
* **Favorites management** with UserDefaults persistence between sessions
* **Interactive map integration** using MapKit for location display

## Search Solution

I implemented a **Trie data structure** (prefix tree) to solve the city search challenge:

- **What is a Trie?** A tree where each path from root to node represents a word prefix
- **Why use it?** Extremely fast prefix searches - doesn't need to scan the entire city list
- **How it works:**
  1. We build the tree once when the app loads
  2. Each character in a city name becomes a node in the tree
  3. All cities that share a prefix share the same path in the tree
  4. When searching, we just follow the path for the prefix and get all matching cities

For example, with cities "New York", "New Orleans", and "Newark":
- They all share the path N→E→W
- "York", "Orleans" and "ark" branch from there
- Typing "New" immediately finds all three cities by following just 3 nodes

This approach is much faster than filtering the entire list of 200,000 cities each time the user types a character.

## Implementation Decisions

* **Data Loading Strategy**: Loading cities during splash screen provides instant search after initial load
* **Sorting Logic**: Sort the cities prioritizing alphabetical characters before special characters
* **Pagination & Background Processing**: For responsive UI with the large dataset

## Getting Started

### Requirements
- iOS 18.1+
- Xcode 16.1+
- Swift 5.0+

### Installation
1. Clone the repository
   ```bash
   git clone https://github.com/MattSolutions/UalaCities.git
   ```

2. Open the project in Xcode
   ```bash
   cd UalaCities
   open UalaCities.xcodeproj
   ```

3. Build and run
   - Select your target device or simulator
   - Press Cmd+R or click the Run button
