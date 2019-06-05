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

//var colorCount = 0
var color: UIColor = UIColor(red:0.18, green:0.57, blue:0.59, alpha:1.0)

class CourseListViewController: SwipeTableViewController {
    
    let realm = try! Realm()
    var courseArray: Results<Course>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setBackgroudNav()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setBackgroudNav()
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setBackgroudNav()
    }
 
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        setBackgroudNav()
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
            cell.textLabel?.textColor = ContrastColorOf(courseColor, returnFlat: true)
        }
        return cell
    }
    
    @IBAction func settingTapped(_ sender: UIBarButtonItem) {
        performSegue(withIdentifier: "goToSetting", sender: self)
    }
    
    //MARK -- TableView Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToStudent", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
       
        if segue.identifier == "goToStudent"{
        
            let destinationVC = segue.destination as! StudentViewController
        
            if let indexPath = tableView.indexPathForSelectedRow {
                destinationVC.selectedCourse = courseArray?[indexPath.row]
            }
        }}
    
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
            
            let courseDeletion = courseForDeletion.name
            
            studentsForDelection(courseDeleted: courseDeletion)
            rubricForDelection(courseDeleted: courseDeletion)
            
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

        DispatchQueue.main.async {
            self.resignFirstResponder()
        }
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Course", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add", style: .default) { (action) in
            
            let newCourse = Course()
            newCourse.name = textField.text!
            newCourse.Color = self.setColorCode(rowColorSet: color as UIColor).hexValue()
            
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
    
//    MARK - Set color cells for New Courses added.
    
    func setColorCode(rowColorSet: UIColor) -> UIColor{
        
        var colorCount = courseArray?.count
        print(colorCount as Any)
        let color1 = UIColor(red:0.27, green:0.72, blue:0.73, alpha:1.0)
        let color2 = color1.lighter(by: 10)
        let color3 = color2.lighter(by: 10)
        let color4 = color3.lighter(by: 10)
        let color5 = color4.lighter(by: 10)
        let color6 = color5.lighter(by: 10)
        let color7 = color6.lighter(by: 10)
        let color8 = color7.lighter(by: 10)
        let color9 = color8.lighter(by: 10)
        let color10 = color9.lighter(by: 10)
        
        if colorCount! == 1 { colorCount = 1; color = color1; return color
        } else if colorCount! == 2 { colorCount = 2; color = color2; return color
        } else if colorCount! == 3 { colorCount = 3; color = color3; return color
        } else if colorCount! == 4 { colorCount = 4; color = color4; return color
        } else if colorCount! == 5 { colorCount = 5; color = color5; return color
        } else if colorCount! == 6 { colorCount = 6; color = color6; return color
        } else if colorCount! == 7 { colorCount = 7; color = color7; return color
        } else if colorCount! == 8 { colorCount = 8; color = color8; return color
        } else if colorCount! == 9 { colorCount = 9; color = color9; return color
        } else { colorCount = 10; color = color10; return color
        }
    }
  
    func addNavBarImage() {

        let navController = navigationController!

        let image = UIImage(named: "Logo.png") //Your logo url here
        let imageView = UIImageView(image: image)

        let bannerWidth = navController.navigationBar.frame.size.width
        let bannerHeight = navController.navigationBar.frame.size.height

        let bannerX = bannerWidth / 2 - (image?.size.width)! / 2
        let bannerY = bannerHeight / 2 - (image?.size.height)! / 2

        imageView.frame = CGRect(x: bannerX, y: bannerY, width: bannerWidth, height: bannerHeight)
        imageView.contentMode = .scaleAspectFit

        navigationItem.titleView = imageView
    }
    
//    MARK - Setup navigation Bar
    
    func setBackgroudNav(){
        
        navigationController?.navigationBar.barTintColor = UIColor(red:0.18, green:0.57, blue:0.59, alpha:1.0)
        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white]
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.isTranslucent = false
        
        addNavBarImage()
        loadCourse()
        tableView.separatorStyle = .none
        view.backgroundColor = UIColor(red:0.87, green:0.96, blue:0.95, alpha:1.0)
    
        navigationController?.toolbar.tintColor = ContrastColorOf(color, returnFlat: true)
        navigationController?.toolbar.barTintColor = UIColor(red:0.18, green:0.57, blue:0.59, alpha:1.0)
        navigationController?.setToolbarHidden(false, animated: false)
        
        getCurrentDateTime()
        
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: tableView.frame.width, height: 50))
        
        let label = UILabel()
        label.frame = CGRect.init(x: 5, y: 5, width: headerView.frame.width-10, height: headerView.frame.height-10)
        label.text = "Your Virtual Assistant"
        label.font = UIFont(name: "HelveticaNeue-Bold", size: 25)
        label.textColor = UIColor.flatBlack
        label.textAlignment = .left
        label.backgroundColor = UIColor(red:0.18, green:0.57, blue:0.59, alpha:1.0)
        
        headerView.backgroundColor = UIColor(red:0.18, green:0.57, blue:0.59, alpha:1.0)
        headerView.addSubview(label)
        
        return headerView
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    func studentsForDelection(courseDeleted: String){
        
        let allStudents = realm.objects(Student.self).filter("studentCourseName == %@", courseDeleted)
        
        let byStudent = allStudents.sorted(byKeyPath: "studentID", ascending: true)
        
        for student in byStudent{
            
            let realm = try! Realm()
            let predicate = NSPredicate(format: "studentID == %@", student.studentID)
            let theStudent = realm.objects(Student.self).filter(predicate).first
            try! realm.write {
                self.realm.delete(theStudent!)
                
            }
        }
    }

    func rubricForDelection(courseDeleted: String){
        
        let theRubric = realm.objects(Rubric.self).filter("rubricCourseName == %@", courseDeleted)
            do{
                try self.realm.write {
                self.realm.delete(theRubric)
                }
            } catch {
                print("Error deleting rubric, \(error)")
            }
        }

    @IBOutlet weak var labelDate: UILabel!
    
    func getCurrentDateTime() {
        
        let now = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "  EEEE, MMMM dd"
        labelDate.text = formatter.string(from: now)
        labelDate.font = UIFont(name: "HelveticaNeue-medium", size: 12)
        labelDate.textColor = UIColor.darkGray
        labelDate.textAlignment = .left
        labelDate.backgroundColor = UIColor(red:0.18, green:0.57, blue:0.59, alpha:1.0)

        let text = formatter.string(from: now)
        labelDate.text = text.uppercased()
    }

}

