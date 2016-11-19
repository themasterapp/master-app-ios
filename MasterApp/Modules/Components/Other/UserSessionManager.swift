//
//  UserSessionManager.swift
//  Sos
//
//  Created by Taqtile on 8/29/16.
//  Copyright © 2016 Taqtile. All rights reserved.
//

import UIKit

/*!
 Use this class to manage the User Session. It can tell wheter a user is logged, what the authToken is.
 Use it to save the authToken and to logout (to erase the authToken)
 */
class UserSessionManager: NSObject {
    static let sharedInstance = UserSessionManager()
    private override init() {}

    func isUserLogged() -> Bool {
        return !authToken().isEmpty
    }

    func authToken() -> String {
        let authToken = NSUserDefaults.standardUserDefaults().objectForKey(K.UserDefaults.AuthToken) as? String
        return authToken ?? ""
    }

    func saveAuthToken(token : String) {
        NSUserDefaults.standardUserDefaults().setObject(token, forKey: K.UserDefaults.AuthToken)
    }

    func logout() {
        NSUserDefaults.standardUserDefaults().setObject("", forKey: K.UserDefaults.AuthToken)
    }
}
