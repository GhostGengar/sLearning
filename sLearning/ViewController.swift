//
//  ViewController.swift
//  sLearning
//
//  Created by Luke Dinh on 4/4/17.
//  Copyright © 2017 Blue Lamp. All rights reserved.
//

import CoreData
import UIKit
import UserNotifications

class ViewController: UIViewController, UITextFieldDelegate, UITextViewDelegate {

    @IBOutlet var vocabularyTextField: UITextField!
    @IBOutlet var definitionTextView: UITextView!
    @IBOutlet var vietnameseMeaningTextView: UITextView!
    @IBAction func saveWordAction(_ sender: Any) {
        if (vocabularyTextField.text?.isEmpty)! || definitionTextView.text.isEmpty || vietnameseMeaningTextView.text.isEmpty {
            createAlert(title: "Error in Form", message: "Some of your information are empty.")
        } else {
            saveWord()
            scheduleNotification(word: (vocabularyTextField.text)!, definition: definitionTextView.text, subDefinition: vietnameseMeaningTextView.text)
        }
    }
    
    func saveWord() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let newWord = NSEntityDescription.insertNewObject(forEntityName: "ListOfWords", into: context)
        newWord.setValue(vocabularyTextField.text, forKey: "word")
        newWord.setValue(definitionTextView.text, forKey: "definition")
        newWord.setValue(vietnameseMeaningTextView.text, forKey: "vietnameseMeaning")
        do {
            try context.save()
            self.createAlert(title: "Word Saved", message: "We will send you notification frequently.")
        } catch {
            self.createAlert(title: "Error", message: "Failed to save to word.")
        }
    }
    
    func scheduleNotification(word: String, definition: String, subDefinition: String) {
        let content = UNMutableNotificationContent()
        content.title = word
        content.subtitle = subDefinition
        content.body = definition
        content.badge = 1
        
        let firstTrigger = UNTimeIntervalNotificationTrigger(timeInterval: 1800, repeats: false)
        let secondTrigger = UNTimeIntervalNotificationTrigger(timeInterval: 86400, repeats: false)
        let thirdTrigger = UNTimeIntervalNotificationTrigger(timeInterval: 864000, repeats: false)
        let fourthTrigger = UNTimeIntervalNotificationTrigger(timeInterval: 2592000, repeats: false)
        let fifthTrigger = UNTimeIntervalNotificationTrigger(timeInterval: 5184000, repeats: false)
        
        let firstRequest = UNNotificationRequest(identifier: "1stReq", content: content, trigger: firstTrigger)
        let secondRequest = UNNotificationRequest(identifier: "2ndReq", content: content, trigger: secondTrigger)
        let thirdRequest = UNNotificationRequest(identifier: "3rdReq", content: content, trigger: thirdTrigger)
        let fourthRequest = UNNotificationRequest(identifier: "4thReq", content: content, trigger: fourthTrigger)
        let fifthRequest = UNNotificationRequest(identifier: "5thReq", content: content, trigger: fifthTrigger)
        
        let requests = [firstRequest, secondRequest, thirdRequest, fourthRequest, fifthRequest]
        
        for request in requests {
            UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
        }
    }
    
    func createAlert(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
            self.dismiss(animated: true, completion: nil)
        }))
        self.present(alertController, animated: true, completion: nil)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textViewShouldEndEditing(_ textView: UITextView) -> Bool {
        textView.resignFirstResponder()
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

