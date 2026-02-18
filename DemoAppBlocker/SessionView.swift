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
        currSession.isBlocked = true
        BlockUtil().applyBlock(currSession: currSession)
    }
    
    func removeBlock() {
        currSession.isBlocked = false
        BlockUtil().removeBlock(currSession: currSession)
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
