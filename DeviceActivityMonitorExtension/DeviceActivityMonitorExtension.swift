//
//  DeviceActivityMonitorExtension.swift
//  DeviceActivityMonitorExtension
//
//  Created by Anne Hyacinthe on 2/11/26.
//

import DeviceActivity

// Optionally override any of the functions below.
// Make sure that your class name matches the NSExtensionPrincipalClass in your Info.plist.
class DeviceActivityMonitorExtension: DeviceActivityMonitor {
    let blockUtil = BlockUtil()
    override func intervalDidStart(for activity: DeviceActivityName) {
        super.intervalDidStart(for: activity)
        
        // Handle the start of the interval.
        let currActivity = activity.rawValue.split(separator: ".")[0]
        blockUtil.IntervalChange(idString: String(currActivity),isStarting: true)
    }
    
    override func intervalDidEnd(for activity: DeviceActivityName) {
        super.intervalDidEnd(for: activity)
        
        // Handle the end of the interval.
        let currActivity = activity.rawValue.split(separator: ".")[0]
        blockUtil.IntervalChange(idString: String(currActivity),isStarting: false)
    }
    
    override func eventDidReachThreshold(_ event: DeviceActivityEvent.Name, activity: DeviceActivityName) {
        super.eventDidReachThreshold(event, activity: activity)
        
        // Handle the event reaching its threshold.
    }
    
    override func intervalWillStartWarning(for activity: DeviceActivityName) {
        super.intervalWillStartWarning(for: activity)
        
        // Handle the warning before the interval starts.
    }
    
    override func intervalWillEndWarning(for activity: DeviceActivityName) {
        super.intervalWillEndWarning(for: activity)
        
        // Handle the warning before the interval ends.
    }
    
    override func eventWillReachThresholdWarning(_ event: DeviceActivityEvent.Name, activity: DeviceActivityName) {
        super.eventWillReachThresholdWarning(event, activity: activity)
        
        // Handle the warning before the event reaches its threshold.
    }
}
