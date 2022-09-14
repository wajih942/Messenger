//
//  Extensions.swift
//  Messenger
//
//  Created by wajih on 8/28/22.
//

import UIKit

extension UIImage{
    // WE ARE EXTENDING THE FUNCTIONALITIES OF our uiimage and we want to add extra functions
    // we need first to understand if the image is portrait or landscape
    var isPortrait: Bool { return size.height > size.width}
    var isLandscape: Bool { return size.width > size.height}
    var breadth : CGFloat{return min(size.width,size.height)}
    var breadthSize : CGSize {return CGSize(width: breadth, height: breadth)}
    var breadthRect : CGRect{return CGRect(origin: .zero, size: breadthSize)}
    var circleMasked: UIImage?{
        UIGraphicsBeginImageContextWithOptions(breadthSize, false, scale)
        defer {
            UIGraphicsEndImageContext()
        }
        guard let cgImage = cgImage?.cropping(to: CGRect(origin: CGPoint(x: isLandscape ? floor(size.width - size.height)/2 : 0, y: isPortrait ? floor(size.height - size.width)/2 : 0 ), size: breadthSize)) else { return nil}
        UIBezierPath(ovalIn: breadthRect).addClip()
        UIImage(cgImage: cgImage).draw(in: breadthRect)
        return UIGraphicsGetImageFromCurrentImageContext()
    }
    
}


extension Date{
    func longDate() -> String{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MMM yyyy"
        return dateFormatter.string(from: self)
    }
    func time() -> String{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        return dateFormatter.string(from: self)
    }
}
