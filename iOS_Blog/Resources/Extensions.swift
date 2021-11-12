//
//  Extensions.swift
//  iOS_Blog
//
//  Created by wooyeong kam on 2021/11/11.
//

import Foundation
import UIKit

extension UIView {
    var width : CGFloat {
        return frame.size.width
    }
    var height: CGFloat {
        return frame.size.height
    }
    var top : CGFloat {
        return frame.origin.y
    }
    var bottom : CGFloat {
        return frame.origin.y + frame.size.height
    }
    var left : CGFloat {
        return frame.origin.x
    }
    var right : CGFloat {
        return frame.origin.x + frame.size.width
    }
}
