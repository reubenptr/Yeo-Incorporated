import SwiftUI

struct BreadItem: Identifiable {
    let id = UUID()
    var name: String
    var crunchLevel: Int
    var isStale: Bool
    
    func roastBread() -> String {
        return "\(name) is currently sitting at crunch level \(crunchLevel). Very crispy!"
    }
}

struct ContentView: View {
    @State private var breadInventory = [
        BreadItem(name: "Sourdough of Despair", crunchLevel: 5, isStale: false),
        BreadItem(name: "Bagel of Quantum Uncertainty", crunchLevel: 2, isStale: true),
        BreadItem(name: "Toast of Absolute Cinema", crunchLevel: 9, isStale: false)
    ]
    @State private var globalSillinessMeter: Double = 42.0

    var body: some View {
        TabView {
            NavigationStack {
                List {
                    Section {
                        HStack {
                            Circle()
                                .fill(Color.orange)
                                .frame(width: 40, height: 40)
                                .shadow(color: .black.opacity(0.4), radius: 3, x: 0, y: 2)
                            
                            VStack(alignment: .leading) {
                                Text("Inspector Dashboard")
                                    .font(.headline)
                                    .fontWeight(.bold)
                                Text("Silliness Quotient: \(Int(globalSillinessMeter))%")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                            Spacer()
                        }
                    }
                    
                    Section(header: Text("Certified Bread Inventory")) {
                        ForEach($breadInventory) { $bread in
                            NavigationLink(destination: DetailView(selectedBread: $bread)) {
                                HStack {
                                    Text(bread.name)
                                        .italic()
                                    Spacer()
                                    Text(bread.isStale ? "🤢 Stale" : "✨ Fresh")
                                        .font(.caption)
                                        .padding(6)
                                        .background(bread.isStale ? Color.red.opacity(0.2) : Color.green.opacity(0.2))
                                        .cornerRadius(8)
                                }
                            }
                            .contextMenu {
                                Button(action: {
                                    bread.crunchLevel += 1
                                }) {
                                    Label("Increase Crunch", systemImage: "flame")
                                }
                                Button(role: .destructive, action: {
                                    breadInventory.removeAll { $0.id == bread.id }
                                }) {
                                    Label("Vaporize Bread", systemImage: "trash")
                                }
                            }
                        }
                    }
                }
                .navigationTitle("Bread Central")
                .toolbar {
                    ToolbarItem(placement: .automatic) {
                        Button("Panic") {
                            globalSillinessMeter += 10
                        }
                    }
                    ToolbarItem(placement: .automatic) {
                        Button {
                            let newBread = BreadItem(name: "Mystery Loaf #\(breadInventory.count + 1)", crunchLevel: 3, isStale: false)
                            breadInventory.append(newBread)
                        } label: {
                            Image(systemName: "plus.circle.fill")
                        }
                    }
                }
            }
            .tabItem {
                Label("Inspect", systemImage: "takeoutbag.and.cup.and.straw")
            }
            
            NavigationStack {
                SettingsView()
            }
            .tabItem {
                Label("Dread", systemImage: "gearshape.fill")
            }
        }
    }
}

#Preview {
    ContentView()
}
