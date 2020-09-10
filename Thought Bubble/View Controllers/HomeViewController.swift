//
//  HomeViewController.swift
//  Thought Bubble
//
//  Created by Aria Kalforian on 2/2/20.
//  Copyright © 2020 Aria Kalforian. All rights reserved.
//

import UIKit
import Firebase

class HomeViewController: CustomViewController {
    
    var tableViewPost: UITableView!
    var posts = [Post]()
       
    var searching = false
    var searchPosts = [Post]()
            
    func getPostCount() {
        db.collection("posts").getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting total number of posts: \(err)")
            } else {
                // Get each post from database - to fill feed
                for document in querySnapshot!.documents {
                    let uid = document.get("uid") as? String ?? ""
                    let questionText = document.get("questionText") as? String ?? ""
                    let agreeCount = document.get("agreeCount") as? Int ?? 0
                    let disagreeCount = document.get("disagreeCount") as? Int ?? 0
                    let voteCount = agreeCount+disagreeCount
                    self.posts.append(Post(uid:uid, questionText:questionText, agreeCount:agreeCount, disagreeCount:disagreeCount, voteCount:voteCount))
                }
                self.view.addSubview(self.tableViewPost)
            }
        }
    }

    override func viewDidLoad() {
        
        // Design
        self.navigationItem.title = "Thought Bubble"
        let textAttributes = [NSAttributedString.Key.foregroundColor:UIColor.white, NSAttributedString.Key.font: UIFont(name: "HelveticaNeue", size: 24)!]
           navigationController?.navigationBar.titleTextAttributes = textAttributes
        
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
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if (searchText.isEmpty) {
            searching = false
            tableViewPost.reloadData()
        }
        else {
            searching = true
            searchPosts = posts.filter({$0.questionText.lowercased().contains(searchText.lowercased())})
            tableViewPost.reloadData()
        }
    }
    
    // Tapping on the menu button
    @objc override func menuButtonTapped() {
        UIView.animate(withDuration: 0.3, animations: {
            self.sideMenuWidth?.isActive = false
    
            if(self.menuShowing) {
                self.sideMenuWidth = self.sideMenu.widthAnchor.constraint(equalToConstant: 0)
                //blurEffectView.removeFromSuperview()
                
                for view in self.tableViewPost.subviews {
                     if view is UIVisualEffectView {
                        view.removeFromSuperview()
                    }
                }
                
            } else {
                self.view.bringSubviewToFront(self.sideMenu)
                
                // Blur effect
                let blurEffect = UIBlurEffect(style: UIBlurEffect.Style.dark)
                let blurEffectView = UIVisualEffectView(effect: blurEffect)
                blurEffectView.frame = self.tableViewPost.bounds
                blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
                self.tableViewPost.addSubview(blurEffectView)
                
                self.sideMenuWidth = self.sideMenu.widthAnchor.constraint(equalToConstant: 350)
            }
            
            self.sideMenuWidth?.isActive = true
            self.view.layoutIfNeeded()
        })
        menuShowing = !menuShowing
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == tableViewPost {
            if searching {
                return searchPosts.count
            } else {
                return posts.count
            }
        } else {
            return menuItemsArray.count
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == self.tableViewPost {
            let cell = tableView.dequeueReusableCell(withIdentifier: "postCell", for: indexPath) as! PostTableViewCell
            
            if searching {
                cell.set(post: searchPosts[indexPath.row])
            } else {
                cell.set(post: posts[indexPath.row])
            }
            
            return cell
        } else {
            let cell = sideMenu.dequeueReusableCell(withIdentifier: cellID, for: indexPath) as UITableViewCell
            let menuItems = menuItemsArray[indexPath.row]
                
            // Customize the look of the cells
            cell.backgroundColor = Colors.darkBlue.withAlphaComponent(0)
            cell.textLabel?.text = menuItems
            cell.textLabel?.textColor = .white
            cell.textLabel?.adjustsFontSizeToFitWidth = true
                
            let myCustomSelectionColorView = UIView()
            myCustomSelectionColorView.backgroundColor = Colors.darkBlue.withAlphaComponent(0.75)
            cell.selectedBackgroundView = myCustomSelectionColorView
                
            // Customize first row different from rest
            switch (indexPath.section, indexPath.row) {
                case (0, 0):
                    cell.textLabel?.font = UIFont.systemFont(ofSize: 40)
                    cell.textLabel?.textAlignment = .center
                    cell.selectionStyle = .none
                    
                let separator = UILabel(frame: CGRect(x: 15, y: cell.frame.size.height * 2, width: cell.frame.size.width, height: 1))
                separator.backgroundColor = .white
                cell.contentView.addSubview(separator)
                    
                default:
                    cell.textLabel?.font = UIFont.systemFont(ofSize: 25)
            }
            return cell
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if(tableView == self.tableViewPost) {
            print("Question clicked")
        } else {
            let firebaseAuth = Auth.auth()
                
            if(indexPath.row == 4) { // Logout
                do {
                    try firebaseAuth.signOut()

                    // Go back to login-signup view
                    let launchViewController = storyboard?.instantiateViewController(identifier: "launchView")
                        
                    // Animate transition
                    let transition = CATransition()
                    transition.type = .fade
                    transition.duration = 0.15
                    view.window?.layer.add(transition, forKey: kCATransition)
                    view.window?.rootViewController = launchViewController
                    view.window?.makeKeyAndVisible()
            
                } catch let signOutError as NSError {
                          print ("Error signing out: %@", signOutError)
                }
            } else if (indexPath.row == 3) { // Help Center
                let helpCenter = HelpCenter()
                navigationController?.pushViewController(helpCenter, animated: false)
            } else if (indexPath.row == 2) { // User Profile
                let userProfile = UserProfile()
                navigationController?.pushViewController(userProfile, animated: false)
            } else if (indexPath.row == 1) { // My Claims
                let myClaims = MyClaims()
                navigationController?.pushViewController(myClaims, animated: false)
            }
        }
    }
    
}
