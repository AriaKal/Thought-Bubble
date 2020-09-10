//
//  ViewController.swift
//  Thought Bubble
//
//  Created by Aria Kalforian on 2/2/20.
//  Copyright © 2020 Aria Kalforian. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var loginButton: UIButton!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Hide navigation bar
        self.navigationController?.isNavigationBarHidden = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        setUpElements()
    }
    
    func setUpElements() {
        
        // Set background color
        view.setGradientBackground(colorOne: Colors.white, colorTwo: Colors.lightBlue)
        
        // Style elements
        Utilities.styleFilledButton(signUpButton)
        Utilities.styleFilledButton(loginButton)
    }

}

