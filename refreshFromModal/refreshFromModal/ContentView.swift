//
//  ContentView.swift
//  refreshFromModal
//
//  Created by Serge Ostrowsky on 22/05/2020.
//  Copyright © 2020 Serge Ostrowsky. All rights reserved.
//

import SwiftUI
import CoreData

struct ContentView: View {
    
    @EnvironmentObject var appState: AppState

    @State var modalIsPresented = false // The "settingsView" modally presented as a sheet

    @State var recapString = "" // This displays a line that recaps the user's prefs
    
    @State var appStateChanged = UserDefaults.standard.value(forKey: "appStateChanged") as? Bool ?? false // To trigger a refresh when a setting is changed
    
   @State private var modalViewCaller = 0 // This triggers the appropriate modal (only one in this example)
    
     private var isDualRules: Bool = UserDefaults.standard.bool(forKey: kmultiRules)
    
    // MARK: View modifiers :
    // This modifier, applied to the views to be displayed, prevents the dismissal of the modal view by swiping down, thanks to the UIApplication extension in AppDelegate
    struct DisableModalDismiss: ViewModifier {
        let disabled: Bool
        func body(content: Content) -> some View {
            disableModalDismiss()
            return AnyView(content)
        }
        func disableModalDismiss() {
            guard let visibleController = UIApplication.shared.visibleViewController() else { return }
            visibleController.isModalInPresentation = disabled
        }
    } // End of DisabledModalDismiss
    
    var body: some View {
        
        NavigationView {
            VStack {
                Spacer()
                    VStack {
                    Text(recapString) // This never appears !
                    Text(generateStrings().text1)
                        .foregroundColor(generateStrings().2 ? Color(UIColor.systemGreen) : Color(UIColor.systemRed))
                    Text(generateStrings().text2)
                    } // end of VStack
                        .frame(maxWidth: .infinity, alignment: .center)
                        .lineLimit(nil) // allows unlimited lines
                        .padding(.all)
                        .overlay(RoundedRectangle(cornerRadius: 10).stroke(generateStrings().2 ? Color(UIColor.systemGreen) : Color(UIColor.systemRed), lineWidth: 2))
                        .padding([.leading, .trailing, .bottom])
                Spacer()
            } // END of main VStack
            .onAppear() {
                self.modalViewCaller = 0
            }
            .navigationBarTitle("Test app", displayMode: .inline)
            .navigationBarItems(leading: (
                Button(action: {
                    self.modalViewCaller = 6 // SettingsView
                    self.modalIsPresented = true
                }
                    ) {
                        Image(systemName: "gear")
                            .imageScale(.large)
                     }
            ))
        } // END of NavigationView
        .sheet(isPresented: $modalIsPresented, content: sheetContent)
        .navigationViewStyle(StackNavigationViewStyle()) // This avoids dual column on iPad

    } // END of var body: some View
  // MARK: @ViewBuilder func sheetContent() :
    
    @ViewBuilder func sheetContent() -> some View {
        
        if modalViewCaller == 6 {
            SettingsView()
                .environmentObject(AppState())
                .modifier(DisableModalDismiss(disabled: true))
                .navigationViewStyle(StackNavigationViewStyle())
                .onDisappear { // This always triggered
                    self.modalViewCaller = 0
                    NotificationCenter.default.addObserver(forName: NSNotification.Name("settingsChanged"), object: nil, queue: .main) { (_) in
                    
                    let status = UserDefaults.standard.bool(forKey: kappStateChanged) ? false : true
                    self.appStateChanged = status
                        // We post that there was a change :
                    NotificationCenter.default.post(name: NSNotification.Name("statusChange"), object: nil)
                }
            }
        }
    } // END of func sheetContent
    
    
    // MARK: generateStrings() : -
    
    func generateStrings() -> (text1: String, text2: String, isHappy: Bool) { // minimumNumberOfEventsCheck
        
        var myBool = false
        var aString = "" // The text 1 string
        var bString = "" // The text 2 string
    
        if isDualRules { // The user chose the dual rules option
            let ruleSet = UserDefaults.standard.integer(forKey: kruleSelection) + 1
            aString = "User chose 2 rules option"
            bString = "User chose rule set # \(ruleSet)"
            myBool = true
            
            // we try to update the recapString (never shows) :
            self.recapString = "Dual rules option, user chose rule set nb \(ruleSet)"
        }
            else // The user chose the single rule option
        {
            aString = "User chose single rule option"
            bString = "User had no choice : there is only one set of rules !"
            myBool = false
            // we try to update the recapString (never shows) :
            self.recapString = "Single rule option, user chose nothing."
        }
        
        
            return (aString, bString, myBool)
    } // End of func generatestrings() -> String
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        return ContentView().environmentObject(AppState())
        
    }
}
