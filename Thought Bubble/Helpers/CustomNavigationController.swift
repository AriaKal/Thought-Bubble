//
//  CustomNavigationController.swift
//  Thought Bubble
//
//  Created by Aria Kalforian on 3/5/20.
//  Copyright © 2020 Aria Kalforian. All rights reserved.
//

import UIKit

class CustomNavigationController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()

        UINavigationBar.appearance().barTintColor = Colors.darkBlue
        UINavigationBar.appearance().tintColor = .white
    }
    
    // Change status bar theme to the light version
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
}
