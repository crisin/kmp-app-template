import SwiftUI
import shared

@main
struct KmpAppApp: App {

    init() {
        // Initialize Koin DI from the shared Kotlin module.
        // Kotlin/Native exports top-level function initKoinIos() as doInitKoinIos()
        // (the "do" prefix avoids clashing with Obj-C init* selector naming).
        KoinIosHelperKt.doInitKoinIos()
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
