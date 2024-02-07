import SwiftUI
import FirebaseFirestore


@main
struct icebreaker_russell_sp24App: App {
    FirebaseApp.configure()
    
    init(){
        let providerFactory = AppCheckDebugProviderFactory()
        AppCheck.setAppCheckProviderFactory(providerFactory)
        
        FirbaseApp.configure()
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
