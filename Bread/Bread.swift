import SwiftUI

struct UserProfile {
    var firstName: String
    var middleName: String?
    var lastName: String
    
    var fullTitle: String {
        let middle = middleName ?? "The Useless"
        return "\(firstName) \(middle) \(lastName)"
    }
}

struct SettingsView: View {
    @State private var profile = UserProfile(firstName: "Master", middleName: nil, lastName: "Inspector")
    @State private var enableSelfDestruct = false
    @State private var debugLogs: [String] = []

    var body: some View {
        Form {
            Section(header: Text("Inspector Profile")) {
                TextField("First Name", text: $profile.firstName)
                TextField("Last Name", text: $profile.lastName)
                
                Text("Computed Title: \(profile.fullTitle)")
                    .foregroundColor(.blue)
                    .font(.footnote)
            }

            Section(header: Text("Useless Controls")) {
                Toggle("Enable Existential Self-Destruct", isOn: $enableSelfDestruct)
                
                if enableSelfDestruct {
                    Text("⚠️ Warning: App will do absolutely nothing when toggled.")
                        .foregroundColor(.red)
                        .font(.caption)
                } else {
                    Text("App status: Perfectly safe and boring.")
                        .foregroundColor(.green)
                        .font(.caption)
                }
            }

            Section(header: Text("Run Diagnostic Loop")) {
                Button("Generate Fake Logs") {
                    debugLogs.removeAll()
                    for index in 1...3 {
                        debugLogs.append("Checked virtual bread crumb #\(index)... OK.")
                    }
                }
                
                ForEach(debugLogs, id: \.self) { log in
                    Text(log)
                        .font(.system(.body, design: .monospaced))
                }
            }
        }
        .navigationTitle("Dread & Settings")
    }
}

#Preview {
    SettingsView()
}
