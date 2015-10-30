//
//  Profile.swift
//  B2BTutoring
//
//  Created by yingjun on 15/10/29.
//  Copyright © 2015年 Team 1. All rights reserved.
//

import Foundation

class Profile {
    class Entry {
        let key : String
        let value : String
        init(k : String, v : String) {
            self.key = k;
            self.value = v;
        }
    }

    let info = [
        Entry(k: "Name", v: "Darth Vader"),
        Entry(k: "Gender", v: "Male"),
        Entry(k: "Age", v: "3"),
        Entry(k: "Email", v: "DarthVader@gmail.com"),
        Entry(k: "Phone", v: "xxx-xxx-xxxx"),
        Entry(k: "Interest", v: "#killPeople"),
        Entry(k: "Discription", v: "I am your father")
    ]
}