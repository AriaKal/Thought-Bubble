//
//  LoginViewController.swift
//  Thought Bubble
//
//  Created by Aria Kalforian on 2/2/20.
//  Copyright © 2020 Aria Kalforian. All rights reserved.
//

import UIKit
import FirebaseAuth

class LoginViewController: UIViewController {
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var errorLabel: UILabel!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Show navigation bar
        self.navigationController?.isNavigationBarHidden = false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setUpElements()
    }
    
    func setUpElements() {
        self.navigationItem.title = "Login"
        let textAttributes = [NSAttributedString.Key.foregroundColor:UIColor.white, NSAttributedString.Key.font: UIFont(name: "HelveticaNeue", size: 24)!]
           navigationController?.navigationBar.titleTextAttributes = textAttributes
        
        // Hide the error label
        errorLabel.alpha = 0;
        
        // Style the elements
        Utilities.styleTextField(emailTextField)
        Utilities.styleTextField(passwordTextField)
        Utilities.styleFilledButton(loginButton)
    }
    
    // Check the textfields and validate the data. If all is ok, return nil . Otherwise, return error message
    func validateFields() -> String? {
        
        // Check that all fields are filled
        if  emailTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            passwordTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" {
            
            // Prompt user to fill in the empty fields.
            return "Please, fill in all required fields."
        }
        
        return nil
    }
    
    // When user taps on log in button
    @IBAction func loginTapped(_ sender: Any) {
        
        // Validate the fields
        let error = validateFields()
        
        // User input invalid
        if error != nil {
            Utilities.showError(error!, errorLabel)
        }
        
        // User input valid
        else {
            
            // Store cleaned versions of input data
            let email = emailTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let password = passwordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            
            // Signing in the user
            Auth.auth().signIn(withEmail: email, password: password) { (result, error) in
                
                // Sign in error occured
                if error != nil {
                    Utilities.showError(error!.localizedDescription, self.errorLabel)
                }
        
                // No error
                else {
                    self.transitionToHome()
                }
            }
        }
    }
    
    // Launch home screen
    func transitionToHome() {
        let homeViewController = storyboard?.instantiateViewController(identifier: "mainTabBar") as! UITabBarController
        
        view.window?.rootViewController = homeViewController
        view.window?.makeKeyAndVisible()
    }
}
