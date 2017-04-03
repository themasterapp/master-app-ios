//
//  UIViewController+Log.swift
//  Sos
//
//  Created by MasterApp on 11/2/16.
//  Copyright © 2016 MasterApp. All rights reserved.
//

import UIKit

extension UIViewController {
    func printGuardError(items: Any...) {
        debugPrint("Guard ERROR:", items)
    }
}
