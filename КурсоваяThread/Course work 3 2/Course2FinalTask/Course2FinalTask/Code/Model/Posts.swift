//
//  Posts.swift
//  Course2FinalTask
//
//  Created by Евгений on 26.07.2020.
//  Copyright © 2020 e-Legion. All rights reserved.
//

import Foundation
import DataProvider

let posts = DataProviders.shared.postsDataProvider


class Posts: PostsDataProviderProtocol {
    func feed(queue: DispatchQueue?, handler: @escaping ([Post]?) -> Void) {
        posts.feed(queue: queue, handler: handler)
        
    }
    
    func post(with postID: Post.Identifier, queue: DispatchQueue?, handler: @escaping (Post?) -> Void) {
        posts.post(with: postID,queue: queue,handler: handler)
    }
    
    func findPosts(by authorID: User.Identifier, queue: DispatchQueue?, handler: @escaping ([Post]?) -> Void) {
        posts.findPosts(by: authorID,queue: queue,handler: handler)
    }
    
    func likePost(with postID: Post.Identifier, queue: DispatchQueue?, handler: @escaping (Post?) -> Void) {
        posts.likePost(with: postID,queue: queue,handler: handler)
    }
    
    func unlikePost(with postID: Post.Identifier, queue: DispatchQueue?, handler: @escaping (Post?) -> Void) {
        posts.unlikePost(with: postID,queue: queue,handler: handler)
    }
    
    func usersLikedPost(with postID: Post.Identifier, queue: DispatchQueue?, handler: @escaping ([User]?) -> Void) {
        posts.usersLikedPost(with: postID,queue: queue,handler: handler)
    }
    
    func newPost(with image: UIImage, description: String, queue: DispatchQueue?, handler: @escaping (Post?) -> Void) {
        posts.newPost(with: image, description: description, queue: queue, handler: handler)
    }
}

