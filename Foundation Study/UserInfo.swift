//
//  UserInfo.swift
//  Foundation Study
//
//  Created by LMC60018 on 2024/1/15.
//

import Foundation

struct UserURLInfo: Codable {
    let login: String
    let id: Int
    let node_id: String
    let avatar_url: URL
    let gravatar_id: String
    let url: URL
    let html_url: URL
    let name: String
    let company: String?
    let email: String?
    let hireable: Bool
    let followers: Int
    let following: Int
}
