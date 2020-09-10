//
//  StatsViewController.swift
//  Thought Bubble
//
//  Created by Aria Kalforian on 3/4/20.
//  Copyright © 2020 Aria Kalforian. All rights reserved.
//

import UIKit
import Firebase

class StatsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var tableView: UITableView!
    
    let db = Firestore.firestore()
    let uid = Auth.auth().currentUser!.uid 
    
    var postsMAgreed = [Post]()
    var postsMDisagreed = [Post]()
    var postsControversial = [Post]()
    
    var agreePercentage = 0
    var disagreePercentage = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getPosts()
        
        // View Design
        view.backgroundColor = .white
        self.navigationItem.title = "Statistics"
        let textAttributes = [NSAttributedString.Key.foregroundColor:UIColor.white, NSAttributedString.Key.font: UIFont(name: "HelveticaNeue", size: 24)!]
           navigationController?.navigationBar.titleTextAttributes = textAttributes
        
        // Segmented Control Text Color
        segmentedControl.setTitleTextAttributes([.foregroundColor: UIColor.white, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 15, weight: .regular)], for: .normal)
        segmentedControl.setTitleTextAttributes([.foregroundColor: Colors.darkBlue, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 15, weight: .regular)], for: .selected)
        
        // Add cells to tableview
        let cellNib = UINib(nibName: "PostTableViewCell", bundle: nil)
        tableView.register(cellNib, forCellReuseIdentifier: "Cell")
        
        // Table Design
        tableView.rowHeight = 200  // UITableView.automaticDimension
        tableView.estimatedRowHeight = 200
        tableView.tableFooterView = UIView()
        tableView.separatorStyle = UITableViewCell.SeparatorStyle.none
            
        tableView.delegate = self
        tableView.dataSource = self
        
        // Segmented Control Design
        segmentedControl.layer.cornerRadius = 0.0;
    }
    
    // Fetch and fill post arrays according to percentage stats
    func getPosts() {
        db.collection("posts").getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting total number of posts: \(err)")
            } else {
                // Get each post from database - to fill feed
                for document in querySnapshot!.documents {
                    let uidNew = document.get("uid") as? String ?? ""
                    let questionText = document.get("questionText") as? String ?? ""
                    let agreeCount = document.get("agreeCount") as? Int ?? 0
                    let disagreeCount = document.get("disagreeCount") as? Int ?? 0
                    let voteCount = agreeCount+disagreeCount
                     
                    if(voteCount != 0) {
                        self.agreePercentage = (agreeCount*100)/voteCount
                        self.disagreePercentage = (disagreeCount*100)/voteCount
                    } else {
                        self.agreePercentage = 0
                        self.disagreePercentage = 0
                    }
                     
                    if (self.agreePercentage >= 75) { // Mostly Agreed
                        self.postsMAgreed.append(Post(uid:uidNew, questionText:questionText, agreeCount:agreeCount, disagreeCount:disagreeCount, voteCount:voteCount))
                    } else if (self.disagreePercentage >= 75) { // Mostly Disagreed
                        self.postsMDisagreed.append(Post(uid:uidNew, questionText:questionText, agreeCount:agreeCount, disagreeCount:disagreeCount, voteCount:voteCount))
                    } else { // Controversial
                        self.postsControversial.append(Post(uid:uidNew, questionText:questionText, agreeCount:agreeCount, disagreeCount:disagreeCount, voteCount:voteCount))
                    }
                }
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch segmentedControl.selectedSegmentIndex {
        case 0:
            return postsMAgreed.count
        case 1:
            return postsControversial.count
        case 2:
            return postsMDisagreed.count
        default:
            break
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! PostTableViewCell
                
        switch segmentedControl.selectedSegmentIndex {
        case 0:
            cell.set(post: postsMAgreed[indexPath.row])
        case 1:
            cell.set(post: postsControversial[indexPath.row])
        case 2:
            cell.set(post: postsMDisagreed[indexPath.row])
        default:
            break
        }
        return cell
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        segmentedControl.layer.cornerRadius = segmentedControl.frame.width / 2.0
    }
    
    @IBAction func segmentedChange(_ sender: UISegmentedControl) {
        tableView.reloadData()
    }
}

