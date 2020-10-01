//
//  MetricsViewController.swift
//  TikTokBusinessSDKTestApp
//
//  Created by Aditya Khandelwal on 9/30/20.
//  Copyright © 2020 bytedance. All rights reserved.
//

import UIKit
import TikTokBusinessSDK

class MetricsViewController: UIViewController {
    
    @IBOutlet weak var numberOfEventsField: UITextField!
    @IBOutlet weak var randomEvents: UIButton!
    @IBOutlet weak var numberOfEventsDumped: UILabel!
    @IBOutlet weak var numberOfEventsInMemory: UILabel!
    @IBOutlet weak var numberOfEventsInDisk: UILabel!
    @IBOutlet weak var secondsUntilFlush: UILabel!
    @IBOutlet weak var remainingNumberOfEventsUntilFlush: UILabel!
    
    let events = ["CUSTOM_EVENT", "LAUNCH_APP", "INSTALL_APP", "RETENTION_2D", "ADD_PAYMENT_INFO", "ADD_TO_CART", "ADD_TO_WISHLIST", "CHECKOUT", "COMPLETE_TUTORIAL", "VIEW_CONTENT", "CREATE_GROUP", "CREATE_ROLE", "GENERATE_LEAD", "IN_APP_AD_CLICK", "IN_APP_AD_IMPR", "JOIN_GROUP", "ACHIEVE_LEVEL", "LOAN_APPLICATION", "LOAN_APPROVAL", "LOAN_DISBURSAL", "LOGIN", "PURCHASE", "RATE", "REGISTRATION", "SEARCH", "SPEND_CREDITS", "START_TRIAL", "SUBSCRIBE", "SHARE", "CONTACT", "UNLOCK_ACHIEVEMENT"]
    
    var eventToField =
        [
            "CUSTOM_EVENT": [],
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
    
    
    var payload = "{\n\n}"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if((numberOfEventsField.text?.count)! > 0){
            randomEvents.setTitle("Generate " + "Random events", for: .normal)
        }

        numberOfEventsInMemory.text = String(TikTok.getInMemoryEventCount());
        numberOfEventsInDisk.text = String(TikTok.getInDiskEventCount());
        numberOfEventsDumped.text = String(0);
        secondsUntilFlush.text = String(TikTok.getTimeInSecondsUntilFlush())
        remainingNumberOfEventsUntilFlush.text = String(TikTok.getRemainingEventsUntilFlushThreshold())

        NotificationCenter.default.addObserver(self, selector: #selector(onInMemoryEventQueueUpdate(_:)), name: NSNotification.Name(rawValue: "inMemoryEventQueueUpdated"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(onInDiskEventQueueUpdate(_:)), name: NSNotification.Name(rawValue: "inDiskEventQueueUpdated"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(onEventsDumped(_:)), name: NSNotification.Name(rawValue: "eventsDumped"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(onTimeLeft(_:)), name: NSNotification.Name(rawValue: "timeLeft"), object: nil)
    }
    
    @objc func onInMemoryEventQueueUpdate(_ notification:Notification) {
        numberOfEventsInMemory.text = String(TikTok.getInMemoryEventCount());
        remainingNumberOfEventsUntilFlush.text = String(TikTok.getRemainingEventsUntilFlushThreshold());
    }
    @objc func onInDiskEventQueueUpdate(_ notification:Notification) {
        numberOfEventsInDisk.text = String(TikTok.getInDiskEventCount());
    }
    
    @objc func onTimeLeft(_ notification:Notification) {
        secondsUntilFlush.text = String(TikTok.getTimeInSecondsUntilFlush());
    }
    
    @objc func onEventsDumped(_ notification:Notification) {
        if let userInfo = notification.userInfo as [AnyHashable : Any]? {
          if let eventsDumped = userInfo["numberOfEventsDumped"] as? Int {
            numberOfEventsDumped.text = String(eventsDumped)
          }
        }
        
    }
    
    @IBAction func numberOfEventsChanged(_ sender: Any) {
        if((numberOfEventsField.text?.count)! > 0){
            print("should change")
            randomEvents.setTitle("Generate \(numberOfEventsField.text ?? "") Random events", for: .normal)
        }
    }
    @IBAction func generateRandomEvents(_ sender: Any) {
        let count = Int(numberOfEventsField.text ?? "") ?? 0
        if(numberOfEventsField.text!.count <= 0 || numberOfEventsField.text == "0") {return}
        for var num in 0...count - 1 {
            let randomEvent = self.events.randomElement();
            if(randomEvent == "LAUNCH_APP" || randomEvent == "INSTALL_APP") {
                num -= 1
            }
            self.payload = "{\n"
            self.payload += "\t\"event_name\": \""
            self.payload += randomEvent!
            self.payload += "\",\n"
            let fields = eventToField[randomEvent!]
            for fieldIndex in 0 ..< fields!.count {
                self.payload += "\t\""
                self.payload += fields![fieldIndex]
                self.payload += "\": \""
                self.payload += randomText(from: 5, to: 20)
                self.payload += "\",\n"
            }
            self.payload = self.payload + "}"
            let event = TikTokAppEvent.init(eventName: randomEvent!, withParameters: self.payload.data(using: .utf8)!)
            TikTok.trackEvent(event)
        }
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

}
