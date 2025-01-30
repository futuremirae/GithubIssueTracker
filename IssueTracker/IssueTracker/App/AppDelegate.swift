//
//  AppDelegate.swift
//  IssueTracker
//
//  Created by 김미래 on 9/23/24.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    func applicationWillTerminate(_ application: UIApplication) {
        do {
            try Keychain().remove(account: "access_token")
        } catch {
            print(error.localizedDescription)
        }
    }

}
