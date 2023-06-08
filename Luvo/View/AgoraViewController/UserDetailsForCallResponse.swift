//
//  UserDetailsForCallResponse.swift
//  Luvo
//
//  Created by BEASiMAC on 02/03/23.
//

import Foundation

struct UserDetailsForCallResponse : Decodable
{
    let status: String?
    let message: String?
    let details: userdetails?
    
    enum CodingKeys: String, CodingKey {

        case status
        case message
        case details

    }
}

struct userdetails : Decodable
{
    let agoraAppId: String?
    let agoraAccessToken: String?
    let channelName: String?
    let _id: String?
    let agoraUId: String?
    let callId: String?
    
    enum CodingKeys: String, CodingKey {
        case agoraAppId
        case agoraAccessToken
        case channelName
        case _id
        case agoraUId
        case callId
        
    }
}
