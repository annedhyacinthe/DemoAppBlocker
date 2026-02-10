//
//  TimeSelectionView.swift
//  DemoAppBlocker
//
//  Created by Anne Hyacinthe on 2/10/26.
//

import SwiftUI

struct TimeSelectionView: View {
    @Binding var startTime: DateComponents
    @Binding var endTime: DateComponents
    @State var isShowingTimeModal = false
    var body: some View {
        VStack{
            Text("Time")
                .foregroundStyle(Color.white)
                .font(.system(size: 23, design: .monospaced))
                .frame(maxWidth: .infinity,alignment: .leading)
                .padding(.leading,3)
            Text("From when to when")
                .multilineTextAlignment(.center)
                .foregroundStyle(Color.black)
                .font(.system(size: 15))
                .frame(maxWidth: .infinity,alignment: .leading)
                .padding(.leading,3)
            HStack{
                Spacer()
                HStack(spacing: 0){
                    if(startTime.hour == 0){
                        Text("12:")
                    }else{
                        Text("\(12 < startTime.hour ?? 0 ? "\(startTime.hour! - 12):" : "\(startTime.hour ?? 0):")")
                    }
                    
                    Text("\(9 < startTime.minute ?? 0 ? "\(startTime.minute ?? 0)" : "0\(startTime.minute ?? 0)")")
                    
                    Text("\(11 < startTime.hour ?? 0 ? "PM" : "AM")")
                }
                .foregroundStyle(Color.white)
                .font(.system(size: 25, design: .monospaced))
                Spacer()
                Text("—")
                    .foregroundStyle(Color.white)
                    .font(.system(size: 25, design: .monospaced))
                Spacer()
                HStack(spacing: 0){
                    if(endTime.hour == 0){
                        Text("12:")
                    }else{
                        Text("\(12 < endTime.hour ?? 0 ? "\(endTime.hour! - 12):" : "\(endTime.hour ?? 0):")")
                    }
                    
                    Text("\(9 < endTime.minute ?? 0 ? "\(endTime.minute ?? 0)" : "0\(endTime.minute ?? 0)")")
                    
                    Text("\(11 < endTime.hour ?? 0 ? "PM" : "AM")")
                }
                .foregroundStyle(Color.white)
                .font(.system(size: 25, design: .monospaced))
                Spacer()
            }
            .frame(maxWidth: .infinity,minHeight: 50)
            .background(Color.gray.opacity(0.7))
            .clipShape(RoundedRectangle(cornerRadius: 10))
            .padding(.horizontal,6)
        }
        .sheet(isPresented: $isShowingTimeModal, content: {
            TimeModalView(startComponent:DateComponents(hour:1,minute: 0),endComponent:DateComponents(hour:1,minute: 0), startTime: $startTime, endTime: $endTime)
                .presentationDetents([.fraction(0.45)])
                .presentationDragIndicator(.visible)
        })
        .onTapGesture {
            isShowingTimeModal = true
        }
    }
}

struct TimeModalView: View {
    @Environment(\.dismiss) var dismiss
    @State var startComponent: DateComponents
    @State var endComponent: DateComponents
    @State var startAmOrPm = 0
    @State var endAmOrPm = 0
    @State var isError = false
    @Binding var startTime: DateComponents
    @Binding var endTime: DateComponents
    
    func convertTime(min:Int, hour:Int, isAm:Bool) -> DateComponents{
        if(hour == 12){
            if(isAm){
                return DateComponents(hour: 0, minute: min)
            } else {
                return DateComponents(hour: 12, minute: min)
            }
        }
        if(!isAm){
            return DateComponents(hour: hour + 12, minute: min)
        }
        return DateComponents(hour: hour, minute: min)
    }
    
    var body: some View {
        ZStack {
            VStack{
                Text("Choose start and end time of session")
                    .bold()
                    .padding(.top,15)
                Text("From 12:00AM to 11:59PM")
                Spacer()
                
                Text(isError ? "Theres an error with the time" : "")
                    .font(.title)
                HStack{
                    HStack(spacing: 0){
                        Picker("", selection: $startComponent.hour){
                            ForEach(1..<13, id: \.self) { i in
                                Text("\(i)").tag(i)
                            }
                        }
                        .pickerStyle(.wheel)
                        .padding(.trailing, -15)
                        .clipped()
                        Picker("", selection: $startComponent.minute){
                            ForEach(0..<60, id: \.self) { i in
                                Text( i < 10 ? "0\(i)" : "\(i)").tag(i)
                            }
                            
                        }
                        .pickerStyle(.wheel)
                        .padding(.horizontal, -15)
                        .clipped()
                        Picker("", selection: $startAmOrPm){
                            Text("AM").tag(0)
                            Text("PM").tag(1)
                        }
                        .pickerStyle(.wheel)
                        .padding(.leading, -15)
                        .clipped()
                    }
                    
                    Spacer()
                    Text("—")
                    Spacer()
                    
                    HStack(spacing: 0){
                        Picker("", selection: $endComponent.hour){
                            ForEach(1..<13, id: \.self) { i in
                                Text("\(i)").tag(i)
                            }
                        }//.pickerStyle(WheelPickerStyle())
                        .pickerStyle(.wheel)
                        .padding(.trailing, -15)
                        .clipped()
                        Picker("", selection: $endComponent.minute){
                            ForEach(0..<60, id: \.self) { i in
                                Text( i < 10 ? "0\(i)" : "\(i)").tag(i)
                            }
                            
                        }
                        .pickerStyle(.wheel)
                        .padding(.horizontal, -15)
                        .clipped()
                        Picker("", selection: $endAmOrPm){
                            Text("AM").tag(0)
                            Text("PM").tag(1)
                        }
                        .pickerStyle(.wheel)
                        .padding(.leading, -15)
                        .clipped()
                    }
                }
                .task {
                    if let hour = startTime.hour, let minute = startTime.minute {
                        startComponent.hour = 12 < hour ? hour - 12 : (hour == 0 ? 12 : hour)
                        startComponent.minute = minute
                        startAmOrPm = 12 <= hour ? 1 : 0
                    }
                    if let hour = endTime.hour, let minute = endTime.minute {
                        endComponent.hour = 12 < hour ? hour - 12 : (hour == 0 ? 12 : hour)
                        endComponent.minute = minute
                        endAmOrPm = 12 <= hour ? 1 : 0
                    }
                }
                
                Spacer()
                Button("Save") {
                    let startConverted = convertTime(min:startComponent.minute ?? 0, hour:startComponent.hour ?? 0, isAm:startAmOrPm == 0)
                    let endConverted = convertTime(min:endComponent.minute ?? 0, hour:endComponent.hour ?? 0, isAm:endAmOrPm == 0)
                    
                    if let convertedStartHour = startConverted.hour,
                       let convertedStartMinute = startConverted.minute,
                       let convertedEndHour = endConverted.hour,
                       let convertedEndMinute = endConverted.minute {
                        let endTimeInSeconds = (convertedEndHour * 60 * 60) + (convertedEndMinute * 60)
                        let startTimeInSeconds = (convertedStartHour * 60 * 60) + (convertedStartMinute * 60)
                        if( endTimeInSeconds <= startTimeInSeconds){
                            isError = true
                        }else{
                            startTime = startConverted
                            endTime = endConverted
                            dismiss()
                        }
                    }
                }
                .padding()
                .clipShape(RoundedRectangle(cornerRadius: 10))
                Spacer()
            }
            .preferredColorScheme(.dark)
        }
    }
}
