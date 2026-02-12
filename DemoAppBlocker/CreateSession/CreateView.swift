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
    @State var startTime: DateComponents = DateComponents(hour: 5, minute: 30)
    @State var endTime: DateComponents = DateComponents(hour: 7, minute: 30)
    @State var choosenDays: Set<Int> = []
    
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
                        let sessionId = UUID()
                        let session = Session(selectedApps: activitySelection, id: sessionId, name: sessionName, isBlocked: false)
                        modelContext.insert(session)
                        try? modelContext.save()
                        ActivityUtil().createActivity(days: choosenDays, startTime: startTime, endTime: endTime, sessionId: sessionId.uuidString)
                        dismiss()
                    }
                }
                .foregroundColor(.black)
                .opacity( activitySelection.applicationTokens.isEmpty && activitySelection.categoryTokens.isEmpty && activitySelection.webDomainTokens.isEmpty ? 0.5 : 1.0)
                .disabled(activitySelection.applicationTokens.isEmpty && activitySelection.categoryTokens.isEmpty && activitySelection.webDomainTokens.isEmpty)
            }
            .padding(.horizontal,20)
            
            VStack{
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
            }
            .padding(.vertical,10)
            .background(Color.gray.opacity(0.57))
            .clipShape(RoundedRectangle(cornerRadius: 10))
            .padding(.horizontal,4)
            
            AppSelectionView(activitySelection: $activitySelection)
                .padding(.vertical,8)
                .background(Color.gray.opacity(0.57))
                .clipShape(RoundedRectangle(cornerRadius: 10))
                .padding(.horizontal,4)
            
            TimeSelectionView(startTime: $startTime, endTime: $endTime)
                .padding(.vertical,8)
                .background(Color.gray.opacity(0.57))
                .clipShape(RoundedRectangle(cornerRadius: 10))
                .padding(.horizontal,4)
            
            DaySelectionView(tappedDays: $choosenDays)
                .background(Color.gray.opacity(0.57))
                .foregroundColor(.white) // Set the text color
                .clipShape(RoundedRectangle(cornerRadius: 10))
                .padding(.horizontal,4)
            
        }
        .frame(maxHeight:.infinity,alignment: .top)
        .navigationBarBackButtonHidden(true)
    }
    
    
}

#Preview {
    CreateView()
}
