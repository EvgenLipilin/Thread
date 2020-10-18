//
//  CustomTableViewCellExtension.swift
//  Course2FinalTask
//
//  Created by Артем Скрипкин on 06.08.2020.
//  Copyright © 2020 e-Legion. All rights reserved.
//

import Foundation
import UIKit
import DataProvider

//extension CustomTableViewCell {
//    func likePost() {
//        guard likeState == false else { return }
//        guard let postID = postIdentifier else { return }
//        guard let likesCount = DataProviders.shared.postsDataProvider.post(with: postID)?.likedByCount else { return }
//        guard let isCurrentLikedPost = DataProviders.shared.postsDataProvider.post(with: postID)?.currentUserLikesThisPost else { return }
//        
//        likeState = true
//        likeButtonOutlet.tintColor = .blue
//        
//        if isCurrentLikedPost == true {
//            likes.text = "Likes: \(likesCount)"
//        } else {
//            likes.text = "Likes: \(likesCount + 1)"
//        }
//    }
//    
//    func dislikePost() {
//        guard likeState == true else { return }
//        guard let postID = postIdentifier else { return }
//        guard let likesCount = DataProviders.shared.postsDataProvider.post(with: postID)?.likedByCount else { return }
//        guard let isCurrentLikedPost = DataProviders.shared.postsDataProvider.post(with: postID)?.currentUserLikesThisPost else { return }
//        
//        likeState = false
//        likeButtonOutlet.tintColor = .gray
//        
//        if isCurrentLikedPost == true {
//            likes.text = "Likes: \(likesCount - 1)"
//        } else {
//            likes.text = "Likes: \(likesCount)"
//        }
//        
//        
//    }
//    
//    func showBigLike() {
//        let likeImage = UIImage(named: "bigLike")
//        let likeView = UIImageView(image: likeImage)
//        likeView.center = CGPoint(x: bigImage.center.x, y: bigImage.center.y)
//        likeView.layer.opacity = 0
//        addSubview(likeView)
//        
//        let animation = CAKeyframeAnimation(keyPath: #keyPath(CALayer.opacity))
//        animation.duration = 0.6
//        animation.values = [1, 1, 0]
//        animation.keyTimes = [0.1, 0.3, 0.6]
//        animation.timingFunctions = [.init(name: .linear), .init(name: .linear), .init(name: .easeOut)]
//        animation.isRemovedOnCompletion = true
//        likeView.layer.add(animation, forKey: "showAndHideBigLike")
//    }
//    
//    func addGestures() {
//        let gs = UITapGestureRecognizer(target: self, action: #selector(bigLike(sender:)))
//        gs.numberOfTapsRequired = 2
//        bigImage.isUserInteractionEnabled = true
//        bigImage.addGestureRecognizer(gs)
//        
//        let gs2 = UITapGestureRecognizer(target: self, action: #selector(likesButtonPressed(sender:)))
//        likes.isUserInteractionEnabled = true
//        likes.addGestureRecognizer(gs2)
//        
//        let gs3 = UITapGestureRecognizer(target: self, action: #selector(authorAvatarPressed(sender:)))
//        avatar.isUserInteractionEnabled = true
//        avatar.addGestureRecognizer(gs3)
//    }
//    
//    
//    
//    func configureCell(_ info: CellData) {
//        let dateFormatter = DateFormatter()
//        dateFormatter.dateStyle = .short
//        dateFormatter.timeStyle = .short
//        
//        if info.isCurrentLikedPost == true {
//            likeButtonOutlet.tintColor = .blue
//            likeState = true
//        } else {
//            likeButtonOutlet.tintColor = .gray
//        }
//        
//        likes.text = "Likes: \(info.likesCount)"
//        descriprion.text = info.postText
//        bigImage.image = info.postImage
//        avatar.image = info.authorAvatar
//        name.text = info.authorName
//        date.text = dateFormatter.string(from: info.postPublishedDate)
//        
//        indexPath = info.indexPath
//        postIdentifier = info.postIdentifier
//    }
//}
//
//struct CellData {
//    var postIdentifier: Post.Identifier
//    
//    var indexPath: IndexPath
//    
//    var likesCount: Int
//    
//    var postText: String
//    
//    var authorName: String
//    
//    var postPublishedDate: Date
//    
//    var postImage: UIImage
//    
//    var authorAvatar: UIImage?
//    
//    var isCurrentLikedPost: Bool
//    
//    init(postIdentifier: Post.Identifier, indexPath: IndexPath, likesCount: Int, postText: String, authorName: String, postPublishedDate: Date, postImage: UIImage, authorAvatar: UIImage?, isCurrentLikedPost: Bool) {
//        self.postIdentifier = postIdentifier
//        self.indexPath = indexPath
//        self.likesCount = likesCount
//        self.postText = postText
//        self.authorName = authorName
//        self.postPublishedDate = postPublishedDate
//        self.postImage = postImage
//        self.authorAvatar = authorAvatar
//        self.isCurrentLikedPost = isCurrentLikedPost
//    }
//    
//}
