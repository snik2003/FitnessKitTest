//
//  Shedules.swift
//  FitnessKitTest
//
//  Created by Сергей Никитин on 25/02/2020.
//  Copyright © 2020 Snik2003. All rights reserved.
//

import Foundation
import SwiftyJSON

class Shedules: Codable {
    
    let fitnessKitSheduleKeyName = "FITTNESS-KIT-SHEDULE-KEY"
    
    var shedule: [Record] = []
    
    func save() {
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(self.shedule) {
            UserDefaults.standard.set(encoded, forKey: self.fitnessKitSheduleKeyName)
        }
    }
    
    func load() {
        if let data = UserDefaults.standard.object(forKey: self.fitnessKitSheduleKeyName) as? Data {
            let decoder = JSONDecoder()
            if let objects = try? decoder.decode([Record].self, from: data) {
                self.shedule = objects
            }
        }
    }
}

class Record: Codable {
    var name = ""
    var startTime = ""
    var endTime = ""
    var teacher = ""
    var place = ""
    var descript = ""
    var weekDay = 0
    
    init(json: JSON) {
        self.name = json["name"].stringValue
        self.startTime = json["startTime"].stringValue
        self.endTime = json["endTime"].stringValue
        self.teacher = json["teacher"].stringValue
        self.place = json["place"].stringValue
        self.descript = json["description"].stringValue
        self.weekDay = json["weekDay"].intValue
    }
}
