//
//  StudentViewController.swift
//  TA Geni
//
//  Created by John Young on 2/15/19.
//  Copyright © 2019 John Young. All rights reserved.
//

import UIKit
import RealmSwift
import ChameleonFramework



class StudentViewController: SwipeTableViewController {

    
    let realm = try! Realm()
    var students: Results<Student>?
    var selectedStudent: Student?
    var selectedCourse : Course?{
        didSet{
            loadStudents()
        }
    }
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.separatorStyle = .none
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        title = selectedCourse?.name
        tableView.separatorStyle = .none
        guard let colourHex = selectedCourse?.Color else {   fatalError()}
        updateNavBar(withHexCode: colourHex)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        updateNavBar(withHexCode: "494ca2")
    }
    
    //    MARK: -  Nav Bar Setup Methods
    
    func updateNavBar(withHexCode colorHexCode:  String) {
        
        guard let navBar = navigationController?.navigationBar else {fatalError("Navigation controller does not exist.")}
        
        guard  let navBarColor = UIColor(hexString: colorHexCode) else {  fatalError()}
        
        navBar.barTintColor  = navBarColor
        
        navBar.tintColor = ContrastColorOf(navBarColor, returnFlat: true)
        
        navBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: ContrastColorOf(navBarColor, returnFlat: true)]
        
        searchBar.barTintColor = navBarColor
        
    }
    
    //MARK - Tableview Datasource Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return students?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        
        if let student = students?[indexPath.row] {
        
            cell.textLabel?.text = student.name
            
            if let studentColor = UIColor(hexString: selectedCourse!.Color)?.darken(byPercentage: (CGFloat(indexPath.row))/(CGFloat(students!.count))){
                
                cell.backgroundColor = studentColor
                cell.textLabel?.textColor = ContrastColorOf(studentColor, returnFlat: true)
                cell.accessoryType = .detailDisclosureButton
            }
       
        } else {
            
            cell.textLabel?.text = "No Students Added..."
            
        }
        
        return cell
    }
 
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "reuseIdentifier" {
        
                let controller = segue.destination as! StudentListViewController
                controller.selectedCourse = self.selectedCourse
            }
    }
    
    // MARK - Tableview Delegate Methods
    
    override func updateModel(at indexPath: IndexPath) {
        
        if let studentForDeletion = self.students?[indexPath.row]{
            
            do  {
                try self.realm.write {
                    self.realm.delete(studentForDeletion)
                }
            }  catch {
                print("Error deleting item, \(error)")
                
            }
        }
    }
    
       //MARK -- ADD NEW ITEM
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
    
    
     var textField = UITextField()
            
    let alert = UIAlertController(title: "Add New Student", message: "", preferredStyle: .alert)
            
            let  action = UIAlertAction(title: "Add", style: .default) { (action) in
                
                
                if let currentCourse = self.selectedCourse {
                    
                    do {
                        try self.realm.write {
                            
                            let  newStudent  = Student()
                            
                            newStudent.name = textField.text!
                            newStudent.dateCreated = Date()
                            newStudent.studentCourseName = (self.selectedCourse?.name)!
                            currentCourse.studentList.append(newStudent)
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
            
        // Cancel button
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (action:UIAlertAction!) in
            print("Cancel button tapped");
        }
        alert.addAction(cancelAction)
        
        // Present Dialog message
        present(alert, animated: true, completion:nil)
        
        }
        
        func loadStudents() {
            
            students = selectedCourse?.studentList.sorted(byKeyPath: "name", ascending: true)
            
            tableView.reloadData()
        }
        

    // MARK: - ALERT CONTROLLER WITH MULTIPLE BUTTONS & SOME RESTYLING
    
    override func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {
        
        if let studentForRubric = self.students?[indexPath.row].studentID{
        
            fireAlert(studentID: studentForRubric as AnyObject)
        }}
    
    @IBAction func fireAlert(studentID: AnyObject) {
        
        let id = String(describing: studentID)
        
        let alert = UIAlertController(title: "",
                                          message: "",
                                          preferredStyle: .alert)

    // Change font of the title and message
    let titleFont:[String : AnyObject] = [ convertFromNSAttributedStringKey(NSAttributedString.Key.font) : UIFont(name: "HelveticaNeue-Bold", size: 18)! ]
    let messageFont:[String : AnyObject] = [ convertFromNSAttributedStringKey(NSAttributedString.Key.font) : UIFont(name: "HelveticaNeue-Thin", size: 14)! ]
    let attributedTitle = NSMutableAttributedString(string: "Scoring Rubric", attributes: convertToOptionalNSAttributedStringKeyDictionary(titleFont))
    let attributedMessage = NSMutableAttributedString(string: "Class participation contribution level.", attributes: convertToOptionalNSAttributedStringKeyDictionary(messageFont))
    alert.setValue(attributedTitle, forKey: "attributedTitle")
    alert.setValue(attributedMessage, forKey: "attributedMessage")


    let action1 = UIAlertAction(title: "Actively and Regularly", style: .default, handler: { (action) -> Void in
        let realm = try! Realm()
        let predicate = NSPredicate(format: "studentID == %@", id)
        let theStudent = realm.objects(Student.self).filter(predicate).first
        try! realm.write {
            theStudent?.score = "5"
        }
        })

    let action2 = UIAlertAction(title: "Voluntarily", style: .default, handler: { (action) -> Void in
        let realm = try! Realm()
        let predicate = NSPredicate(format: "studentID == %@", id)
        let theStudent = realm.objects(Student.self).filter(predicate).first
        try! realm.write {
            theStudent?.score = "3"
        }
    })

    let action3 = UIAlertAction(title: "Few", style: .default, handler: { (action) -> Void in
        let realm = try! Realm()
        let predicate = NSPredicate(format: "studentID == %@", id)
        let theStudent = realm.objects(Student.self).filter(predicate).first
        try! realm.write {
            theStudent?.score = "2"
        }
    })
    let action4 = UIAlertAction(title: "Absent or Does Not", style: .default, handler: { (action) -> Void in
        let realm = try! Realm()
        let predicate = NSPredicate(format: "studentID == %@", id)
        let theStudent = realm.objects(Student.self).filter(predicate).first
        try! realm.write {
            theStudent?.score = "0"
        }
    })

    // Cancel button
    let cancel = UIAlertAction(title: "Cancel", style: .destructive, handler: { (action) -> Void in })

    // Restyle the view of the Alert
    alert.view.tintColor = UIColor.orange  // change text color of the buttons
    alert.view.backgroundColor = UIColor.clear  // change background color
    alert.view.layer.cornerRadius = 25   // change corner radius


    // Add action buttons and present the Alert
    alert.addAction(action1)
    alert.addAction(action2)
    alert.addAction(action3)
    alert.addAction(action4)
    alert.addAction(cancel)
    present(alert, animated: true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
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

//// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromNSAttributedStringKey(_ input: NSAttributedString.Key) -> String {
    return input.rawValue
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertToOptionalNSAttributedStringKeyDictionary(_ input: [String: Any]?) -> [NSAttributedString.Key: Any]? {
    guard let input = input else { return nil }
    return Dictionary(uniqueKeysWithValues: input.map { key, value in (NSAttributedString.Key(rawValue: key), value)})
}




