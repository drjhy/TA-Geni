//
//  StudentListViewController.swift
//  
//
//  Created by John Young on 2/28/19.
//

import UIKit
import RealmSwift

class StudentListViewController: UITableViewController {




    var Name = [String]()
    var Score = [String]()

    override func viewDidLoad() {
        super.viewDidLoad()

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
        let realm = try! Realm()

        let allStudents = realm.objects(Student.self)

        let byStudent = allStudents.sorted(byKeyPath: "name", ascending: false)

        for student in byStudent{
            Name.append(student.name)
            Score.append(student.score)
            print("\(student.name) is \(student.score) class participation")

            tableView.reloadData()
        }

    }


override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell : StudentListTableViewCell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath) as! StudentListTableViewCell

    cell.nameLabel.text = Name[indexPath.row]
    cell.scoreLabel.text = Score[indexPath.row]

//         Configure the cell...

        return cell
    }


}



