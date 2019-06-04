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
import SafariServices
import ChameleonFramework

class SettingTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setBackgroudNav()
        versionUpdates()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setBackgroudNav()
        versionUpdates()
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setBackgroudNav()
        versionUpdates()
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        setBackgroudNav()
        versionUpdates()
    }
    
    @IBAction func emailTapped(_ sender: Any) {
        sendEmail()
    }

    @IBAction func bugTapped(_ sender: Any) {
        bugEmail()
    }    
    
    @IBAction func ideaRequest(_ sender: Any) {
        IdeaFeatureRequest()
    }
    
    @IBOutlet weak var appVersion: UILabel!
    @IBOutlet weak var buildVersion: UILabel!
    
    @IBAction func reviewTapped(_ sender: Any) {
        SKStoreReviewController.requestReview()
    }
    @IBAction func shareTapped(_ sender: UIButton) {
      ShareApp()
    }
   
    func IdeaFeatureRequest() {
        if let url = URL(string: "https://tageni.youngdynasty.com/feature-request/") {
            let config = SFSafariViewController.Configuration()
            config.entersReaderIfAvailable = true
            
            let vc = SFSafariViewController(url: url, configuration: config)
            present(vc, animated: true)
        }
    }
    
    func ShareApp() {

        let items:[Any] = ["Easy and Simple solution at your fingertips. Two-touch real-time grading system. Hire your next teaching assistant today. Download  https://itunes.apple.com/in/app/TA-GeNi-app/com.youngdynasty.com.TA-Geni mt=8"]

        let ac = UIActivityViewController(activityItems: items, applicationActivities: nil)
            ac.popoverPresentationController?.sourceView = self.view
            present(ac, animated: true, completion: nil)
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
        
        navigationController?.navigationBar.tintColor = UIColor.black
        navigationController?.navigationBar.barTintColor = UIColor(red:0.18, green:0.57, blue:0.59, alpha:1.0)
        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.black, .font: UIFont(name: "HelveticaNeue-Medium", size: 20)!]
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
    static var appVersion: String {
        return (Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String)!
    }
    static var buildVersion: String {
        return (Bundle.main.object(forInfoDictionaryKey: "CFBundleVersion") as? String)!
    }
}

private extension SettingTableViewController {
    func versionUpdates() {
        appVersion.text = String(describing: Bundle.appVersion)
        buildVersion.text = String(describing: Bundle.buildVersion)
    }
}

