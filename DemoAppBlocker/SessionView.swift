//
//  SessionView.swift
//  DemoAppBlocker
//
//  Created by Anne Hyacinthe on 1/29/26.
//

import SwiftUI
import SwiftData
import ManagedSettings

struct sessionView: View {
    let currSession: Session
    
    func applyBlock() {
        // 1. Get tokens of selected apps
        let applicationTokens = currSession.selectedApps.applicationTokens
        let categoryTokens = currSession.selectedApps.categoryTokens
        let webTokens = currSession.selectedApps.webDomainTokens
        
        // 2. Create a ManagedSettingsStore specifically for the current session
        let store = ManagedSettingsStore(named: ManagedSettingsStore.Name("\(currSession.id)Store"))
        
        // 3. Use store to apply shields
        store.shield.applications = applicationTokens.isEmpty ? nil : applicationTokens
        //Categories need the specific
        store.shield.applicationCategories = categoryTokens.isEmpty ? nil : .specific(categoryTokens)
        store.shield.webDomains = webTokens.isEmpty ? nil : webTokens
        
        currSession.isBlocked = true
    }
    
    func removeBlock() {
        // 1. Get specific ManagedSettingsStore for current session
        let store = ManagedSettingsStore(named: ManagedSettingsStore.Name("\(currSession.id)Store"))
        
        // 2. Remove apps from store to remove shield
        store.shield.applications = nil
        store.shield.applicationCategories = nil
        store.shield.webDomains = nil
        
        currSession.isBlocked = false
    }
    
    var body: some View {
        VStack{
            Text(currSession.name)
                .foregroundStyle(Color.white)
                .font(.system(size: 23, design: .monospaced))
            Spacer()
            if(currSession.isBlocked){
                Button("Unblock") {
                    removeBlock()
                }
                .padding()
                .background(Color.red.opacity(0.7))
                .foregroundColor(.white)
                .clipShape(RoundedRectangle(cornerRadius: 10))
            }else{
                Button("Block") {
                    applyBlock()
                }
                .padding()
                .background(Color.red.opacity(0.7))
                .foregroundColor(.white)
                .clipShape(RoundedRectangle(cornerRadius: 10))
            }
            
        }
        .frame(height:100,alignment: .top)
        .frame(maxWidth: .infinity)
        .padding(.vertical,10)
        .padding(.horizontal,20)
        .background(Color.brown.opacity(0.57))
        .clipShape(RoundedRectangle(cornerRadius: 10))
    }
}
