//
//  UserSave.swift
//  game2
//
//  Created by nju on 16/7/7.
//  Copyright © 2016年 NJU. All rights reserved.
//

import Foundation

class UserSave: NSObject, NSCoding{
    var score: Int
    
    init(Score: Int){
        self.score = Score
    }
    
    required init(coder: NSCoder){
        self.score = coder.decodeObjectForKey("score") as! Int;
        super.init()
    }
    
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(self.score, forKey: "score")
    }
}