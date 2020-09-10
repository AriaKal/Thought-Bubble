//
//  Utilities.swift
//  Thought Bubble
//
//  Created by Aria Kalforian on 2/2/20.
//  Copyright © 2020 Aria Kalforian. All rights reserved.
//

import Foundation
import UIKit

extension UIView {
    
    // Create a gradient background of two colors
    func setGradientBackground(colorOne: UIColor, colorTwo: UIColor) {
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = bounds
        gradientLayer.colors = [colorOne.cgColor,colorTwo.cgColor]
        gradientLayer.locations = [0.0, 1.0]
        gradientLayer.startPoint = CGPoint(x: 1.0, y: 0.0)
        gradientLayer.endPoint = CGPoint(x: 1.0, y: 1.0)
    
        layer.insertSublayer(gradientLayer, at: 0)
    }
}

class Utilities {
    
    static func styleTextField(_ textfield:UITextField) {
        
        // Create the bottom line
        let bottomLine = CALayer()
        bottomLine.frame = CGRect(x: 0, y: textfield.frame.height - 2, width: textfield.frame.width, height: 2)
        bottomLine.backgroundColor = Colors.darkBlue.cgColor
        
        // Remove border on text field
        textfield.borderStyle = .none
        
        // Add the line to the text field
        textfield.layer.addSublayer(bottomLine)
        
        // Text Field color
        textfield.textColor = Colors.darkBlue
    }
    
    static func styleFilledButton(_ button:UIButton) {

        // Filled rounded corner style
        button.backgroundColor = Colors.darkBlue
        button.layer.cornerRadius = 25.0
        button.tintColor = UIColor.white
    }
    
    // Check if password matches regex pattern: minimum 8 chars, a special char and an alphabet
    static func isPasswordValid(_ password : String) -> Bool {
        
        let passwordTest = NSPredicate(format: "SELF MATCHES %@", "^(?=.*[a-z])(?=.*[$@$#!%*?&])[A-Za-z\\d$@$#!%*?&]{8,}")
        return passwordTest.evaluate(with: password)
    }
    
    // Check if email matches regex pattern
    static func isEmailValid(_ email : String) -> Bool {
       let regularExpressionForEmail = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
       let testEmail = NSPredicate(format:"SELF MATCHES %@", regularExpressionForEmail)
       return testEmail.evaluate(with: email)
    }
    
    // Display error messages to user
    static func showError(_ message:String,_ errorLabel:UILabel) {
        errorLabel.text = message
        errorLabel.alpha = 1
        errorLabel.adjustsFontSizeToFitWidth = true
    }
}
