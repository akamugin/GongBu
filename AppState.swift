//
//  AppState.swift
//  GongBu
//
//  Created by Stella Lee on 10/28/24.
//


import SwiftUI
import Combine

class AppState: ObservableObject {
    // Add any global states here if necessary
    @Published var isLoggedIn: Bool = true // Example state
}
