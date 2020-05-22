//
//  settingsView.swift
//  refreshFromModal
//
//  Created by Serge Ostrowsky on 22/05/2020.
//  Copyright © 2020 Serge Ostrowsky. All rights reserved.
//

import SwiftUI
import UIKit

struct SettingsView: View {
    
    @Environment(\.presentationMode) var presentationMode // in order to dismiss the Sheet
        
    @EnvironmentObject var appState: AppState
    
    
    @State public var multiRules = UserDefaults.standard.bool(forKey: kmultiRules)
        
    @State private var ruleSelection = UserDefaults.standard.integer(forKey: kruleSelection) // 0 is rule 1, 1 is rule 2

    
    var body: some View {
        NavigationView {
            List {
                        Toggle(isOn: $multiRules) {
                           Text("more than one rule ?")
                        }
                        .padding(.horizontal)
                
                        if multiRules {
                            Picker("", selection: $ruleSelection){
                                Text("rules 1").tag(0)
                                Text("rules 2").tag(1)
                            }.pickerStyle(SegmentedPickerStyle())
                            .padding(.horizontal)
                        }

            } // End of List
            .navigationBarItems(
                leading:
                Button("Done") {
                        self.saveDefaults() // We try to save once more if needed
                        self.presentationMode.wrappedValue.dismiss() // This dismisses the view
                }
            )
                .navigationBarTitle("Settings", displayMode: .inline)
        } // END of Navigation view
    } // END of some View
    
    
    func saveDefaults() {
        UserDefaults.standard.set(multiRules, forKey: kmultiRules)
        UserDefaults.standard.set(ruleSelection, forKey: kruleSelection)
        
        self.appState.updateValues() // This is a func from the AppState class
    }
    
}



// MARK: Preview struct

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        
        return SettingsView().environmentObject(AppState())
    }
}
