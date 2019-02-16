//
//  StudentViewController.swift
//  TA Geni
//
//  Created by John Young on 2/15/19.
//  Copyright © 2019 John Young. All rights reserved.
//

import UIKit
import RealmSwift


class StudentViewController: UITableViewController {

    let realm = try! Realm()
    
    var students: Results<Student>?
    
    var selectedCourse : Course?{
        
        didSet{
            
            loadStudents()
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }

    
    //MARK - Tableview Datasource Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return students?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "StudentCell", for: indexPath)
        
        if let student = students?[indexPath.row] {
            
            cell.textLabel?.text = student.name
            
            // Ternary operator ==>
            
        } else {
            
            cell.textLabel?.text = "No Students Added..."
            
        }
        
        return cell
    }
    // MARK - Tableview Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

//        if let student = students? [indexPath.row] {
//
//            do {
//                try realm.write {
//                    item.done = !item.done
//                }
//
//            } catch {
//                print("Error saving done status, \(error)")
//            }
//
//        }
//
//        tableView.reloadData()
//
//        tableView.deselectRow(at: indexPath, animated: true)

    }

       //MARK -- ADD NEW ITEM
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
    
    
     var textField = UITextField()
            
    let alert = UIAlertController(title: "Add New Student", message: "", preferredStyle: .alert)
            
            let  action = UIAlertAction(title: "Add Student", style: .default) { (action) in
                
                
                if let currentCourse = self.selectedCourse {
                    
                    do {
                        try self.realm.write {
                            
                            let  newStudent  = Student()
                            newStudent.name = textField.text!
                            newStudent.score =
                            newStudent.tagArray = textField.text!
                            newStudent.dateCreated = Date()
                            currentCourse.students.append(newStudent)
                        }
                    } catch {
                        print("Error saving context \(error)")
                    }
                    self.tableView.reloadData()
                }
                
            }
            
            alert.addTextField { (alertTextField) in
                alertTextField.placeholder = "Create new item"
                textField  = alertTextField
            }
            
            alert.addAction(action)
            
            self.present(alert, animated: true, completion: nil)
        }
        
        func loadStudents() {
            
            students = selectedCourse?.students.sorted(byKeyPath: "name", ascending: true)
            
            tableView.reloadData()
        }
        
    }
    
    
    // MARK -- Search bar methods
    
    extension StudentViewController: UISearchBarDelegate {
        
        func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
            
            students = students?.filter("name CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "dateCreated", ascending: true)
            
            tableView.reloadData()
        }
        
        func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
            if searchBar.text?.count == 0 {
                loadStudents()
                
                DispatchQueue.main.async {
                    searchBar.resignFirstResponder()
                }
            }
        }
}

