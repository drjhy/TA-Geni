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

var colorCount = 0
var color: UIColor = .clear

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
        
        let color1 = UIColor(red:0.51, green:0.53, blue:0.84, alpha:1.0)
        let color2 = UIColor(red:0.78, green:0.80, blue:0.94, alpha:1.0)
        let color3 = UIColor(red:0.89, green:0.91, blue:0.95, alpha:1.0)
        
        if colorCount == 0 {
            colorCount = 1
            color = color1
            return color
        } else if colorCount == 1 {
            colorCount = 2
            color = color2
            return color
        } else {
            colorCount = 0
            color = color3
            return color
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
        
        navigationController?.navigationBar.barTintColor = UIColor(red:0.29, green:0.30, blue:0.64, alpha:1.0)
        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white]
        addNavBarImage()
        loadCourse()
        tableView.separatorStyle = .none
    }
    
    
    
}
    


