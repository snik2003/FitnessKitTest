//
//  InnerViewController.swift
//  FitnessKitTest
//
//  Created by Сергей Никитин on 25/02/2020.
//  Copyright © 2020 Snik2003. All rights reserved.
//

import UIKit

class InnerViewController: UIViewController {

    var screenWidth: CGFloat = 0
    var screenHeight: CGFloat = 0
    
    override var shouldAutorotate: Bool {
        return false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if #available(iOS 13.0, *) {
            overrideUserInterfaceStyle = .light
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        screenWidth = self.view.bounds.width
        screenHeight = self.view.bounds.height
    }

    func showHUD() {
        OperationQueue.main.addOperation {
            ViewControllerUtils().showActivityIndicator(uiView: self.view)
            UIApplication.shared.beginIgnoringInteractionEvents()
        }
    }
    
    func hideHUD() {
        OperationQueue.main.addOperation {
            ViewControllerUtils().hideActivityIndicator()
        
            if (UIApplication.shared.isIgnoringInteractionEvents) {
                UIApplication.shared.endIgnoringInteractionEvents()
            }
        }
    }
    
    func showAttention(message: String) {
        showAttentionWithCompletion(title: "Внимание!", message: message, completion: {})
    }
    
    func showServerError() {
        showAttention(message: Settings.shared.serverErrorMessage)
    }
    
    func showAttentionWithCompletion(title: String, message: String, completion: @escaping ()->()) {
        
        let alertVC = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Закрыть", style: .default, handler: { _ in
            completion()
        })
        alertVC.addAction(action)
        
        alertVC.modalPresentationStyle = .overCurrentContext
        self.present(alertVC, animated: true, completion: nil)
    }
}
