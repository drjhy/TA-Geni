//
//  student.swift
//  TA Geni
//
//  Created by John Young on 2/15/19.
//  Copyright © 2019 John Young. All rights reserved.
//

import Foundation
import RealmSwift

class Student: Object {
    @objc dynamic var studentID = UUID().uuidString
    @objc dynamic var name: String = ""
    @objc dynamic var score: String = "0"
    @objc dynamic var dateCreated: Date?
    
    @objc dynamic var studentCourseName: String = ""
    
    
    override static func primaryKey() -> String? {
        return "studentID"
    }
    
    let  parentCourse = LinkingObjects(fromType: Course.self, property: "studentList")
}

