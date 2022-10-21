//
//  UIImageView+Extension.swift
//  ThemeSample
//
//  Created by Ashok Rawat on 09/06/22.
//

import Foundation
import UIKit

let imageCache = NSCache<NSString, UIImage>()

extension UIImageView {
    
    // MARK: - Using Closure
    
    func loadImageUsingCacheWithURLString(_ url: URL) {
        self.image = nil
        
        if let cacheImage = imageCache.object(forKey: NSString(string: url.absoluteString)) {
            self.image = cacheImage
            return
        }
        let indicator = ARActivityIndicator()
        indicator.startIndicatorView(uiView: self)
        URLSession.shared.dataTask(with: url, completionHandler: { (data, _, error) in
            indicator.hideIndicatorView()
            if error != nil {
                return
            }
            if let data = data {
                DispatchQueue.main.async {
                    if let downloadImage = UIImage(data: data) {
                        imageCache.setObject(downloadImage, forKey: NSString(string: url.absoluteString))
                        self.image = downloadImage
                    }
                    else {
                        self.loadImageUsingCacheWithURLString(URL(string: "http://via.placeholder.com/80x80")!)
                    }
                }
            }
        }).resume()
    }
}



extension UIImageView {
    
    // MARK: - Using Async Await
    
     func asynAwaitloadImageUsingCacheFromURL(_ url: URL) async throws {
        self.image = nil
        let indicator = ARActivityIndicator()
        
        if let cacheImage = imageCache.object(forKey: NSString(string: url.absoluteString)) {
            self.image = cacheImage
            return
        }
        indicator.startIndicatorView(uiView: self, indicatorBgColor: .blue, loadingBgColor: .white)
        do {
            let ( data, _) = try await URLSession.shared.data(from: url)
            indicator.hideIndicatorView()
            if let downloadImage = UIImage(data: data) {
                imageCache.setObject(downloadImage, forKey: NSString(string: url.absoluteString))
                self.image = downloadImage
            }
            else {
                try await asynAwaitloadImageUsingCacheFromURL(URL(string: "http://via.placeholder.com/80x80")!)
            }
        } catch {
            throw error
        }
    }
}



/*
 
 guard let downloadImage = UIImage(data: data) else {
     return
 }
 imageCache.setObject(downloadImage, forKey: NSString(string: url.absoluteString))
 */
