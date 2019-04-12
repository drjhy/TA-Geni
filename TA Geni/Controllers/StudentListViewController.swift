//
//  StudentListViewController.swift
//  
//
//  Created by John Young on 2/28/19.
//

import UIKit
import RealmSwift
import ChameleonFramework

class StudentListViewController: UITableViewController {

    let realm = try! Realm()
    var students: Results<Student>?
    var selectedCourse : Course?

    var Name = [String]()
    var Score = [String]()
    var graded: Bool = false
    var StudentID = [String]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        
        tableView.separatorColor = UIColor.flatGreen
        view.backgroundColor = UIColor(red:0.96, green:0.98, blue:0.96, alpha:1.0)
        
    

    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    
        queryStudents()
        
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return Name.count
    }

    func queryStudents(){

        let allStudents = realm.objects(Student.self).filter("studentCourseName == %@", self.selectedCourse?.name as Any)
        
        let byStudent = allStudents.sorted(byKeyPath: "name", ascending: true)
        
        for student in byStudent{
            Name.append(student.name)
            Score.append(student.score)
            StudentID.append(student.studentID)
            tableView.reloadData()
            }
    }


override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell : StudentListTableViewCell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath) as! StudentListTableViewCell
    
    cell.nameLabel.text = Name[indexPath.row]
    cell.scoreLabel.text = Score[indexPath.row]
    
        return cell
    }

    
    
    @IBAction func resetRubric(_ sender: Any) {
    
        resetScores()
    }

    func resetScores(){
        
        let allStudents = realm.objects(Student.self).filter("studentCourseName == %@", self.selectedCourse?.name as Any)
    
        let byStudent = allStudents.sorted(byKeyPath: "studentID", ascending: true)
        
        for student in byStudent{

            let realm = try! Realm()
            let predicate = NSPredicate(format: "studentID == %@", student.studentID)
            let theStudent = realm.objects(Student.self).filter(predicate).first
            try! realm.write {
                theStudent?.score = ""
                theStudent?.Graded = false
            }
        }
            _ = navigationController?.popToRootViewController(animated: true)
    }
    

    
    
    
    
    
    
    
}


