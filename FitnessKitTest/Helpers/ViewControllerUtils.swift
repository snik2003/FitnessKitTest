//
//  ViewControllerUtils.swift
//  FitnessKitTest
//
//  Created by Сергей Никитин on 25/02/2020.
//  Copyright © 2020 Snik2003. All rights reserved.
//

import UIKit

class ViewControllerUtils {
    
    private static var container: UIView = UIView()
    private static var loadingView: UIView = UIView()
    private static var mainLabel: UILabel = UILabel()
    private static var detailLabel: UILabel = UILabel()
    private static var activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView()
    
    func showActivityIndicator(uiView: UIView) {
        ViewControllerUtils.container.frame = uiView.frame
        ViewControllerUtils.container.center = uiView.center
        ViewControllerUtils.container.backgroundColor = UIColor(white: 1.0, alpha: 0.7)
        
        let frame = CGRect(x: 0, y: 0, width: 140, height: 105)
        ViewControllerUtils.loadingView.frame = frame
        ViewControllerUtils.loadingView.center = uiView.center
        ViewControllerUtils.loadingView.backgroundColor = UIColor(white: 0, alpha: 0.7)
        ViewControllerUtils.loadingView.clipsToBounds = true
        ViewControllerUtils.loadingView.layer.cornerRadius = 4
        
        ViewControllerUtils.activityIndicator.frame = CGRect(x: frame.width/2 - 20, y: 12, width: 40, height: 40);
        ViewControllerUtils.activityIndicator.style = UIActivityIndicatorView.Style.whiteLarge
        ViewControllerUtils.activityIndicator.color = .white
        ViewControllerUtils.activityIndicator.clipsToBounds = false
        
        ViewControllerUtils.mainLabel.text = "Подождите..."
        ViewControllerUtils.mainLabel.frame = CGRect(x: 0, y: 55, width: frame.width, height: 20)
        ViewControllerUtils.mainLabel.textColor = .white
        ViewControllerUtils.mainLabel.font = .boldSystemFont(ofSize: 16)
        ViewControllerUtils.mainLabel.textAlignment = .center
        
        ViewControllerUtils.detailLabel.text = "Обновление данных"
        ViewControllerUtils.detailLabel.frame = CGRect(x: 0, y: 75, width: frame.width, height: 20)
        ViewControllerUtils.detailLabel.textColor = .white
        ViewControllerUtils.detailLabel.font = .boldSystemFont(ofSize: 12)
        ViewControllerUtils.detailLabel.textAlignment = .center
        
        ViewControllerUtils.loadingView.addSubview(ViewControllerUtils.activityIndicator)
        ViewControllerUtils.loadingView.addSubview(ViewControllerUtils.mainLabel)
        ViewControllerUtils.loadingView.addSubview(ViewControllerUtils.detailLabel)
        
        ViewControllerUtils.container.addSubview(ViewControllerUtils.loadingView)
        uiView.addSubview(ViewControllerUtils.container)
        ViewControllerUtils.activityIndicator.startAnimating()
    }
    
    func hideActivityIndicator() {
        ViewControllerUtils.activityIndicator.stopAnimating()
        ViewControllerUtils.container.removeFromSuperview()
    }
}

extension UIView {
    var visibleRect: CGRect {
        guard let superview = superview else { return frame }
        return frame.intersection(superview.bounds)
    }
}
