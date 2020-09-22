//
//  EventViewController.swift
//  TikTokBusinessSDKTestApp
//
//  Created by Aditya Khandelwal on 9/10/20.
//  Copyright © 2020 bytedance. All rights reserved.
//

import UIKit
import TikTokBusinessSDK

class EventViewController: UIViewController {
    
    @IBOutlet weak var eventTextField: UITextField!
    @IBOutlet weak var finalPayloadTextField: UITextView!
    
    let delegate = UIApplication.shared.delegate as! AppDelegate
    var eventPickerView = UIPickerView()
    
    let events = ["CUSTOM_EVENT", "LAUNCH_APP", "INSTALL_APP", "RETENTION_2D", "ADD_PAYMENT_INFO", "ADD_TO_CART", "ADD_TO_WISHLIST", "CHECKOUT", "COMPLETE_TUTORIAL", "VIEW_CONTENT", "CREATE_GROUP", "CREATE_ROLE", "GENERATE_LEAD", "IN_APP_AD_CLICK", "IN_APP_AD_IMPR", "JOIN_GROUP", "ACHIEVE_LEVEL", "LOAN_APPLICATION", "LOAN_APPROVAL", "LOAN_DISBURSAL", "LOGIN", "PURCHASE", "RATE", "REGISTRATION", "SEARCH", "SPEND_CREDITS", "START_TRIAL", "SUBSCRIBE", "SHARE", "CONTACT", "UNLOCK_ACHIEVEMENT"]
    
    var titleForForm = "LAUNCH_APP"
    var payload = "{\n\n}"
    var eventTitle = ""
    var tiktok: Any?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Initializing TikTok SDK
//        tiktok = delegate.;
        title = "Event"
        eventPickerView.dataSource = self
        eventPickerView.delegate = self
        eventTextField.inputView = eventPickerView
        eventTextField.textAlignment = .center
        eventTextField.placeholder = "Select an event"
        finalPayloadTextField.text = payload
        if(eventTitle.count > 0){
            eventTextField.text = eventTitle
        }
        // Do any additional setup after loading the view.
    }
    

    @IBAction func didSelectEvent(_ sender: Any) {
        
        self.titleForForm = eventTextField.text!
        if(eventTextField.text!.count > 0){
            performSegue(withIdentifier: "segueToForm", sender: self)
        } else {
            print("Please select an event to continue")
        }
        
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let vc = segue.destination as! FormViewController
        vc.titleName = self.titleForForm
    }
    
    @IBAction func eventPosted(_ sender: Any) {
        let event = TikTokAppEvent(eventName:eventTitle)
        print("Event " + eventTitle + " posted")
        finalPayloadTextField.text = "{\n\t\"repsonse\": \"SUCCESS\"\n}"
        TikTok.trackEvent(event)
    }
    
    @IBAction func clearPayload(_ sender: Any) {
        finalPayloadTextField.text = "{\n\n}"
        print("Payload cleared")
    }
    
    /*

     // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension EventViewController: UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return events.count
    }
    
}

extension EventViewController: UIPickerViewDelegate {
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return events[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        // TODO
        eventTextField.text = events[row]
        eventTextField.resignFirstResponder()
    }
    
}
