//
//  rubric.swift
//  TA Geni
//
//  Created by John Young on 3/30/19.
//  Copyright © 2019 John Young. All rights reserved.
//

import Foundation
import RealmSwift

class Rubric: Object {
    @objc dynamic var rubricTitle: String = "Scoring Rubric"
    @objc dynamic var rubricDescription: String = "Class participation contribution level."
    @objc dynamic var rubricCourseName: String = ""
    @objc dynamic var rubricActionTitle1: String = "Actively and Regularly"
    @objc dynamic var rubricActionTitle2: String = "Voluntarily"
    @objc dynamic var rubricActionTitle3: String = "Few"
    @objc dynamic var rubricActionTitle4: String = "Rarely"
    @objc dynamic var rubricActionTitle5: String = "Absent or Does Not"
    
    let  rubricParentCourse = LinkingObjects(fromType: Course.self, property: "rubricList")
}
