//
//  PulseApp.swift
//  Pulse
//
//  Created by Kishan Sadhwani on 01/08/26.
//

import SwiftUI

@main
struct PulseApp: App {
    @StateObject private var appCoordinator = AppCoordinator()
    
    var body: some Scene {
        WindowGroup {
            appCoordinator.start()
        }
    }
}
