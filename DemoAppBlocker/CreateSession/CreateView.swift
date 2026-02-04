//
//  CreateView.swift
//  DemoAppBlocker
//
//  Created by Anne Hyacinthe on 1/28/26.
//

import SwiftUI
import SwiftData
import FamilyControls

struct CreateView: View {
    @Environment(\.dismiss) var dismiss
    @Environment(\.modelContext) private var modelContext
    @State var sessionName: String = ""
    @State var activitySelection = FamilyActivitySelection()
    
    var body: some View {
        VStack{
            HStack{
                Button("Cancel") {
                    dismiss()
                }
                .foregroundColor(.red)
                Spacer()
                Button("Save") {
                    if(!activitySelection.applicationTokens.isEmpty || !activitySelection.categoryTokens.isEmpty || !activitySelection.webDomainTokens.isEmpty){
                        let session = Session(selectedApps: activitySelection, id: UUID(), name: sessionName, isBlocked: false)
                        modelContext.insert(session)
                        try? modelContext.save()
                        dismiss()
                    }
                }
                .foregroundColor(.black)
                .opacity( activitySelection.applicationTokens.isEmpty && activitySelection.categoryTokens.isEmpty && activitySelection.webDomainTokens.isEmpty ? 0.5 : 1.0)
                .disabled(activitySelection.applicationTokens.isEmpty && activitySelection.categoryTokens.isEmpty && activitySelection.webDomainTokens.isEmpty)
            }
            .padding(.horizontal,20)
            
            
            TextField(
                "Enter Session Name",
                text: $sessionName
            )
            .foregroundStyle(Color.black)
            .font(.system(size: 30, design: .monospaced))
            .multilineTextAlignment(.leading)
            Rectangle()
                .frame(height: 1)
                .foregroundColor(.black)
                .padding(.leading, 5)
                .padding(.trailing, 16)
            
            AppSelectionView(activitySelection: $activitySelection)
            
        }
        .frame(maxHeight:.infinity,alignment: .top)
        .navigationBarBackButtonHidden(true)
    }
    
    
}

#Preview {
    CreateView()
}
