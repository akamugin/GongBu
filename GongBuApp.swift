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
    @State private var navigateToSelection = false  // Step 1: Create a State variable

    var body: some Scene {
        WindowGroup {
            NavigationView {
                ContentView(navigateToSelection: $navigateToSelection)  // Step 2: Pass the binding to ContentView
            }
        }
    }
}

