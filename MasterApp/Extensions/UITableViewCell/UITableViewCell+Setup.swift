//
//  UITableViewCell+Setup.swift
//  MasterApp
//
//  Created by MasterApp on 11/15/16.
//  Copyright © 2016 YSimplicity. All rights reserved.
//

import UIKit

extension UITableViewCell {
    func defaultCellSetup() {
        self.textLabel?.font = K.Font.Body
        self.textLabel?.textColor = K.Colors.Black
        self.accessoryType = .DisclosureIndicator
    }

    func destructiveCellSetup() {
        self.textLabel?.font = K.Font.Body
        self.textLabel?.textColor = K.Colors.Danger
        self.accessoryType = .None
    }
}
