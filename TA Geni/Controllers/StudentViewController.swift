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
    var rubrics: Results<Rubric>?
    var students: Results<Student>?
    var selectedRubric: Rubric?
    
    var testRubric = 1
    
    var rTitle:String? = ""
    var rDesc:String? = ""
    var rAction1:String? = ""
    var rAction2:String? = ""
    var rAction3:String? = ""
    var rAction4:String? = ""
    var rAction5:String? = ""
    
    var selectedCourse : Course?{
        didSet{
            loadStudents()
        }
    }
    
    enum SegueIdentifier: String {
        case SegueToScoreReportViewIdentifier = "goToScoreReport"
        case SegueToMassUploadViewIdentifier = "goToMassUpload"
    }
    
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.separatorStyle = .none
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setUpNavBar()
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setUpNavBar()
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        setUpNavBar()
    }
    //    MARK: -  Nav Bar Setup Methods
    
    func updateNavBar(withHexCode colorHexCode:  String) {
        
        guard let navBar = navigationController?.navigationBar else {fatalError("Navigation controller does not exist.")}
        
        guard  let navBarColor = UIColor(hexString: colorHexCode) else {  fatalError()}
        
        navBar.barTintColor  = navBarColor
        navBar.tintColor = ContrastColorOf(navBarColor, returnFlat: true)
        navBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: ContrastColorOf(navBarColor, returnFlat: true)]
        
        //MARK - Customizing SearchBar
        searchBar.layer.borderWidth = 1
        searchBar.layer.borderColor = navBarColor.cgColor
        searchBar.barTintColor = navBarColor
        searchBar.placeholder = "Search Students"
        searchBar.setImage(UIImage(), for: .clear, state: .normal)
        
        // Configure text field
        if let textfield = searchBar.value(forKey: "searchField") as? UITextField {
            textfield.backgroundColor = UIColor(red:0.87, green:0.96, blue:0.95, alpha:1.0)
            textfield.attributedPlaceholder = NSAttributedString(string: textfield.placeholder ?? "", attributes: [NSAttributedString.Key.foregroundColor : ContrastColorOf(navBarColor, returnFlat: true)])
        }
        
        self.navigationController?.isToolbarHidden = false
        self.navigationController?.toolbar.tintColor = ContrastColorOf(navBarColor, returnFlat: true)
        self.navigationController?.toolbar.barTintColor = UIColor.init(cgColor: navBarColor.cgColor)
        navigationController?.setToolbarHidden(false, animated: false)
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
            }
             cell.accessoryType =  student.Graded ? .checkmark  : .none
            
        } else {
            
            cell.textLabel?.text = "No Students Added..."
            
        }
        
        return cell
    }
 
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if segue.identifier == "goToScoreReport" {
        
        if let segueIdentifier =  SegueIdentifier(rawValue: segue.identifier!) {
                
                switch segueIdentifier {
                case .SegueToScoreReportViewIdentifier:
                    let controller = segue.destination as! StudentListViewController
                    controller.selectedCourse = self.selectedCourse
                case .SegueToMassUploadViewIdentifier:
                    let controller = segue.destination as! MassUploadViewController
                    controller.selectedCourse = self.selectedCourse

                }
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
    
        DispatchQueue.main.async { self.resignFirstResponder() }
        
        var textField = UITextField()
        
//        copyText(textToCopy: textField.text! as NSString)
//        textField.text! = pasteText() as String
        

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
    
//    MARK Customize Rubric information and Headings
    
    @IBAction func customizeRubric(_ sender: AnyObject) {
        var textField1 = UITextField()
        var textField2 = UITextField()
        var textField3 = UITextField()
        var textField4 = UITextField()
        var textField5 = UITextField()
        var textField6 = UITextField()
        var textField7 = UITextField()
        let alert = UIAlertController(title: "Personalize Rubric", message: "", preferredStyle: .alert)
        let  action = UIAlertAction(title: "Comfirm", style: .default) { (action) in
            if let currentCourse = self.selectedCourse {
                
                do {
                    try self.realm.write {
                        let  newRubric  = Rubric()
                        newRubric.rubricTitle = textField1.text!
                        newRubric.rubricDescription = textField2.text!
                        newRubric.rubricCourseName = (self.selectedCourse?.name)!
                        newRubric.rubricActionTitle1 = textField3.text!
                        newRubric.rubricActionTitle2 = textField4.text!
                        newRubric.rubricActionTitle3 = textField5.text!
                        newRubric.rubricActionTitle4 = textField6.text!
                        newRubric.rubricActionTitle5 = textField7.text!
                        
                        if self.selectedCourse?.rubricList.first?.rubricCustomize == nil {
                            newRubric.rubricCustomize = 1
                            currentCourse.rubricList.append(newRubric)
                        return
                        }
                            currentCourse.rubricList.replace(index: 0, object: newRubric)
                    }
                } catch {
                    print("Error saving context \(error)")
                }
            }
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Change new title"
            textField1  = alertTextField
        }
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Change new description"
            textField2  = alertTextField
        }
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Change new level 5 description"
            textField3  = alertTextField
        }
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Change new level 4 description"
            textField4  = alertTextField
        }
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Change new level 3 description"
            textField5  = alertTextField
        }
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Change new level 2 description"
            textField6  = alertTextField
        }
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Change new level 1 description"
            textField7  = alertTextField
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
    
    func rubricLabels(){
        
    let rubrics = selectedCourse?.rubricList
        if selectedCourse?.rubricList.first?.rubricCustomize == 1 {

                rTitle = rubrics![0].rubricTitle
                rDesc = rubrics![0].rubricDescription
                rAction1 = rubrics![0].rubricActionTitle1
                rAction2 = rubrics![0].rubricActionTitle2
                rAction3 = rubrics![0].rubricActionTitle3
                rAction4 = rubrics![0].rubricActionTitle4
                rAction5 = rubrics![0].rubricActionTitle5

                return
        }
     
                rTitle = Rubric().rubricTitle
                rDesc = Rubric().rubricDescription
                rAction1 = Rubric().rubricActionTitle1
                rAction2 = Rubric().rubricActionTitle2
                rAction3 = Rubric().rubricActionTitle3
                rAction4 = Rubric().rubricActionTitle4
                rAction5 = Rubric().rubricActionTitle5
    }
    
    // MARK: - ALERT CONTROLLER WITH MULTIPLE BUTTONS & SOME RESTYLING
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let studentForRubric = self.students?[indexPath.row].studentID{
        
            fireAlert(studentID: studentForRubric as AnyObject)
            
        }}
    
    @IBAction func fireAlert(studentID: AnyObject) {
        
        rubricLabels()
        
        let id = String(describing: studentID)
        
        let alert = UIAlertController(title: "",
                                          message: "",
                                          preferredStyle: .alert)

    // Change font of the title and message
    let titleFont:[String : AnyObject] = [ convertFromNSAttributedStringKey(NSAttributedString.Key.font) : UIFont(name: "HelveticaNeue-Bold", size: 18)! ]
    let messageFont:[String : AnyObject] = [ convertFromNSAttributedStringKey(NSAttributedString.Key.font) : UIFont(name: "HelveticaNeue-Thin", size: 14)! ]
        let attributedTitle = NSMutableAttributedString(string: rTitle!, attributes: convertToOptionalNSAttributedStringKeyDictionary(titleFont))
        let attributedMessage = NSMutableAttributedString(string: rDesc!, attributes: convertToOptionalNSAttributedStringKeyDictionary(messageFont))
    alert.setValue(attributedTitle, forKey: "attributedTitle")
    alert.setValue(attributedMessage, forKey: "attributedMessage")


    let action1 = UIAlertAction(title: rAction1!, style: .default, handler: { (action) -> Void in
        let realm = try! Realm()
        let predicate = NSPredicate(format: "studentID == %@", id)
        let theStudent = realm.objects(Student.self).filter(predicate).first
        try! realm.write {
            theStudent?.score = "5"
            theStudent?.Graded = true
        }
        self.loadStudents()
    })
    let action2 = UIAlertAction(title: rAction2!, style: .default, handler: { (action) -> Void in
        let realm = try! Realm()
        let predicate = NSPredicate(format: "studentID == %@", id)
        let theStudent = realm.objects(Student.self).filter(predicate).first
        try! realm.write {
            theStudent?.score = "4"
            theStudent?.Graded = true
        }
         self.loadStudents()
    })
    let action3 = UIAlertAction(title: rAction3!, style: .default, handler: { (action) -> Void in
        let realm = try! Realm()
        let predicate = NSPredicate(format: "studentID == %@", id)
        let theStudent = realm.objects(Student.self).filter(predicate).first
        try! realm.write {
            theStudent?.score = "3"
            theStudent?.Graded = true
        }
         self.loadStudents()
    })
    let action4 = UIAlertAction(title: rAction4!, style: .default, handler: { (action) -> Void in
        let realm = try! Realm()
        let predicate = NSPredicate(format: "studentID == %@", id)
        let theStudent = realm.objects(Student.self).filter(predicate).first
        try! realm.write {
            theStudent?.score = "2"
            theStudent?.Graded = true
        }
         self.loadStudents()
    })
    let action5 = UIAlertAction(title: rAction5!, style: .default, handler: { (action) -> Void in
        let realm = try! Realm()
        let predicate = NSPredicate(format: "studentID == %@", id)
        let theStudent = realm.objects(Student.self).filter(predicate).first
        try! realm.write {
            theStudent?.score = "0"
            theStudent?.Graded = true
        }
        self.loadStudents()
    })
    // Cancel button
    let cancel = UIAlertAction(title: "Cancel", style: .destructive, handler: { (action) -> Void in })

    // Restyle the view of the Alert
    alert.view.tintColor = UIColor(red:0.07, green:0.08, blue:0.30, alpha:1.0)  // change text color of the buttons
    alert.view.backgroundColor = UIColor.clear  // change background color
    alert.view.layer.cornerRadius = 25   // change corner radius


    // Add action buttons and present the Alert
    alert.addAction(action1)
    alert.addAction(action2)
    alert.addAction(action3)
    alert.addAction(action4)
    alert.addAction(action5)
    alert.addAction(cancel)
    
    present(alert, animated: true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
    }
  
    func setUpNavBar(){
        title = selectedCourse?.name
        tableView.separatorStyle = .none
        guard let colourHex = selectedCourse?.Color else {   fatalError()}
        updateNavBar(withHexCode: colourHex)
    }
    // Function receives the text as argument for copying
    func copyText(textToCopy : NSString)
    {
        let pasteBoard = UIPasteboard.general;
        pasteBoard.string = textToCopy as String; // Set your text here
    }
    
    // Function returns the copied string
    func pasteText() -> NSString
    {
        let pasteBoard = UIPasteboard.general;
        print("Copied Text : \(String(describing: pasteBoard.string))"); // It prints the copied text
        return pasteBoard.string! as NSString;
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




