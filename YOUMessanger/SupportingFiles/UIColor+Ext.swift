//
//  UIColor+Ext.swift
//  YOUMessanger
//
//  Created by Shubham Saurav on 10/18/18.
//  Copyright © 2018 Shubham Saurav. All rights reserved.
//

import Foundation
import UIKit

extension UIColor {
    
    static func rgb(red: CGFloat, green: CGFloat, blue: CGFloat) -> UIColor {
        return UIColor(red: red/255, green: green/255, blue: blue/255, alpha: 1)
    }
}
