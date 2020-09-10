//
//  PostTableViewCell.swift
//  Thought Bubble
//
//  Created by Aria Kalforian on 5/2/20.
//  Copyright © 2020 Aria Kalforian. All rights reserved.
//

import UIKit
import Firebase

class PostTableViewCell: UITableViewCell {
    let uid = Auth.auth().currentUser!.uid
    let db = Firestore.firestore()
    var documentID = ""
    var agreeCount = 0
    var disagreeCount = 0

    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet weak var voteCountLabel: UILabel!
    @IBOutlet weak var disagreeButton: UIButton!
    @IBOutlet weak var agreeButton: UIButton!
    
    var agreePercentage = 0
    var disagreePercentage = 0
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func alertUpdate(message: String, type: String){
        // Alert user that passwords do not match
        let alertController = UIAlertController(title: type, message: message, preferredStyle: .alert)
        let OKAction = UIAlertAction(title: "OK", style: .default) { (action:UIAlertAction!) in
            print("Ok button tapped");
        }
        alertController.addAction(OKAction)
        UIApplication.shared.windows.filter {$0.isKeyWindow}.first?.rootViewController?.present(alertController, animated: true, completion: nil)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func set(post:Post) {
        //Button design
        agreeButton.layer.cornerRadius = 15.0
        disagreeButton.layer.cornerRadius = 15.0
        
        questionLabel.text = post.questionText
        voteCountLabel.text = String(post.voteCount) + " votes"
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
    }
    
    func disableVote() {
        agreeButton.setTitle(String(agreePercentage) + "% Agree" , for: .normal)
        disagreeButton.setTitle(String(disagreePercentage) + "% Disgree" , for: .normal)
                        
        agreeButton.isEnabled = false
        disagreeButton.isEnabled = false
        agreeButton.setTitleColor(Colors.darkBlue, for: .disabled)
        disagreeButton.setTitleColor(Colors.darkBlue, for: .disabled)
    }
    
    @IBAction func agreeTapped(_ sender: UIButton) {
        disableVote()
        
        // Increment the agreeCount value in database only if user has not yet voted
        db.collection("posts").document(documentID).getDocument { document, error in
            if let document = document {
                let agreedUsers = (document["agreedUsers"] as? [String])
                let disagreedUsers = (document["disagreedUsers"] as? [String])
                if (agreedUsers?.contains(self.uid) == false) && (disagreedUsers?.contains(self.uid) == false) { // Not voted
                self.db.collection("posts").document(self.documentID).updateData(["agreeCount":self.agreeCount+1])
                self.db.collection("posts").document(self.documentID).updateData([
                          "agreedUsers": FieldValue.arrayUnion([self.uid])])
                    
                    // Update displayed values
                    let newVoteCount = (self.agreeCount+1)+self.disagreeCount
                    self.voteCountLabel.text = String(newVoteCount) + " votes"
                    
                    let newAgreePercentage = ((self.agreeCount+1)*100)/(newVoteCount)
                    let newDisagreePercentage = 100-newAgreePercentage
                    self.agreeButton.setTitle(String(newAgreePercentage) + "% Agree" , for: .normal)
                    self.disagreeButton.setTitle(String(newDisagreePercentage) + "% Disgree" , for: .normal)
    
                } else { // Voted
                    self.alertUpdate(message: "You had already voted before, so this vote won't be counted!", type: "Note")
                }
            }
        }
    }
    
    @IBAction func disagreeTapped(_ sender: UIButton) {
        disableVote()
        
        // Increment the disagreeCount value in database only if user has not yet voted
        db.collection("posts").document(documentID).getDocument { document, error in
            if let document = document {
                let agreedUsers = (document["agreedUsers"] as? [String])
                let disagreedUsers = (document["disagreedUsers"] as? [String])
                if (agreedUsers?.contains(self.uid) == false) && (disagreedUsers?.contains(self.uid) == false)  { // Not voted
                self.db.collection("posts").document(self.documentID).updateData(["disagreeCount":self.disagreeCount+1])
                self.db.collection("posts").document(self.documentID).updateData([
                        "disagreedUsers": FieldValue.arrayUnion([self.uid])])
                
                    // Update displayed values
                    let newVoteCount = (self.disagreeCount+1)+self.agreeCount
                    self.voteCountLabel.text = String(newVoteCount) + " votes"
                    
                    let newDisagreePercentage = ((self.disagreeCount+1)*100)/(newVoteCount)
                    let newAgreePercentage = 100-newDisagreePercentage
                    self.agreeButton.setTitle(String(newAgreePercentage) + "% Agree" , for: .normal)
                    self.disagreeButton.setTitle(String(newDisagreePercentage) + "% Disgree" , for: .normal)
                    
                } else { // Voted
                    self.alertUpdate(message: "You had already voted before, so this vote won't be counted!", type: "Note")
                }
            }
        }
    }
}
