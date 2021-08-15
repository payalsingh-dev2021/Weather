//
//  ReusableView.swift
//  Weather
//
//  Created by Payal Singh on 15/08/21.
//

import Foundation
import UIKit

protocol ReusableView {

    static var reuseIdentifier: String { get }

}

extension ReusableView {

    static var reuseIdentifier: String {
        return String(describing: self)
    }

}

extension UITableViewCell: ReusableView {}
