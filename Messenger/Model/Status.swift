//
//  Status.swift
//  Messenger
//
//  Created by wajih on 8/28/22.
//

import Foundation

enum Status : String{
    
    case Available = "Available"
    case Busy = "Busy"
    case AtSchool = "AtSchool"
    case AtWork = "AtWork"
    case BatteryAboutToDie = "BatteryAboutToDie"
    case CantTalk = "Can't Talk"
    case InAMeeting = "In a Meeting"
    case AtTheGym = "At the Gym"
    case Sleeping = "Sleeping"
    case UrgentCallsOnly = "Urgent calls only"
    
    static var array : [Status]{
        var a :  [Status] =  []
        switch Status.Available{
        case .Available:
            a.append(.Available);fallthrough
        case .Busy :
            a.append(.Busy);fallthrough
        case .AtSchool:
            a.append(.AtSchool);fallthrough
        case .AtWork:
            a.append(.AtWork);fallthrough
        case .BatteryAboutToDie:
            a.append(.BatteryAboutToDie);fallthrough
        case .CantTalk:
            a.append(.CantTalk);fallthrough
        case .InAMeeting:
            a.append(.InAMeeting);fallthrough
        case .AtTheGym:
            a.append(AtTheGym);fallthrough
        case .Sleeping:
            a.append(.Sleeping);fallthrough
        case .UrgentCallsOnly:
            a.append(.UrgentCallsOnly)
            return a
        }
    }
    
}
