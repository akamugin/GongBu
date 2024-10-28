// GongBu/GongBuApp.swift
import SwiftUI
import FirebaseCore

// AppDelegate to handle Firebase initialization
class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        // Initialize Firebase
        FirebaseApp.configure()
        return true
    }
}

@main
struct GongBuApp: App {
    // Register the AppDelegate for Firebase setup
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
    @StateObject private var appState = AppState()  // Initialize AppState as a StateObject

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(appState)  // Inject AppState into the environment
        }
    }
}
