//
//  AppSelectionView.swift
//  DemoAppBlocker
//
//  Created by Anne Hyacinthe on 1/28/26.
//

import SwiftUI
import FamilyControls

struct AppSelectionView: View {
    @Binding var activitySelection: FamilyActivitySelection
    @State private var isPickerPresented = false
    
    var body: some View {
        VStack{
            HStack{
                Text("Select Apps")
                    .foregroundStyle(Color.black)
                    .font(.system(size: 23, design: .monospaced))
                    .frame(maxWidth: .infinity,alignment: .leading)
                
                HStack{
                    Image(systemName: "square.grid.2x2")
                    Text("\(activitySelection.categoryTokens.count)")
                    Image(systemName: "apps.iphone")
                    Text("\(activitySelection.applicationTokens.count)")
                    Image(systemName: "network")
                    Text("\(activitySelection.webDomainTokens.count)")
                    Image(systemName: "chevron.right")
                }
                .padding(.trailing,3)
            }
        }
        .padding(.vertical,10)
        .padding(.trailing,20)
        .onTapGesture {
            isPickerPresented = true
        }
        .familyActivityPicker(
            isPresented: $isPickerPresented,
            selection: $activitySelection
        )
    }
}
