//
//  UserHealthProfile.swift
//  HealthKit_Learning
//
//  Created by Flamingo on 2021/3/6.
//

import HealthKit
import UIKit

class UserHealthProfile {
    
    var age: Int?
    var biologicalSex: HKBiologicalSex?
    var bloodType: HKBloodType?
    var heightInMeters: Double?
    var weightInKilograms: Double?
    
    var stepCount: Int?
    var kcal: Double?
    var bodyMassIndex: Double?
//    var bodyMassIndex: Double? {
//        didSet {
//            if let bodyMassIndex = bodyMassIndex {
//                if bodyMassIndex < 18.5 {
//                    displayAlert(title: nil, message: "体重偏低")
//                } else if bodyMassIndex >= 18.5 && bodyMassIndex < 24 {
//                    displayAlert(title: nil, message: "体重正常")
//                } else if bodyMassIndex >= 24 && bodyMassIndex < 28 {
//                    displayAlert(title: nil, message: "超重")
//                } else {
//                    displayAlert(title: nil, message: "肥胖")
//                }
//            }
//        }
//    }
    
    func displayAlert(title: String?, message: String?) {
        
        let alert = UIAlertController(title: title,
                                      message: message,
                                      preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "确定",
                                      style: .default,
                                      handler: nil))
        
        currentViewController()?.present(alert, animated: true, completion: nil)
    }
    
}
