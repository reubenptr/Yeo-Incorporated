//
//  ContentView.swift
//  IOS Challenge
//
//  Created by Aldric on 31/8/26.
//
import SwiftUI

@main
struct ToolbarApp: App {
    var body: some Scene {
        WindowGroup {
            MainContainerView()
        }
    }
}

struct MainContainerView: View {
    // MARK: - App State Configuration
    @State private var clickCount = 0
    @State private var stepValue = 1
    
    // Feature Toggles (Manipulated by Toolbars)
    @State private var showStatsView = true
    @State private var enableDarkModeContent = false
    @State private var showSecretMessage = false
    
    // Core Interface Accent
    @State private var accentColor: Color = .blue
    
    var body: some View {
        NavigationStack {
            // MARK: - Hosted Main Content View
            MainContentView(
                clickCount: $clickCount,
                stepValue: stepValue,
                showStatsView: showStatsView,
                enableDarkModeContent: enableDarkModeContent,
                showSecretMessage: showSecretMessage,
                accentColor: accentColor
            )
            .navigationTitle("Dashboard")
            .background(enableDarkModeContent ? Color(uiColor: .secondarySystemBackground) : Color(uiColor: .systemGroupedBackground))
            
            // MARK: - Integrated App Toolbars
            
            // Primary Top Toolbar Split Group
            .toolbar {
                ToolbarItemGroup(placement: .navigationBarLeading) {
                    Button(action: {
                        withAnimation {
                            clickCount = 0
                            stepValue = 1
                        }
                    }) {
                        Label("Reset", systemImage: "trash")
                            .foregroundColor(.red)
                    }
                }
                
                ToolbarItemGroup(placement: .navigationBarTrailing) {
                    // Quick Multiplier Incrementor
                    Stepper("Multiplier", value: $stepValue, in: 1...10)
                        .labelsHidden()
                    
                    // Comprehensive Mode Toggles Menu
                    Menu {
                        Section("View Management") {
                            Toggle("Show Stats Panel", isOn: $showStatsView)
                            Toggle("Darken Content Card", isOn: $enableDarkModeContent)
                            Toggle("Reveal Secret Panel", isOn: $showSecretMessage)
                        }
                    } label: {
                        Label("Menu", systemImage: "ellipsis.circle.fill")
                            .font(.title3)
                    }
                }
            }
            
            // Contextual Bottom Utility Toolbar
            .toolbar {
                ToolbarItemGroup(placement: .bottomBar) {
                    Toggle(isOn: $showStatsView) {
                        Image(systemName: showStatsView ? "chart.bar.fill" : "chart.bar")
                    }
                    .toggleStyle(.button)
                    
                    Spacer()
                    
                    Toggle(isOn: $enableDarkModeContent) {
                        Image(systemName: enableDarkModeContent ? "moon.fill" : "sun.max")
                    }
                    .toggleStyle(.button)
                    
                    Spacer()
                    
                    Toggle(isOn: $showSecretMessage) {
                        Image(systemName: showSecretMessage ? "eye.fill" : "eye.slash")
                    }
                    .toggleStyle(.button)
                    
                    Spacer()
                    
                    Button(action: {
                        let options: [Color] = [.blue, .purple, .pink, .teal, .indigo]
                        if let nextColor = options.filter({ $0 != accentColor }).randomElement() {
                            withAnimation { accentColor = nextColor }
                        }
                    }) {
                        Image(systemName: "paintpalette.fill")
                            .foregroundColor(accentColor)
                    }
                }
            }
        }
    }
}

// MARK: - Extracted Standalone Main Content View Component
struct MainContentView: View {
    @Binding var clickCount: Int
    let stepValue: Int
    let showStatsView: Bool
    let enableDarkModeContent: Bool
    let showSecretMessage: Bool
    let accentColor: Color
    
    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                
                // 1. Interactive Core Scoreboard Panel
                VStack(spacing: 8) {
                    Text("TOTAL CLICKS")
                        .font(.caption2)
                        .fontWeight(.bold)
                        .foregroundColor(.secondary)
                        .tracking(2)
                    
                    Text("\(clickCount)")
                        .font(.system(size: 72, weight: .black, design: .rounded))
                        .foregroundColor(accentColor)
                        .contentTransition(.numericText())
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 30)
                .background(enableDarkModeContent ? Color(uiColor: .tertiarySystemBackground) : Color(uiColor: .systemBackground))
                .cornerRadius(20)
                .shadow(color: Color.black.opacity(0.06), radius: 10, x: 0, y: 4)
                
                // 2. Primary Clicker Trigger Action Button
                Button(action: {
                    withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
                        clickCount += stepValue
                    }
                }) {
                    HStack(spacing: 12) {
                        Image(systemName: "hand.tap.fill")
                            .font(.title2)
                        Text("CLICK ME (+\(stepValue))")
                            .font(.headline)
                            .fontWeight(.bold)
                    }
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 18)
                    .background(accentColor)
                    .cornerRadius(16)
                    .shadow(color: accentColor.opacity(0.3), radius: 8, x: 0, y: 4)
                }
                
                // 3. Analytics View Panel (Controlled conditionally by toolbar toggles)
                if showStatsView {
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Live App Analytics")
                            .font(.headline)
                        
                        Divider()
                        
                        HStack {
                            ProgressView(value: Double(min(clickCount, 100)), total: 100)
                                    .tint(accentColor)
                            Text("\(min(clickCount, 100))% to Goal")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                        
                        Text("Step Multiplier: Multiplies every single click action by \(stepValue).")
                            .font(.footnote)
                            .foregroundColor(.secondary)
                    }
                    .padding()
                    .background(Color(uiColor: .secondarySystemBackground))
                    .cornerRadius(16)
                }
                
                // 4. Vault Content Panel (Controlled conditionally by toolbar toggles)
                if showSecretMessage {
                    VStack(spacing: 12) {
                        Image(systemName: "lock.open.fill")
                            .font(.largeTitle)
                            .foregroundColor(.amberCustom)
                        Text("You unlocked the secret view area!")
                            .font(.callout)
                            .fontWeight(.medium)
                        Text("Toggle the view states inside your header or footer toolbars to show or hide this card panel canvas dynamically.")
                            .font(.caption)
                            .foregroundColor(.secondary)
                            .multilineTextAlignment(.center)
                    }
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.amberCustom.opacity(0.15))
                    .cornerRadius(16)
                    .overlay(
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(Color.amberCustom.opacity(0.3), lineWidth: 1)
                    )
                }
            }
            .padding()
        }
    }
}

// Color Styling Extensions
extension Color {
    static let amberCustom = Color(red: 0.96, green: 0.65, blue: 0.14)
}

// MARK: - PREVIEW CANVAS DEVELOPER SYSTEM
// This fixes the canvas preview issue and forces Xcode to display the demo device frame!
#Preview {
    MainContainerView()
}
