//
//  TestGrid.swift
//  PushupCounter
//
//  Created by CC Laan on 11/26/23.
//

import SwiftUI


struct ResponsiveGridView: View {
    
    // This will determine if the device is in landscape mode
    @Environment(\.horizontalSizeClass) var horizontalSizeClass

    // Grid layouts for different orientations
    private var portraitGrid: [GridItem] {
        Array(repeating: .init(.flexible()), count: 1)
    }

    private var landscapeGrid: [GridItem] {
        Array(repeating: .init(.flexible()), count: 2)
    }

    var body: some View {
        GeometryReader { reader in
            
            Group {
                if reader.size.width > reader.size.height {
                    //landscapeView
                    landscapeView(width: reader.size.width, height: reader.size.height)
                } else {
                    portraitView
                }
            }
        }
    }
    
    
    //@ViewBuilder var landscapeView : some View {
    @ViewBuilder func landscapeView(width: CGFloat, height: CGFloat) -> some View {

        VStack {
            HStack {
                Rectangle()
                    .fill(Color.blue)
                    .frame(height: height * 0.5 )
                
                Rectangle()
                    .fill(Color.red)
                    .frame(height: height * 0.5 )
            }
        }.edgesIgnoringSafeArea(.horizontal)
    
        
    }
    
    /*
    @ViewBuilder var countView : some View {
        
        
        HStack(spacing: 100) {
            Button(action: {
                if counter > 0 {
                    counter -= 10
                }
            }) {
                Image(systemName: "minus.circle.fill")
                    .resizable()
                    .frame(width: 100, height: 100)
            }
            .foregroundColor(.green)
            
            Button(action: {
                counter += 10
            }) {
                Image(systemName: "plus.circle.fill")
                    .resizable()
                    .frame(width: 100, height: 100)
            }
            .foregroundColor(.green)
            
        }
        
        .font(.system(size: 100))
        .padding()
        
    }
    */
    
    @ViewBuilder var portraitView : some View {
        
        VStack {
            //HStack {
                Rectangle()
                    .fill(Color.blue)
                    .frame(height: 200)
                
                Rectangle()
                    .fill(Color.red)
                    .frame(height: 200)
            //}
        }
        
    }

    var gridContent: some View {
        ForEach(1..<5) { index in
            // Conditionally hide some views if needed
            if shouldShowView(index: index) {
                Rectangle()
                    .fill(Color.random)
                    .frame(height: 200)
            }
        }
    }

    // A simple function to decide if a view should be shown
    func shouldShowView(index: Int) -> Bool {
        // Replace this with your own condition
        return index % 2 == 0
    }
}

extension Color {
    static var random: Color {
        Color(red: Double.random(in: 0...1), green: Double.random(in: 0...1), blue: Double.random(in: 0...1))
    }
    
    
}

#Preview {
    ResponsiveGridView()
}


//struct ResponsiveGridView_Previews: PreviewProvider {
//    static var previews: some View {
//        ResponsiveGridView()
//            .previewLayout(.sizeThatFits)
//    }
//}

// MARK: -

struct Card: Identifiable {
    let id = UUID()
    let title: String
}

struct CardView: View {
    let title: String
    var body: some View {
        VStack {
            RoundedRectangle(cornerRadius: 12).foregroundColor(.random)
            Text(title)
                .font(.title2)
        }
        
    }
}



struct MockStore {
    static var cards = [
        Card(title: "Italy"),
        Card(title: "England"),
        Card(title: "Portugal"),
        Card(title: "Belgium"),
        Card(title: "Germany"),
        Card(title: "Mexico"),
        Card(title: "Canada"),
        Card(title: "Italy"),
        Card(title: "England"),
        Card(title: "Portugal"),
        Card(title: "Belgium"),
        Card(title: "Germany"),
        Card(title: "Mexico"),
        Card(title: "Canada"),
        Card(title: "England"),
        Card(title: "Portugal"),
        Card(title: "Belgium"),
        Card(title: "Germany"),
        Card(title: "Mexico"),
        Card(title: "Canada"),
    ]
}

struct ContentView2: View {
    // 1. Number of items will be display in row
    var columns: [GridItem] = [
        GridItem(.flexible(minimum: 140)),
        GridItem(.flexible()),
        GridItem(.flexible()),
    ]
    // 2. Fixed height of card
    let height: CGFloat = 150
    // 3. Get mock cards data
    let cards: [Card] = MockStore.cards
    
    var body: some View {
        ScrollView {
            // 4. Populate into grid
            LazyVGrid(columns: columns, spacing: 16) {
                ForEach(cards) { card in
                    CardView(title: card.title)
                        .frame(height: height)
                }
            }
            .padding()
        }
    }
}



struct ContentView3: View {
    
    // 1. Number of items will be display in row
    var columns: [GridItem] = [
        GridItem(.flexible(minimum: 400)),
        GridItem(.flexible(minimum: 280)),
        //GridItem(.flexible()),
        //GridItem(.flexible()),
    ]
    
    // 2. Fixed height of card
    
    let height: CGFloat = 200
    
    // 3. Get mock cards data
    let cards: [Card] = MockStore.cards
    
    var body: some View {
        ScrollView {
            // 4. Populate into grid
            LazyVGrid(columns: columns, spacing: 0) {
                ForEach(cards) { card in
                    CardView(title: card.title)
                        .frame(height: height)
                }
            }
            //.padding()
        }
    }
}

//#Preview {
//    ContentView3()
//}

struct TestGrid: View {
    var body: some View {
        Text("Hello, World!")
    }
}

//#Preview {
//    TestGrid()
//}
