//
//  AllertView.swift
//  Course2FinalTask
//
//  Created by Евгений on 12.10.2020.
//  Copyright © 2020 e-Legion. All rights reserved.
//

import UIKit

class AlertViewController: UIViewController {
    
    let inputViewControllers: UIViewController
    
    init(view: UIViewController) {
        self.inputViewControllers = view
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func createAlert(handler: @escaping (UIAlertAction) -> Void) {
        
        let alert = UIAlertController(title: "Unknown error!", message: "Please, try again later.", preferredStyle: .alert)
        let action = UIAlertAction(title: "Ok", style: .cancel, handler: handler)
        alert.addAction(action)
        inputViewControllers.present(alert, animated: true, completion: nil)
    }
}
