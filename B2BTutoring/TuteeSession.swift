//
//  TuteeSession.swift
//  B2BTutoring
//
//  Created by yingjun on 15/10/30.
//  Copyright © 2015年 Team 1. All rights reserved.
//

import Foundation

class TuteeSession {
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
        Entry(im: "starwar", tit: "Basketball Expert", cat : "Sports", ta : "#basketball #sports", loc : "500m", ti : "May 6, 10am", cap : "2/5", rat : "☆4.4"),
        Entry(im: "starwar", tit: "Home Decor Hacks", cat : "Decoration", ta : "#home #decoration", loc : "100m", ti : "May 25, 13am", cap : "2/3", rat : "☆4.4"),
    ]
}