//
//  SignUpViewController.swift
//  Thought Bubble
//
//  Created by Aria Kalforian on 2/2/20.
//  Copyright © 2020 Aria Kalforian. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class SignUpViewController: UIViewController {
    
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var signUpButton: UIButton!
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
        self.navigationItem.title = "Sign Up"
        let textAttributes = [NSAttributedString.Key.foregroundColor:UIColor.white, NSAttributedString.Key.font: UIFont(name: "HelveticaNeue", size: 24)!]
           navigationController?.navigationBar.titleTextAttributes = textAttributes
        
        // Hide the error label
        errorLabel.alpha = 0;
        
        // Style the text fields
        Utilities.styleTextField(usernameTextField)
        Utilities.styleTextField(emailTextField)
        Utilities.styleTextField(passwordTextField)
        Utilities.styleFilledButton(signUpButton)
    }
    
    // Check the textfields and validate the data. If all is ok, return nil . Otherwise, return error message
    func validateFields() -> String? {
        
        // Check that all fields are filled
        if  usernameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            emailTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            passwordTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" {
            
            // Prompt user to fill in the empty fields.
            return "Please, fill in all required fields."
        }
        
        // Check if password is secure
        let cleanedPassword = passwordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if Utilities.isPasswordValid(cleanedPassword) == false {
            // Password failed security check
            return "Password must be at least 8 characters long and should contain a special character!"
        }
    
        // Check if email is secure
        let cleanedEmail = emailTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if Utilities.isEmailValid(cleanedEmail) == false {
            // Email failed security check
            return "Enter a valid email"
        }
        
        return nil
    }

    // When user taps on sign up button
    @IBAction func signUpTapped(_ sender: Any) {
        
        // Validate the fields
        let error = validateFields()
        
        // User input invalid
        if error != nil {
            Utilities.showError(error!, errorLabel)
        }
            
        // Inputs valid
        else {
            
            // Store cleaned versions of input data
            let username = usernameTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let email = emailTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let password = passwordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            
            // Create the user
            Auth.auth().createUser(withEmail: email, password: password) { (result, error) in
                
                // Error occured
                if error != nil {
                    Utilities.showError("Error creating user", self.errorLabel)
                }
        
                // User successfully created -> store username
                else {
                
                    let db = Firestore.firestore()
                    db.collection("users").addDocument(data: ["username":username, "uid":result!.user.uid]) { (error) in
                        
                        // Error occured
                        if error != nil {
                            Utilities.showError("Error storing user data", self.errorLabel)
                        }
                    }
                    
                    // Transition to the home screen
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
