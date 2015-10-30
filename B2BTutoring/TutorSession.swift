//
//  TutorSession.swift
//  B2BTutoring
//
//  Created by yingjun on 15/10/30.
//  Copyright © 2015年 Team 1. All rights reserved.
//

import Foundation

class TutorSession {
    class Entry {
        let image : String
        let title : String
        let category : String
        let tag : String
        let location : String
        let time : String
        let capacity : String
        let rating : String
        init(im : String, tit : String, cat : String, ta : String, loc : String, ti : String, cap : String, rat : String) {
            self.image = im;
            self.title = tit;
            self.category = cat;
            self.tag = ta;
            self.location = loc;
            self.time = ti;
            self.capacity = cap;
            self.rating = rat;
        }
    }
    
    let info = [
        Entry(im: "darth_vader", tit: "Kill People", cat : "Other", ta : "#funny", loc : "10m", ti : "July 11, 10am", cap : "2/10", rat : "☆4.9")
    ]
}