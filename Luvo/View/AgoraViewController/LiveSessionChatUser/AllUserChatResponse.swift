//
//  AllUserChatResponse.swift
//  Luvo
//
//  Created by BEASiMAC on 28/12/22.
//

import Foundation

struct AllUserChatResponse: Decodable
{
    let status: String?
    let message: String?
    let results: [resultAll]?
    
    enum CodingKeys: String, CodingKey {
        
        case status
        case message
        case results
    }
    
}

struct resultAll: Decodable
{
    let userName: String?
    let userEmail: String?
    let text: String?
    let sessionId: String?
    let profileImg: String?
    let mobileNo: String?
    let location: String?
    let chatOn: String?
    
    enum CodingKeys: String, CodingKey {
        case userName
        case userEmail
        case text
        case sessionId
        case profileImg
        case mobileNo
        case location
        case chatOn
    }
    
}
