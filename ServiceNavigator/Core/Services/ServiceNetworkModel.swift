//
//  ServiceNetworkModel.swift
//  ServiceNavigator
//
//  Created by Юрий Степанчук on 30.03.2024.
//

import Foundation

struct ServicesNetworkModel: Codable {
    let body: Body
    let status: Int
}

struct Body: Codable {
    let services: [Service]
}

struct Service: Codable {
    let name: String
    let description: String
    let link: String
    let iconURL: String
    var iconImageData: Data?

    enum CodingKeys: String, CodingKey {
        case name
        case description
        case link
        case iconURL = "icon_url"
    }
}

