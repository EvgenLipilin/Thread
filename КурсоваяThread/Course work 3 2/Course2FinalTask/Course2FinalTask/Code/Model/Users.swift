//
//  Users.swift
//  Course2FinalTask
//
//  Created by Евгений on 26.07.2020.
//  Copyright © 2020 e-Legion. All rights reserved.
//

import Foundation
import DataProvider

let users = DataProviders.shared.usersDataProvider

class Users: UsersDataProviderProtocol {
    func currentUser(queue: DispatchQueue?, handler: @escaping (User?) -> Void) {
        users.currentUser(queue: queue, handler: handler)
    }
    
    func user(with userID: User.Identifier, queue: DispatchQueue?, handler: @escaping (User?) -> Void) {
        users.user(with: userID,queue: queue,handler: handler)
    }
    
    func follow(_ userIDToFollow: User.Identifier, queue: DispatchQueue?, handler: @escaping (User?) -> Void) {
        users.follow(userIDToFollow,queue: queue,handler: handler)
    }
    
    func unfollow(_ userIDToUnfollow: User.Identifier, queue: DispatchQueue?, handler: @escaping (User?) -> Void) {
        users.unfollow(userIDToUnfollow,queue: queue,handler: handler)
    }
    
    func usersFollowingUser(with userID: User.Identifier, queue: DispatchQueue?, handler: @escaping ([User]?) -> Void) {
        users.usersFollowingUser(with: userID,queue: queue,handler: handler)
    }
    
    func usersFollowedByUser(with userID: User.Identifier, queue: DispatchQueue?, handler: @escaping ([User]?) -> Void) {
        users.usersFollowedByUser(with: userID,queue: queue,handler: handler)
    }
}
