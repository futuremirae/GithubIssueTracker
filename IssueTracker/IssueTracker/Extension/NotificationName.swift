//
//  NotificationName.swift
//  IssueTracker
//
//  Created by 김미래 on 9/29/24.
//

import Foundation

extension Notification.Name {
    static let addAssignee = Notification.Name(rawValue: "addAssignee")
    static let addLabel = Notification.Name(rawValue: "addLabel")
    static let addMilestone = Notification.Name(rawValue: "addMilestone")
}
