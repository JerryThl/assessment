//
//  Date+Extensions.swift
//  Assessment
//
//  Created by Oxyminds Sdn bhd on 27/12/2023.
//

import Foundation
import UIKit

extension Date{
    
    func formatDate(newFormat:String) -> String {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = newFormat
        return dateFormatter.string(from: self)
        
    }

}
