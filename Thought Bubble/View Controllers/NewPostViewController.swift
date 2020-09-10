//
//  NewPostViewController.swift
//  Thought Bubble
//
//  Created by Aria Kalforian on 3/5/20.
//  Copyright © 2020 Aria Kalforian. All rights reserved.
//

import UIKit
import Firebase

class NewPostViewController: UIViewController {
    let uid = Auth.auth().currentUser!.uid

    // Textview to type potential post
    let newPost = UITextView(frame: CGRect(x: 10, y: 100, width: UIScreen.main.bounds.width - 20.0, height: UIScreen.main.bounds.height))
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setUpNavBar()
    }
    
    func setUpNavBar() {
        // Title
        self.navigationItem.title = "New Post";
        let textAttributes = [NSAttributedString.Key.foregroundColor:UIColor.white, NSAttributedString.Key.font: UIFont(name: "HelveticaNeue", size: 24)!]
        navigationController?.navigationBar.titleTextAttributes = textAttributes
        
        // Textfield Design
        newPost.keyboardType = UIKeyboardType.default
        newPost.textColor = .white
        newPost.backgroundColor = Colors.darkBlue
        newPost.textAlignment = .left
        self.view.addSubview(newPost)
    
        // Post button
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Post", style: .plain, target: self, action:
            #selector(postTapped))
        
        // Cancel button
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelTapped))
    }
    
    @objc func postTapped() {
        print("Post tapped")
        
        let db = Firestore.firestore()
        db.collection("posts").addDocument(data: ["questionText":newPost.text!, "uid":uid, "agreeCount":0, "disagreeCount":0,"agreedUsers":[], "disagreedUsers":[]])
        
        transitionToHome()
    }
    
    @objc func cancelTapped() {
        print("Cancel tapped")
        transitionToHome()
    }
    
    func transitionToHome() {
        let homeViewController = storyboard?.instantiateViewController(identifier: "mainTabBar") as! UITabBarController
        
        view.window?.rootViewController = homeViewController
        view.window?.makeKeyAndVisible()
    }
}
