//
//  users.swift
//  thirdTask
//
//  Created by Владимир Курганов on 13.09.2022.
//

import Foundation
import UIKit

// MARK: - Models
struct Profile: Decodable {
    let results: [ResultPhoto]
}

struct ResultPhoto: Decodable {
    let urls: Urls?
    let user: User?
    let description: String?
}

struct Urls: Decodable {
    let regular: String?
}

struct User: Decodable {
    let firstName: String?
    let lastName: String?

    enum CodingKeys: String, CodingKey {
        case firstName = "first_name"
        case lastName = "last_name"
    }
}
