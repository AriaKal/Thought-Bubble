//
//  PostTableViewCellNoVote.swift
//  Thought Bubble
//
//  Created by Aria Kalforian on 5/24/20.
//  Copyright © 2020 Aria Kalforian. All rights reserved.
//

import UIKit
import Firebase

class PostTableViewCellNoVote: UITableViewCell {
    let uid = Auth.auth().currentUser!.uid
    let db = Firestore.firestore()
    var documentID = ""
    var agreeCount = 0
    var disagreeCount = 0

//    @IBOutlet weak var questionLabel: UILabel!
//    @IBOutlet weak var voteCountLabel: UILabel!
//    @IBOutlet weak var disagreeButton: UIButton!
//    @IBOutlet weak var agreeButton: UIButton!
    
    var agreePercentage = 0
    var disagreePercentage = 0
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func set(post:Post) {
        //Button design
//        agreeButton.layer.cornerRadius = 15.0
//        disagreeButton.layer.cornerRadius = 15.0
//
//        questionLabel.text = post.questionText
//        voteCountLabel.text = String(post.voteCount) + " votes"
        agreeCount = post.agreeCount
        disagreeCount = post.disagreeCount
        
        if(post.voteCount != 0) {
            agreePercentage = (agreeCount*100)/post.voteCount
            disagreePercentage = (disagreeCount*100)/post.voteCount
        }
        
        // Get document for post
        let query = db.collection("posts").whereField("questionText", isEqualTo: post.questionText)
        query.getDocuments { (querySnapshot, error) in
            for document in querySnapshot!.documents {
                self.documentID = document.documentID
            }
        }
        //setButtons()
    }
    
//    func setButtons() {
//        agreeButton.setTitle(String(agreePercentage) + "% Agree" , for: .normal)
//        disagreeButton.setTitle(String(disagreePercentage) + "% Disgree" , for: .normal)
//
//        agreeButton.isEnabled = false
//        disagreeButton.isEnabled = false
//        agreeButton.setTitleColor(Colors.darkBlue, for: .disabled)
//        disagreeButton.setTitleColor(Colors.darkBlue, for: .disabled)
//    }

}

