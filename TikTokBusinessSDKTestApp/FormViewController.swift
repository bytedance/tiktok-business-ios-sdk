//
//  FormViewController.swift
//  TikTokBusinessSDKTestApp
//
//  Created by Aditya Khandelwal on 9/10/20.
//  Copyright © 2020 bytedance. All rights reserved.
//

import UIKit

class FormViewController: UIViewController {
    
    var titleName = "Enter the fields"
    
    var eventToField =
        [
            "LAUNCH_APP": [],
            "INSTALL_APP": [],
            "RETENTION_2D": [],
            "ADD_PAYMENT_INFO": ["app_id", "idfa", "attribution"],
            "ADD_TO_CART": ["content_type", "sku_id", "description", "currency", "value"],
            "ADD_TO_WISHLIST": ["page_type", "content_id", "description", "currency", "value"],
            "CHECKOUT": ["description", "sku_id", "number_of_items", "payment_unavailable", "currency", "value", "game_item_type", "game_item_id", "room_type", "currency", "value", "location", "checkin_date", "checkout_date", "number_of_rooms", "number_of_nights"],
            "COMPLETE_TUTORIAL": [],
            "VIEW_CONTENT": ["page_type", "sku_id", "description", "currency", "value", "search_string", "room_type", "location", "checkin_date", "checkout_date", "number_of_rooms", "number_of_nights", "outbound_origination_city", "outbound_destination_city", "return_origination_city", "return_destination_city", "class", "number_of_passenger"],
            "CREATE_GROUP": ["group_name", "group_logo", "group_description", "group_type", "group_id"],
            "CREATE_ROLE": ["role_type"],
            "GENERATE_LEAD": [],
            "IN_APP_AD_CLICK": ["ad_type"],
            "IN_APP_AD_IMPR": ["ad_type"],
            "JOIN_GROUP": ["level_numer"],
            "ACHIEVE_LEVEL": ["level_number", "score"],
            "LOAN_APPLICATION": ["loan_type", "application_id"],
            "LOAN_APPROVAL": ["value"],
            "LOAN_DISBURSAL": ["value"],
            "LOGIN": [],
            "PURCHASE": ["page_type", "sku_id", "description", "number_of_items", "coupon_used", "currency", "value", "group_type", "game_item_id", "room_type", "location", "checkin_date", "checkout_date", "number_of_rooms", "number_of_nights", "outbound_origination_city", "outbound_destination_city", "return_origination_city", "return_destination_city", "class", "number_of_passenger", "service_type", "service_id"],
            "RATE": ["page_type", "sku_id", "content", "rating_value", "max_rating_value", "rate"],
            "REGISTRATION": ["registration_method"],
            "SEARCH": ["search_string", "checkin_date", "checkout_date", "number_of_rooms", "number_of_nights", "origination_city", "destination_city", "departure_date", "return_date", "class", "number_of_passenger"],
            "SPEND_CREDITS": ["game_item_type", "game_item_id", "level_number"],
            "START_TRIAL": ["order_id", "currency"],
            "SUBSCRIBE": ["order_id", "currency"],
            "SHARE": ["content_type", "content_id", "share_destination"],
            "CONTACT": [],
            "UNLOCK_ACHIEVEMENT": ["description", "achievement_type"]
    ]
    
    var payload = ""
    var fields = [UITextField]()
    var parameters = [UITextField]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = titleName
        
        let fieldsNames = eventToField[titleName]
        
        let createPayload = UIButton(frame: CGRect(x: 10.0, y:100.0, width: UIScreen.main.bounds.size.width - 20.0, height: 50.0))
        createPayload.backgroundColor = .blue
        createPayload.setTitle("Create Payload", for: .normal)
        createPayload.addTarget(self, action: #selector(self.didCreatePayload(sender:)), for: .touchUpInside)
        
        self.view.addSubview(createPayload)
        for fieldIndex in 0 ..< fieldsNames!.count {
            let field = UITextField(frame: CGRect(x: 10.0, y:(100.0 + CGFloat((fieldIndex + 1) * 60)), width: UIScreen.main.bounds.size.width/2 - 15.0, height: 50.0))
            field.text = fieldsNames?[fieldIndex]
            field.backgroundColor = .yellow
            field.tag = fieldIndex
            let parameter = UITextField(frame: CGRect(x:UIScreen.main.bounds.size.width/2 + 5.0, y:(100.0 + CGFloat((fieldIndex + 1) * 60)), width: UIScreen.main.bounds.size.width/2 - 15.0, height: 50.0))
            parameter.text = randomText(from: 5, to: 20)
            parameter.backgroundColor = .red
            parameter.tag = fieldIndex
            self.fields.append(field)
            self.parameters.append(parameter)
            self.view.addSubview(field)
            self.view.addSubview(parameter)
        }
        

    }
    
    
    @IBAction func didCreatePayload(sender: UIButton) {

        self.payload = "{\n"
        self.payload += "\t\"event_name\": \""
        self.payload += self.titleName
        self.payload += "\",\n"
        
        
        for fieldIndex in 0 ..< fields.count {
            self.payload += "\t\""
            if let field = self.fieldsForTag(tag: fieldIndex){
                self.payload += field.text!
                self.payload += "\": \""
            }
            
            if let parameter = self.parametersForTag(tag: fieldIndex){
                self.payload += parameter.text!
                self.payload += "\",\n"
            }
        }
        self.payload = self.payload + "}"
        performSegue(withIdentifier: "segueToEvent", sender: self)
        
    }
    
    func fieldsForTag( tag: Int ) -> UITextField? {
        return self.fields.filter({ $0.tag == tag }).first
    }
    
    func parametersForTag( tag: Int ) -> UITextField? {
        return self.parameters.filter({ $0.tag == tag }).first
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let vc = segue.destination as! EventViewController
        vc.payload = self.payload
        vc.eventTitle = self.titleName
    }
    
    
    func randomText(from: Int, to: Int, justLowerCase: Bool = false) -> String {
        var text = ""
        let range = UInt32(to - from)
        let length = Int(arc4random_uniform(range + 1)) + from
        for _ in 1...length {
            var decValue = 0  // ascii decimal value of a character
            var charType = 3  // default is lowercase
            if justLowerCase == false {
                // randomize the character type
                charType =  Int(arc4random_uniform(4))
            }
            switch charType {
            case 1:  // digit: random Int between 48 and 57
                decValue = Int(arc4random_uniform(10)) + 48
            case 2:  // uppercase letter
                decValue = Int(arc4random_uniform(26)) + 65
            case 3:  // lowercase letter
                decValue = Int(arc4random_uniform(26)) + 97
            default:  // space character
                decValue = 32
            }
            // get ASCII character from random decimal value
            let char = String(UnicodeScalar(decValue)!)
            text = text + char
            // remove double spaces
            text = text.replacingOccurrences(of: " ", with: "")
        }
        return text
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
