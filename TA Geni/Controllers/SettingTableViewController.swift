//
//  SettingTableViewController.swift
//  TA Geni
//
//  Created by John Young on 5/26/19.
//  Copyright © 2019 John Young. All rights reserved.
//

import UIKit
import StoreKit
import MessageUI
import ChameleonFramework

class SettingTableViewController: UITableViewController {

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
    // MARK: - Table view data source
//
//    override func numberOfSections(in tableView: UITableView) -> Int {
//        // #warning Incomplete implementation, return the number of sections
//        return 3
//    }
//
//    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        // #warning Incomplete implementation, return the number of rows
//        return 0
//    }
    
    
    
    @IBAction func emailTapped(_ sender: Any) {
        sendEmail()
    }

    @IBAction func bugTapped(_ sender: Any) {
        bugEmail()
    }
    
    
    
    
    
    
    func sendEmail() {
        guard MFMailComposeViewController.canSendMail() else { return}
        
        let mail = MFMailComposeViewController()
            mail.mailComposeDelegate = self
            mail.setToRecipients(["help@tageni.youngdynasty.com"])
            mail.setSubject("TA GeNi App Feedback")
            mail.setMessageBody("<p>Hi TA GeNi Team, here's my feedback:</p>", isHTML: true)
            
            present(mail, animated: true)
    }
    
    func bugEmail() {
        guard MFMailComposeViewController.canSendMail() else { return}
        
        let systemVersion = UIDevice.current.systemVersion
        let systemName = UIDevice.current.systemName
        let systemModel = UIDevice.current.model
        let appVersion = String(describing: Bundle.appVersion)
        let buildVersion = String(describing: Bundle.buildVersion)
    
        let mail = MFMailComposeViewController()
        mail.mailComposeDelegate = self
        mail.setToRecipients(["help@tageni.youngdynasty.com"])
        mail.setSubject("TA GeNi App Feedback")
        mail.setMessageBody("</br>Hi TA GeNi Team, here's my feedback:</br>" + "<br/br/br/br/br>" + "<br>--------------</br>" + "System Version: \(systemVersion)</br>System Name: \(systemName)</br>Model : \(systemModel)</br>App Version: \(appVersion)</br>Build Version: \(buildVersion)</br/br>", isHTML: true)
        
        present(mail, animated: true)
    }
    
    func setBackgroudNav(){
        navigationController?.navigationBar.barTintColor = UIColor(red:0.18, green:0.57, blue:0.59, alpha:1.0)
        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.black]
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.isTranslucent = false
    }
}

extension SettingTableViewController: MFMailComposeViewControllerDelegate {
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        // Dismiss the mail compose view controller.
        controller.dismiss(animated: true, completion: nil)
    }
}

extension Bundle {
    static var appVersion: String? {
        return Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String
    }
    static var buildVersion: String? {
        return Bundle.main.object(forInfoDictionaryKey: "CFBundleVersion") as? String
    }

}