extension UIColor {
    
    func lighter(by percentage: CGFloat = 10.0) -> UIColor {
        return self.adjust(by: abs(percentage))
    }
    
    func darker(by percentage: CGFloat = 10.0) -> UIColor {
        return self.adjust(by: -abs(percentage))
    }
    
    func adjust(by percentage: CGFloat) -> UIColor {
        var alpha, hue, saturation, brightness, red, green, blue, white : CGFloat
        (alpha, hue, saturation, brightness, red, green, blue, white) = (0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0)
        
        let multiplier = percentage / 100.0
        
        if self.getHue(&hue, saturation: &saturation, brightness: &brightness, alpha: &alpha) {
            let newBrightness: CGFloat = max(min(brightness + multiplier*brightness, 1.0), 0.0)
            return UIColor(hue: hue, saturation: saturation, brightness: newBrightness, alpha: alpha)
        }
        else if self.getRed(&red, green: &green, blue: &blue, alpha: &alpha) {
            let newRed: CGFloat = min(max(red + multiplier*red, 0.0), 1.0)
            let newGreen: CGFloat = min(max(green + multiplier*green, 0.0), 1.0)
            let newBlue: CGFloat = min(max(blue + multiplier*blue, 0.0), 1.0)
            return UIColor(red: newRed, green: newGreen, blue: newBlue, alpha: alpha)
        }
        else if self.getWhite(&white, alpha: &alpha) {
            let newWhite: CGFloat = (white + multiplier*white)
            return UIColor(white: newWhite, alpha: alpha)
        }
        
        return self
    }
}
