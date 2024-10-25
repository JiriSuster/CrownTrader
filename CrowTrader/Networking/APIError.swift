//
//  APIError.swift
//  CrowTrader
//
//  Created by Jiří Daniel Šuster on 25.10.2024.
//

import Foundation

enum APIError: Error {
    case urlRequestError
    case urlSessionError
    case parsingError
}
