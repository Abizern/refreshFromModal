//
//  AppState.swift
//  refreshFromModal
//
//  Created by Serge Ostrowsky on 22/05/2020.
//  Copyright © 2020 Serge Ostrowsky. All rights reserved.
//

import Foundation
import SwiftUI

class AppState: ObservableObject {
    @Published var dualRule: Bool = UserDefaults.standard.bool(forKey: kmultiRules)
    @Published var ruleSel: Int = UserDefaults.standard.integer(forKey: kruleSelection)
    @Published var wasAppStateChanged: Bool = UserDefaults.standard.bool(forKey: kappStateChanged)
    
    
    func updateValues() {
        self.dualRule = UserDefaults.standard.bool(forKey: kmultiRules)
        self.ruleSel = UserDefaults.standard.integer(forKey: kruleSelection)
        
        UserDefaults.standard.set(true, forKey: kappStateChanged)
        self.wasAppStateChanged = UserDefaults.standard.bool(forKey: kappStateChanged)
        
        NotificationCenter.default.post(name: NSNotification.Name("statusChange"), object: nil)
    }
    
}
