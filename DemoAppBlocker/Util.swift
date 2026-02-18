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

@Observable
class BlockUtil{
    func IntervalChange(idString: String,isStarting: Bool){
        
        let id = UUID(uuidString: idString)
        let container = try? ModelContainer(for: Session.self)
        
        let context = ModelContext(container!)
        let descriptor = FetchDescriptor<Session>(
            predicate: #Predicate {
                $0.id == id!
            }
        )
        
        let sessions = try? context.fetch(descriptor)
        let currSession = sessions![0]
        
        if(isStarting){
            currSession.isBlocked = true
            try? context.save()
            applyBlock(currSession: currSession)
        }else{
            currSession.isBlocked = false
            try? context.save()
            removeBlock(currSession: currSession)
        }
    }
    
    func applyBlock(currSession: Session) {
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
    }
    
    func removeBlock(currSession: Session) {
        // 1. Get specific ManagedSettingsStore for current session
        let store = ManagedSettingsStore(named: ManagedSettingsStore.Name("\(currSession.id)Store"))
        
        // 2. Remove apps from store to remove shield
        store.shield.applications = nil
        store.shield.applicationCategories = nil
        store.shield.webDomains = nil
    }
}

@Observable
class DebuggingUtil{
    let center = DeviceActivityCenter()
    
    func printScheduledActivities(){
            print("count: ",center.activities.count)
            center.activities.forEach{activity in
                print("ACTIVITY: ", activity.rawValue)
                print(center.schedule(for: activity))
            }
        }
    
    func printSessions(){
            let container = try? ModelContainer(for: Session.self)
        

            let context = ModelContext(container!)
            let descriptor = FetchDescriptor<Session>()
            let moderationSessions = try? context.fetch(descriptor)
       
            print("ALL SESSIONS")
            moderationSessions!.forEach{ session in
                print("name: \(session.name)")
                print("id: \(session.id)")
                print("isBlocked: \(session.isBlocked)")
            }
        }
}
