//
//  ARActivityIndicator.swift
//  ThemeSample
//
//  Created by Ashok Rawat on 14/06/22.
//

import Foundation
import UIKit

class ARActivityIndicator {
    var container: UIView = UIView()
    var loadingView: UIView = UIView()
    var activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView()

    func startIndicatorView( uiView: UIView,  style: UIActivityIndicatorView.Style = .large,  indicatorBgColor: UIColor = .white,  loadingBgColor: UIColor = .lightGray ) {
        
        loadingView.frame = CGRect(x: uiView.bounds.width / 2 - 20, y: uiView.bounds.height / 2 - 20, width: 40, height: 40)
        loadingView.backgroundColor = loadingBgColor
        loadingView.clipsToBounds = true
        loadingView.layer.cornerRadius = 10
        
        activityIndicator.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
        activityIndicator.style = style
        activityIndicator.center = CGPoint(x: loadingView.frame.size.width / 2, y: loadingView.frame.size.height / 2)
        activityIndicator.color = indicatorBgColor
        
        loadingView.addSubview(activityIndicator)
        uiView.addSubview(loadingView)
        activityIndicator.startAnimating()
    }
    
    func hideIndicatorView() {
        DispatchQueue.main.async {
            self.activityIndicator.stopAnimating()
            self.loadingView.removeFromSuperview()
            self.container.removeFromSuperview()
        }
    }
    func UIColorFromHex(_ rgbValue: UInt32, alpha: Double = 1.0) -> UIColor {
        let red = CGFloat((rgbValue & 0xFF0000) >> 16)/256.0
        let green = CGFloat((rgbValue & 0xFF00) >> 8)/256.0
        let blue = CGFloat(rgbValue & 0xFF)/256.0
        return UIColor(red: red, green: green, blue: blue, alpha: CGFloat(alpha))
    }
}
