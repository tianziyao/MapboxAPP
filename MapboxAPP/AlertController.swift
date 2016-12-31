//
//  AlertController.swift
//  MapboxAPP
//
//  Created by 田子瑶 on 16/12/31.
//  Copyright © 2016年 田子瑶. All rights reserved.
//

import UIKit

class AlertController: NSObject {

    class func createAlert(leftAction: @escaping ()-> (), title: String, message: String, leftActionTitle: String, rightActionTitle: String) -> UIAlertController {
        
        let alertController = UIAlertController (title: title, message: message, preferredStyle: .alert)
        
        let leftAction = UIAlertAction(title: leftActionTitle, style: .default) { (action) in
            leftAction()
        }
        
        let rightAction = UIAlertAction(title: rightActionTitle, style: .default, handler: nil)
        
        alertController.addAction(leftAction)
        alertController.addAction(rightAction)
        
        return alertController
    }
    
}
