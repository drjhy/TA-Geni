//
//  courses.swift
//  TA Geni
//
//  Created by John Young on 2/15/19.
//  Copyright © 2019 John Young. All rights reserved.
//

import Foundation
import RealmSwift

class Course: Object {
    @objc dynamic var name: String = ""
    let students = List<Student>()
}
