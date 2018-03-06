//
//  PushManager.swift
//  Push
//
//  Created by William Welbes on 3/4/18.
//  Copyright © 2018 Will. All rights reserved.
//

import UIKit
import UserNotifications

protocol PushManagerDelegate {
    func pushManagerUpdated()
}

class PushManager: NSObject {
    static let sharedInstance = PushManager()

    var deviceToken:Data?
    var delegate: PushManagerDelegate?

    func registerForPushNotifications() {

        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { (permissionGranted, error) in
            DispatchQueue.main.async {
                print("registerForPushNotifications(): permissionGranted? \(permissionGranted)")

                guard permissionGranted else {
                    return
                }
                self.getNotificationSettings()
            }
        }

    }
    
    func didRegisterForRemoteNotifications(deviceToken: Data) {
        self.deviceToken = deviceToken

        print("Device Token: \(deviceToken.deviceTokenString())")

        delegate?.pushManagerUpdated()
    }

    func getNotificationSettings() {
        UNUserNotificationCenter.current().getNotificationSettings { (settings) in
            DispatchQueue.main.async {
                print("Notification settings: \(settings)")

                guard settings.authorizationStatus == .authorized else { return }
                UIApplication.shared.registerForRemoteNotifications()
            }
        }
    }
}

extension PushManager: UNUserNotificationCenterDelegate {

    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {

        //Tell iOS to still show the push notification so it's not just consumed in the foreground
        completionHandler(UNNotificationPresentationOptions.alert)
    }
}

extension Data {
    func deviceTokenString() -> String {
        let tokenParts = self.map { data -> String in
            return String(format: "%02.2hhx", data)
        }

        return tokenParts.joined()
    }
}
