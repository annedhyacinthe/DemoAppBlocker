//
//  DaySelectionView.swift
//  DemoAppBlocker
//
//  Created by Anne Hyacinthe on 2/10/26.
//

import SwiftUI

struct DaySelectionView: View {
    let days = ["S","M","T","W","Th","F","S"]
    @Binding var tappedDays: Set<Int>
    var body: some View {
        VStack{
            Text("Select Days")
                .font(.system(size: 23, design: .monospaced))
                .frame(maxWidth: .infinity,alignment: .leading)
            
            GeometryReader{ geometry in
                HStack{
                    ForEach(Array(days.enumerated()), id: \.offset) { index, day in
                        DayView(letter: day, isTapped: Binding(
                            get: { tappedDays.contains(index) },
                            set: { _ in  }
                        ))
                        .onTapGesture {
                            if tappedDays.contains(index) {
                                tappedDays.remove(index)
                            } else {
                                tappedDays.insert(index)
                            }
                        }
                    }
                }
                .frame(width: geometry.size.width * 1)
            }
            .frame(height:40)
        }
        .padding(.vertical,10)
        .padding(.horizontal,6)
    }
}

struct DayView: View {
    var letter: String
    @Binding var isTapped: Bool
    var body: some View {
        ZStack{
            Circle()
                .fill(isTapped ? Color.red : Color.red.opacity( 0.45))
            Text(letter)
                .foregroundStyle(Color.black)
                .font(.system(size: 20, design: .monospaced))
        }
    }
}
