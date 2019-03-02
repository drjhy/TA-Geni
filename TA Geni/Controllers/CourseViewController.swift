//
//  ViewController.swift
//  TA Geni
//
//  Created by John Young on 2/15/19.
//  Copyright © 2019 John Young. All rights reserved.
//

import UIKit
import RealmSwift
import ChameleonFramework



class CourseListViewController: SwipeTableViewController {

    let realm = try! Realm()
    
    var courseArray: Results<Course>?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        loadCourse()
    }
    
 
    override func viewWillDisappear(_ animated: Bool) {
        
        loadCourse()
        
    }
    //MARK -- TableView Datasource Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return courseArray?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        
        if let course = courseArray?[indexPath.row]{
            
            cell.textLabel?.text = course.name
            
            guard let courseColor = UIColor(hexString: course.Color) else {fatalError()}
            
            cell.backgroundColor = courseColor
            
            cell.textLabel?.textColor =  ContrastColorOf(courseColor, returnFlat: true)
            
        }
        
        return cell
        
    }
    
    
    //MARK -- TableView Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        performSegue(withIdentifier: "goToStudent", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! StudentViewController
        
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.selectedCourse = courseArray?[indexPath.row]
        }
    }
    
    //MARK -- Data Manipulation Methods
    
    func save(course: Course) {
        
        do {
            
            try realm.write {
                realm.add(course)
            }
            
        } catch {
            
            print("Error saving context \(error)")
        }
        
        self.tableView.reloadData()
    }
    
    func loadCourse () {
        
        courseArray = realm.objects(Course.self)
        
        tableView.reloadData()
       
    }
    
    //    MARK: - Delete Data From Swipe
    
    override func updateModel(at indexPath: IndexPath) {
        
        if let courseForDeletion = self.courseArray?[indexPath.row]{
            
            do{
                try self.realm.write {
                    self.realm.delete(courseForDeletion)
                }
            } catch {
                print("Error deleting course, \(error)")
            }
        }
    }
    
      //MARK -- Add New Categories
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
    
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Course", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add", style: .default) { (action) in
            
            let newCourse = Course()
            newCourse.name = textField.text!
            newCourse.Color = UIColor.randomFlat.hexValue()
            
            self.save(course: newCourse)
            
        }
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new course"
            textField = alertTextField
        }
        
        alert.addAction(action)
        
        // Cancel button
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (action:UIAlertAction!) in
            print("Cancel button tapped");
        }
        alert.addAction(cancelAction)
        
        // Present Dialog message
        present(alert, animated: true, completion:nil)
        
        
    }
    
    
}
    


