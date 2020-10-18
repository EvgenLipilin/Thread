//
//  Feed.swift
//  Course2FinalTask
//
//  Created by Евгений on 09.08.2020.
//  Copyright © 2020 e-Legion. All rights reserved.
//

import UIKit
import DataProvider

protocol LikeImageButtonDelegate: AnyObject {
    
    func tapLiked(post: Post)
    func tapBigLike(post: Post)
    func tapAvatarAndUserName(post: Post)
    func tapLikes(post: Post)
    func likesLabelTapped(post: Post)
    
}

class FeedCell: UICollectionViewCell {
    
    weak var delegate: LikeImageButtonDelegate?
    private let dateFormatter = DateFormatter()
    private let dateFormat = "MMM d, yyyy 'at:' HH:mm:ss"
    var post: Post? {
        
        didSet {
            heartButton.setTitle("Likes: \(post?.likedByCount ?? 0)", for: .normal)
            liked = post?.currentUserLikesThisPost ?? false
        }
    }
    
    private var liked: Bool = false {
        didSet {
            heartButton.tintColor = liked == true ? self.tintColor : .lightGray
        }
    }
    
    @IBOutlet weak var imageFeed: UIImageView!
    @IBOutlet weak var commentLabel: UILabel!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var datePost: UILabel!
    @IBOutlet weak var avatar: UIImageView!
    @IBOutlet weak var heartButton: UIButton!
    @IBOutlet weak var bigLike: UIImageView!
    @IBOutlet weak var labelLike: UILabel!
    
    override func awakeFromNib() {
        
        super.awakeFromNib()
        imageFeed.adjustsImageSizeForAccessibilityContentSizeCategory = true
        addGesture()
    }
    
    
    func setupCell() {
        avatar.image = post?.authorAvatar
        imageFeed.image = post?.image
        
        userName.text = post?.authorUsername
        dateFormatter.dateFormat = dateFormat
        datePost.text = dateFormatter.string(from: post?.createdTime ?? Date())
        
        labelLike.text = "Likes: \(post?.likedByCount ?? 0)"
        
        commentLabel.text = post?.description
        
        heartButton.setImage(#imageLiteral(resourceName: "like"), for: .normal)
        heartButton.addTarget(self, action: #selector(tap), for: .touchUpInside)
    }
    
    func addGesture() {
        let postImageGesture = UITapGestureRecognizer(target: self, action: #selector(bigLike(sender:)))
        postImageGesture.numberOfTapsRequired = 2
        imageFeed.isUserInteractionEnabled = true
        imageFeed.addGestureRecognizer(postImageGesture)
        
        let avatarAndGesture = UITapGestureRecognizer(target: self, action: #selector(tapAvatarAndUserName))
        avatar.isUserInteractionEnabled = true
        avatar.addGestureRecognizer(avatarAndGesture)
        
        let userNameGesture = UITapGestureRecognizer(target: self, action: #selector(tapAvatarAndUserName))
        userName.isUserInteractionEnabled = true
        userName.addGestureRecognizer(userNameGesture)
        
        let likesLabelTapGesture = UITapGestureRecognizer(target: self, action: #selector(tapLikesLabel))
        labelLike.isUserInteractionEnabled = true
        labelLike.addGestureRecognizer(likesLabelTapGesture)
    }
    
    @objc private func tap() {
        guard let post = post else { return }
        delegate?.tapLiked(post: post)
    }
    
    @objc func tapAvatarAndUserName() {
        guard let post = post else { return }
        delegate?.tapAvatarAndUserName(post: post)
    }
    
    private func showBigLike(completion: @escaping () -> Void) {
        let likeImage = UIImage(named: "bigLike")
        let likeView = UIImageView(image: likeImage)
        likeView.center = imageFeed.center
        likeView.layer.opacity = 0
        addSubview(likeView)
        UIView.animate(withDuration: 0.25, animations: {
            likeView.alpha = 1
        }) { _ in
            UIView.animate(withDuration: 0.25, delay: 0.15, options: .curveEaseOut, animations: {
                likeView.alpha = 0
            }) { _ in
                completion()
            }
        }
    }
    
    @objc func bigLike(sender: UITapGestureRecognizer) {
        guard let post = post else { return }
        guard post.currentUserLikesThisPost == false else { return }
        showBigLike() { [weak self] in
            guard let self = self else { return }
            self.delegate?.tapBigLike(post: post)
        }
    }
    
    @objc private func tapLikesLabel() {
        guard let post = post else { return }
        delegate?.tapLikes(post: post)
    }
}
