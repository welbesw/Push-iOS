//
//  ViewController.swift
//  Push
//
//  Created by William Welbes on 3/3/18.
//  Copyright © 2018 Will. All rights reserved.
//

import UIKit

class ViewController: UIViewController, PushManagerDelegate {

    @IBOutlet weak var pushTokenLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()

        PushManager.sharedInstance.delegate = self

        pushTokenLabel.text = ""
    }

    func pushManagerUpdated() {
        pushTokenLabel.text = PushManager.sharedInstance.deviceToken?.deviceTokenString()
    }
}

