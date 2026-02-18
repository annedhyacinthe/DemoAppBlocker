//
//  ContentView.swift
//  DemoAppBlocker
//
//  Created by Anne Hyacinthe on 1/26/26.
//

import SwiftUI
import SwiftData
import FamilyControls

struct ContentView: View {
    @Query private var sessions: [Session]
    @State private var path = NavigationPath()
    
    var body: some View {
        NavigationStack(path: $path){
            VStack{
                HStack{
//                    Button("print") {
//                        DebuggingUtil().printScheduledActivities()
//                        DebuggingUtil().printSessions()
//                    }
                    Spacer()
                    Spacer()
                    Text("Sessions")
                        .font(.system(size: 30, design: .monospaced))
                    Spacer()
                    Button("Add") {
                        path.append("create")
                    }
                    .padding(10)
                    .background(Color.red.opacity(0.7))
                    .foregroundColor(.white)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                    .padding(.trailing,10)
                }
                Divider()
                ScrollView {
                    ForEach(sessions){ session in
                        sessionView(currSession: session)
                            .padding(.horizontal,14)
                            .padding(.top,10)
                    }
                }.scrollIndicators(.hidden)
            }
            .frame(maxHeight:.infinity,alignment: .top)
            .navigationDestination(for: String.self) { str in
                if str == "create"{
                    CreateView()
                }
            }
        }
    }
    
    
}

#Preview {
    ContentView()
        .modelContainer(for: Session.self, inMemory: true)
}
