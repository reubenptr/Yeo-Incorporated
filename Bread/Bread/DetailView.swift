import SwiftUI

struct DetailView: View {
    @Binding var selectedBread: BreadItem
    @State private var rotationAngle: Double = 0.0

    var body: some View {
        VStack(spacing: 20) {
            Spacer()
            
            Rectangle()
                .fill(selectedBread.isStale ? Color.brown : Color.yellow)
                .frame(width: 150, height: 150)
                .cornerRadius(25)
                .rotationEffect(.degrees(rotationAngle))
                .shadow(color: .black.opacity(0.3), radius: 10, x: 0, y: 5)
                .overlay(
                    Text("🍞")
                        .font(.system(size: 70))
                )
            
            Text(selectedBread.name)
                .font(.largeTitle)
                .fontWeight(.bold)
                .multilineTextAlignment(.center)
                .padding(.horizontal)

            Stepper("Crunch Level: \(selectedBread.crunchLevel)", value: $selectedBread.crunchLevel, in: 1...10)
                .padding()
                .background(Color.gray.opacity(0.1))
                .cornerRadius(12)
                .padding(.horizontal)

            Toggle("Is this bread cursed/stale?", isOn: $selectedBread.isStale)
                .padding()
                .background(Color.gray.opacity(0.1))
                .cornerRadius(12)
                .padding(.horizontal)

            Button("Spin the Bread 360°") {
                withAnimation {
                    rotationAngle += 360
                }
            }
            .padding()
            .background(Color.blue)
            .foregroundColor(.white)
            .cornerRadius(10)

            Spacer()
        }
        .navigationTitle("Inspect Bread")
    }
}

#Preview {
    DetailView(selectedBread: .constant(BreadItem(name: "Sample Bread", crunchLevel: 4, isStale: false)))
}
