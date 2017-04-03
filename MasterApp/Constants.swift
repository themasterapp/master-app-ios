//
//  Constants.swift
//  Sos
//
//  Created by MasterApp on 8/17/16.
//  Copyright © 2016 MasterApp. All rights reserved.
//

import Foundation
import UIKit

let Domain = "https://master-app-server-staging.herokuapp.com/"


struct K {
    struct Session {
        static let UserAgent = "TurbolinksDemo+iOS"

        struct ScriptMessageHandler {
            static let MasterApp = "masterApp"

            struct ResponseKeys {
                static let AuthToken = "auth_token"
                static let ScrollToTop = "scrollTop"
            }
        }
    }

    struct Localization {
        static let Portuguese = "pt-BR"
        static let English    = "en"
    }

    struct UserDefaults {
        static let AuthToken = "authToken"
    }

    struct NotificationCenter {
        static let hasDismissedForm = "dismissedForm"
    }

    struct URL {
        static let Home           = K.URL.urlFor("/")
        static let Search         = K.URL.urlFor("/?search[q]=")
        static let MyAccount      = K.URL.urlFor(Prefix.User + Suffix.Edit)
        static let SignIn         = K.URL.urlFor(Prefix.User + "/sign_in")
        static let SignOut        = K.URL.urlFor(Prefix.User + "/sign_out")
        static let SignUp         = K.URL.urlFor(Prefix.User + "/sign_up")
        static let ForgotPassword = K.URL.urlFor(Prefix.User + "/password" + Suffix.New)

        static let AddRecipe      = K.URL.urlFor(Prefix.Recipe + Suffix.New)
        static let MyRecipes      = K.URL.urlFor("/?search[filter]=my")

        struct Native {
            static let Search     = K.URL.urlFor("/native/search")
            static let More       = K.URL.urlFor("/native/more")
        }

        struct Prefix {
            static let User   = "/users"
            static let Recipe = "/recipes"
        }

        struct Suffix {
            static let New  = "/new"
            static let Edit = "/edit"
        }

        struct DefaultPrefix {
            static let Email = "mailto:"
            static let Tel = "tel:"
        }

        static func urlFor(string: String) -> NSURL {
            let str = Domain + string
            let protocolSuffixRange = str.rangeOfString("://")
            var urlString = ""
            if let indexAfterProtocol = protocolSuffixRange?.endIndex {
                let range = indexAfterProtocol..<str.endIndex
                urlString = str.stringByReplacingOccurrencesOfString("//", withString: "/", range: range)
            } else {
                urlString = str.stringByReplacingOccurrencesOfString("//", withString: "/")
            }
            guard let URL = NSURL(string: urlString) else {
                debugPrint("ERROR:", "Not valid URL:", urlString)
                return NSURL()
            }
            return URL
        }
    }

    struct Font {
        static let Body = UIFont(name: "Muli", size: 14)!
    }

    struct Colors {
        static let Primary        = UIColor(netHex:0x7a9e9f)
        static let Danger         = UIColor(netHex:0xeb5e28)

        static let Gray           = UIColor(netHex:0xf4f3ef)

        static let White          = UIColor(netHex:0xffffff)
        static let Black          = UIColor(netHex:0x000000)
    }
}
