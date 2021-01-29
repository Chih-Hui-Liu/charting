//
//  Constants.swift
//  charting
//
//  Created by Leo on 2021/1/27.
//

import Foundation

struct keys {
   static let registerSegue = "RegisterToChart"
    static let loginSegue = "LoginTochart"
    static let cellIdentifier = "ReusableCell"
    static let cellNibName = "MessageCell"
    struct FStore {
        static let collectionName = "messages"
        static let senderField = "sender"
        static let bodyField = "body"
        static let dateField = "date"
    }
}
