//
//  MassUploadViewController.swift
//  TA Geni
//
//  Created by John Young on 4/12/19.
//  Copyright © 2019 John Young. All rights reserved.
//

import UIKit
import RealmSwift
import ChameleonFramework

class MassUploadViewController: UIViewController {

    let realm = try! Realm()
    var selectedCourse : Course?
    var students: Results<Student>?
    
    @IBOutlet weak var studentUpload: UITextField!
    
    @IBAction func uploadStudents(_ segue: UIStoryboardSegue) {
        
        let stringNames = studentUpload?.text!
        
        let result = stringNames?.components(separatedBy: ";")
    
        for i in result!.indices {
        
            let textField = result![i]
        
        if let currentCourse = self.selectedCourse {
            
            do {
                try self.realm.write {
                    
                    let  newStudent  = Student()
                    
                    newStudent.name = textField
                    newStudent.dateCreated = Date()
                    newStudent.studentCourseName = (self.selectedCourse?.name)!
                    currentCourse.studentList.append(newStudent)
                }
            } catch {
                print("Error saving context \(error)")
            }
        }
    }
   _ = navigationController?.popToRootViewController(animated: true)
}
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
}
    
    
