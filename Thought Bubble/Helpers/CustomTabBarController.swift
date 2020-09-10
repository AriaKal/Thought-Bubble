//
//  CustomTabBarController.swift
//  Thought Bubble
//
//  Created by Aria Kalforian on 3/2/20.
//  Copyright © 2020 Aria Kalforian. All rights reserved.
//

import UIKit

class CustomTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Change icons to app's custom colors
        UITabBar.appearance().barTintColor = Colors.darkBlue
        UITabBar.appearance().tintColor = Colors.lightBlue
    }
}
