//
//  Alert.swift
///  Week3TestWork
//
//  Copyright © 2018 E-legion. All rights reserved.
//

import Foundation
import UIKit

class Alert {
    
    //Создает алерт
    class func showBasic(title: String, message: String, vc: UIViewController) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        vc.present(alert, animated: true)
    }
}
