//
//  UITableViewCell+Extensions.swift
//  Assessment
//
//  Created by Oxyminds Sdn bhd on 26/12/2023.
//

import Foundation
import UIKit

extension UITableViewCell {
    class var identifier: String { return String.className(self) }
    
    static func getNib() -> UINib {
        return UINib(nibName: identifier, bundle: nil)
    }
}
