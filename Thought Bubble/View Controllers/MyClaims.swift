//
//  MyClaims.swift
//  Thought Bubble
//
//  Created by Aria Kalforian on 4/16/20.
//  Copyright © 2020 Aria Kalforian. All rights reserved.
//

import UIKit
import Firebase

class MyClaims: UIViewController {
    let db = Firestore.firestore()
    let uid = Auth.auth().currentUser!.uid // uid of currently logged in user
    var tableViewPost: UITableView!
    var posts = [Post]()
            
    func getPostCount() {
        
        // Design
        view.backgroundColor = .white
        self.navigationItem.title = "My Claims"
        let textAttributes = [NSAttributedString.Key.foregroundColor:UIColor.white, NSAttributedString.Key.font: UIFont(name: "HelveticaNeue", size: 24)!]
           navigationController?.navigationBar.titleTextAttributes = textAttributes
        
        db.collection("posts").getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting total number of posts: \(err)")
            } else {
                // Get each post from database - to fill feed
                for document in querySnapshot!.documents {
                    let uidNew = document.get("uid") as? String ?? ""
                    if (uidNew == self.uid) {
                        let questionText = document.get("questionText") as? String ?? ""
                        let agreeCount = document.get("agreeCount") as? Int ?? 0
                        let disagreeCount = document.get("disagreeCount") as? Int ?? 0
                        let voteCount = agreeCount+disagreeCount
                        self.posts.append(Post(uid:uidNew, questionText:questionText, agreeCount:agreeCount, disagreeCount:disagreeCount, voteCount:voteCount))
                    }
                }
                self.view.addSubview(self.tableViewPost)
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        getPostCount()

        tableViewPost = UITableView(frame: view.bounds, style: .plain)
        
        let cellNib = UINib(nibName: "PostTableViewCell", bundle: nil)
        tableViewPost.register(cellNib, forCellReuseIdentifier: "postCell")
    
        // Design
        tableViewPost.rowHeight = 200  // UITableView.automaticDimension
        tableViewPost.estimatedRowHeight = 200
        tableViewPost.tableFooterView = UIView()
        tableViewPost.separatorStyle = UITableViewCell.SeparatorStyle.none
        
        tableViewPost.delegate = self
        tableViewPost.dataSource = self
        tableViewPost.reloadData()
    }
}

extension MyClaims: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "postCell", for: indexPath) as! PostTableViewCell
        cell.set(post: posts[indexPath.row])
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("Question clicked")
    }
}
