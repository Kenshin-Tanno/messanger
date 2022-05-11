//
//  ConveeersationsModels.swift
//  Messanger
//
//  Created by 丹野健心 on 2022/04/24.
//

import Foundation

struct Conversation {
    let id: String
    let name: String
    let otherUserEmail: String
    let latestMessage: LatestMessage
}

struct LatestMessage {
    let date: String
    let text: String
    let isRead: Bool
}
