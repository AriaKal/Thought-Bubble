//
//  UserProfile.swift
//  Thought Bubble
//
//  Created by Aria Kalforian on 4/16/20.
//  Copyright © 2020 Aria Kalforian. All rights reserved.
//

import UIKit
import Firebase

class UserProfile: UIViewController {
    var documentID = ""
    let uid = Auth.auth().currentUser!.uid
    let db = Firestore.firestore()
    let username = UITextField(frame:CGRect(x: 20.0, y: 100.0, width: UIScreen.main.bounds.size.width-20, height: 50.0))
    let email = UITextField(frame:CGRect(x: 20.0, y: 170.0, width: UIScreen.main.bounds.size.width-20, height: 50.0))
    let password = UITextField(frame:CGRect(x: 20.0, y: 240, width: UIScreen.main.bounds.size.width-20, height: 50.0))
    let confirmPassword = UITextField(frame:CGRect(x: 20.0, y: 310.0, width: UIScreen.main.bounds.size.width-20, height: 50.0))
    
    // Alert messages
    let successMessage = "Changes saved successfully."
    let emptyFields = "There is nothing to save. Please, fill in the necessary fields."
    let differentPasswords = "Make sure that the passwords match."
    let passwordMissing = "Please, fill in both password fields."
    let invalidEmail = "Please, enter a valid email."
    let invalidPass = "Make sure the password is at least 8 characters long and contains a special character!"
    
    // Alert types
    let warning = "Warning"
    let success = "Success"

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Styling of the view
        view.backgroundColor = .white
        self.navigationItem.title = "Edit My Info"
        let textAttributes = [NSAttributedString.Key.foregroundColor:UIColor.white, NSAttributedString.Key.font: UIFont(name: "HelveticaNeue", size: 24)!]
        navigationController?.navigationBar.titleTextAttributes = textAttributes
        
        username.placeholder = "enter new username"
        email.placeholder = "enter new email"
        
        password.placeholder = "enter new password"
        password.isSecureTextEntry = true
        password.textContentType = .oneTimeCode

        confirmPassword.placeholder = "confirm new password"
        confirmPassword.isSecureTextEntry = true
        confirmPassword.textContentType = .oneTimeCode
        
        Utilities.styleTextField(username)
        Utilities.styleTextField(email)
        Utilities.styleTextField(password)
        Utilities.styleTextField(confirmPassword)
        view.addSubview(username)
        view.addSubview(email)
        view.addSubview(password)
        view.addSubview(confirmPassword)
        
        let saveButton = UIButton.init(type: .system)
        saveButton.frame = CGRect(x: 40.0, y: 410.0, width: 334.0, height: 50.0)
        saveButton.setTitle("Save Changes", for: .normal)
        saveButton.addTarget(self, action: #selector(saveButtonClicked(_ :)), for: .touchUpInside)
        
        Utilities.styleFilledButton(saveButton)
        view.addSubview(saveButton)
    }
    
    func alertUpdate(message: String, type: String){
        // Alert user that passwords do not match
        let alertController = UIAlertController(title: type, message: message, preferredStyle: .alert)
        let OKAction = UIAlertAction(title: "OK", style: .default) { (action:UIAlertAction!) in
            print("Ok button tapped");
        }
        alertController.addAction(OKAction)
        present(alertController, animated: true, completion: nil)
    }
    
    @objc func saveButtonClicked(_: UIButton) {
        // Nothing to submit but clicked button anyways
        if(username.text == "" && email.text == "" && password.text == "" && confirmPassword.text == "") {
            alertUpdate(message: self.emptyFields, type: self.warning)
        }
        
        // User changed username
        if(username.text != "") {
            // Get document for user
            let query = db.collection("users").whereField("uid", isEqualTo: uid)
            query.getDocuments { (querySnapshot, error) in
                for document in querySnapshot!.documents {
                    self.documentID = document.documentID
                    // save new username
                    self.db.collection("users").document(self.documentID).updateData(["username": self.username.text ?? ""])
                    self.alertUpdate(message: self.successMessage, type: self.success)
                }
            }
        }
        
        // User changed email
        if(email.text != "") {
            if (Utilities.isEmailValid(email.text ?? "") == true) {
                // save new email
                Auth.auth().currentUser?.updateEmail(to: email.text ?? "") { error in
                if error != nil {
                    // An error happened
                    print("error updating email")
                } else {
                   // Email updated.
                    print("should be updated")
                    self.alertUpdate(message: self.successMessage, type: self.success)
                   }
                }
            } else {
                alertUpdate(message: self.invalidEmail, type: self.warning)
            }
        }
        
        // User changed password
        if ((password.text != "") && (confirmPassword.text != "")) {
            if(password.text == confirmPassword.text) {
                if (Utilities.isPasswordValid(password.text ?? "") == true) {
                    // save new password
                    Auth.auth().currentUser?.updatePassword(to: password.text ?? "") { error in
                        if error != nil {
                            // An error happened
                            print("error updating password")
                        } else {
                            // Password updated.
                            print("should be updated")
                            self.alertUpdate(message: self.successMessage, type: self.success)
                        }
                    }
                } else {
                    alertUpdate(message: self.invalidPass, type: self.warning)
                }
            } else {
                // Alert user that passwords do not match
                alertUpdate(message: self.differentPasswords, type: self.warning)
            }
        }
        
        // User typed only one of the passwords
        if ((password.text == "" && confirmPassword.text != "") || (password.text != "" && confirmPassword.text == ""))  {
            // Alert user to fill in both password fields
            alertUpdate(message: self.passwordMissing, type: self.warning)
        }
    }
}
