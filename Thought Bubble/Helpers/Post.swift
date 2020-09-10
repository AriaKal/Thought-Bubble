//
//  Post.swift
//  Thought Bubble
//
//  Created by Aria Kalforian on 5/3/20.
//  Copyright © 2020 Aria Kalforian. All rights reserved.
//

import Foundation

class Post {
    var uid:String
    var questionText:String
    var agreeCount:Int
    var disagreeCount:Int
    var voteCount:Int
    
    init(uid:String, questionText:String, agreeCount:Int, disagreeCount:Int, voteCount:Int) {
        self.uid = uid
        self.questionText = questionText
        self.agreeCount = agreeCount
        self.disagreeCount = disagreeCount
        self.voteCount = voteCount
    }
}
