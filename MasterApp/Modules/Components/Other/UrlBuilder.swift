//
//  UrlBuilder.swift
//  MasterApp
//
//  Created by MasterApp on 11/15/16.
//  Copyright © 2016 YSimplicity. All rights reserved.
//

import Foundation

/*!
 This struct builds the URL for the app.
 It adds the localization and authToken to the URL
 */
struct UrlBuilder {
    private var URL : NSURL

    init(URL: NSURL) {
        self.URL = URL
    }

    func build() -> NSURL {
        let finalUrl = urlWithAuthToken(urlForLocalization(URL))
        return finalUrl
    }

    private func urlForLocalization(URL: NSURL) -> NSURL {
        let nextLanguage = NSLocale.currentLocale().localeIdentifier

        let newLocaleUrl = nextLanguage.hasPrefix("pt") ? K.Localization.Portuguese : K.Localization.English
        let localeQuery = NSURLQueryItem(name: "locale", value: newLocaleUrl)
        let components = NSURLComponents(URL: URL, resolvingAgainstBaseURL: false)
        if (components?.queryItems == nil) {
            components?.queryItems = [localeQuery]
        } else {
            components?.queryItems?.append(localeQuery)
        }
        let finalUrl = components?.URL ?? URL

        return finalUrl
    }

    private func urlWithAuthToken(URL: NSURL) -> NSURL {
        let components = NSURLComponents(URL: URL, resolvingAgainstBaseURL: false)
        let token = UserSessionManager.sharedInstance.authToken()
        guard !token.isEmpty else {
            return URL
        }

        let authTokenQuery = NSURLQueryItem(name: "auth_token", value: UserSessionManager.sharedInstance.authToken())
        if (components?.queryItems == nil) {
            components?.queryItems = [authTokenQuery]
        } else {
            components?.queryItems?.append(authTokenQuery)
        }
        let finalUrl = components?.URL ?? URL
        
        return finalUrl
    }
}
