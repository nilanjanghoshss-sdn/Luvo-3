//
//  HomeResponse.swift
//  Luvo
//
//  Created by BEASMACUSR02 on 05/10/21.
//

import Foundation

struct HomeResponse: Decodable {
    let status: String?
    let quotes: Quotes?
    let mood: Mood?
    let sleep: Sleep?
    let heartRate: HeartRate?
    let waterIntaked: WaterIntaked?
    let distances: Distances
    let point: Point?
    let gratitude: Gratitude?
    let blogs: [Blogs]?
    let exercises: [Exercises]?
    let daily_goal: Int?
    let unread_notification: Int?
    let user_badges: [BadgeModel]?
    
    enum CodingKeys: String, CodingKey {
        case status
        case quotes
        case mood
        case sleep
        case heartRate
        case waterIntaked
        case distances
        case point
        case gratitude
        case blogs
        case exercises
        case daily_goal
        case unread_notification
        case user_badges
    }
}

struct Quotes: Decodable {
    let quote: String?
    let authorName: String?
    
    enum CodingKeys: String, CodingKey {
        case quote
        case authorName
    }
}

struct Mood: Decodable {
    let mood: String?
    
    enum CodingKeys: String, CodingKey {
        case mood
    }
}

struct Sleep: Decodable {
    let sleep: Int?
    
    enum CodingKeys: String, CodingKey {
        case sleep
    }
}

struct HeartRate: Decodable {
    let heartRate: Double?
    
    enum CodingKeys: String, CodingKey {
        case heartRate
    }
}

struct WaterIntaked: Decodable {
    let waterIntake: Int?
    
    enum CodingKeys: String, CodingKey {
        case waterIntake
    }
}

struct Distances: Decodable {
    let steps: Int?
    let miles: Double?
    
    enum CodingKeys: String, CodingKey {
        case steps
        case miles
    }
}

struct Point: Decodable {
    let totalPoint: Int?
    
    enum CodingKeys: String, CodingKey {
        case totalPoint
    }
}

struct Gratitude: Decodable {
    let categoryId: String?
    let categoryName: String?
    let message: String?
    
    enum CodingKeys: String, CodingKey {
        case categoryId
        case categoryName
        case message
    }
}

//struct Blogs: Decodable {
//    let add_date: String?
//    let blogId: String?
//    let blog_img: String?
//    let description: String?
//    let title: String?
//
//    enum CodingKeys: String, CodingKey {
//        case add_date
//        case blogId
//        case blog_img
//        case description
//        case title
//    }
//}
struct Blogs: Decodable {
    let add_date: String?
    let blogId: String?
    let blog_img: String?
    let description: String?
    let title: String?
    let user: [HomeBlogUser]?
    let likes: Int?
    let tot_likes: Int?
    let location: String?
    
    enum CodingKeys: String, CodingKey {
        case add_date
        case blogId
        case blog_img
        case description
        case title
        case user
        case likes
        case tot_likes
        case location
    }
}
struct HomeBlogUser: Decodable {
    let userName: String?
    let userId: String?
    
    enum CodingKeys: String, CodingKey {
        case userName
        case userId
    }
}

struct Exercises: Decodable {
    let add_date: String?
    let description: String?
    let exerciseId: String?
    let exercise_img: String?
    let name: String?
    let location: String?
    
    enum CodingKeys: String, CodingKey {
        case add_date
        case description
        case exerciseId
        case exercise_img
        case name
        case location
    }
}
