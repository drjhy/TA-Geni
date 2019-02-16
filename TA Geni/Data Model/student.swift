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
    @objc dynamic var name: String = ""
    @objc dynamic var score: Int = 0
    @objc dynamic var tagArray: Array = ["Quiz", "Participation" ]
    @objc dynamic var dateCreated: Date?
    var  parentCourse = LinkingObjects(fromType: Course.self, property: "students")
}
