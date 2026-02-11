//
//  Util.swift
//  DemoAppBlocker
//
//  Created by Anne Hyacinthe on 2/11/26.
//
import ManagedSettings
import SwiftUI
import SwiftData
import FamilyControls
import DeviceActivity

@Observable
class ActivityUtil {
    let center = DeviceActivityCenter()
    
    func createActivity(days: Set<Int>, startTime: DateComponents, endTime: DateComponents, sessionId: String){
        if days.count == 7 {
            let schedule = DeviceActivitySchedule(
                intervalStart: startTime,
                intervalEnd: endTime,
                repeats: true,
                warningTime: nil
            )
            let activityId = UUID()
            do {
                try center.startMonitoring(DeviceActivityName("\(sessionId).\(activityId.uuidString)"), during: schedule)
            } catch {
                print("Error starting DeviceActivity monitoring: \(error)")
            }
        } else {
            days.forEach{ day in
                let schedule = DeviceActivitySchedule(
                    intervalStart: DateComponents(hour: startTime.hour, minute: startTime.minute, weekday:day + 1),// sunday is 1 and saturday is 7
                    intervalEnd: DateComponents(hour: endTime.hour, minute: endTime.minute, weekday:day + 1),
                    repeats: true,
                    warningTime: nil
                )
                let activityId = UUID()
                do {
                    try center.startMonitoring(DeviceActivityName("\(sessionId).\(activityId.uuidString)"), during: schedule)
                } catch {
                    print("Error starting DeviceActivity monitoring: \(error)")
                }
            }
        }
    }
    
    func deleteActivity(sessionId: String){
            var holder: [DeviceActivityName] = []
            center.activities.forEach{activity in
                if(activity.rawValue.contains(sessionId)){
                    holder.append(activity)
                }
            }
            for name in holder{
                if (center.schedule(for: name) != nil){
                    center.stopMonitoring([name])
                }
            }
        }
}
