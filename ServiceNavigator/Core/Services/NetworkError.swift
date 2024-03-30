//
//  NetworkError.swift
//  ServiceNavigator
//
//  Created by Юрий Степанчук on 30.03.2024.
//

import Foundation

enum NetworkError: Error {
    case invalidURL
    case noInternetConnection
    case requestFailed
    case noServerResponse
    case noDataInServerResponse
    case decodingFailed
    case badResponse(statusCode: Int)

    var localizedDescription: String {
        switch self {
        case .invalidURL:
            return "Invalid URL"
        case .noInternetConnection:
            return "Unable to fetch services information. Check your internet connection."
        case .requestFailed:
            return "Request Failed"
        case .noServerResponse:
            return "There is no response from the server"
        case .noDataInServerResponse:
            return "There is no data in the server response"
        case .decodingFailed:
            return "Decoding Failed"
        case let .badResponse(statusCode: statusCode):
            return "There is a bad server response. StatusCode: \(statusCode)"
        }
    }
}
