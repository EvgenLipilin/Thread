//
//  ProfileHeader.swift
//  Course2FinalTask
//
//  Created by Евгений on 09.08.2020.
//  Copyright © 2020 e-Legion. All rights reserved.
//

import UIKit
import DataProvider


let identifierHeader = "ProfileHeaderCell"

protocol FollowUnfollowDelegate: AnyObject {
    func tapFollowUnfollowButton(user: User)
}

class ProfileHeaderCell: UICollectionViewCell {
    
    weak var delegate: FollowUnfollowDelegate?
    var currentUser: User?
    
    var user: User? {
        didSet {
            if currentUser?.id == user?.id {
                followUnfollowButton.isHidden = true
            } else {
                if user?.currentUserFollowsThisUser == true {
                    followUnfollowButton.setTitle("Unfollow", for: .normal)
                    followUnfollowButton.isHidden = false
                } else {
                    followUnfollowButton.setTitle("Follow", for: .normal)
                    followUnfollowButton.isHidden = false
                }
            }
        }
    }
    
    private let nameLabel: UILabel = {
        let label = UILabel(frame: .init(x: 0, y: 0, width: 100, height: 10))
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 14)
        return label
    }()
    
    let followersButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.titleLabel?.font = .systemFont(ofSize: 14, weight: .semibold)
        button.setTitleColor(.black, for: .normal)
        return button
    }()
    
    let followingButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.titleLabel?.font = .systemFont(ofSize: 14, weight: .semibold)
        button.setTitleColor(.black, for: .normal)
        return button
    }()
    
    private let avatarImageView: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.clipsToBounds = true
        image.contentMode = .scaleAspectFit
        image.layer.cornerRadius = 35
        return image
    }()
    
    let followUnfollowButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.titleLabel?.font = .systemFont(ofSize: 15)
        button.backgroundColor = #colorLiteral(red: 0, green: 0.5882352941, blue: 1, alpha: 1)
        button.setTitleColor(.white, for: .normal)
        button.contentEdgeInsets = .init(top: 6, left: 6, bottom: 6, right: 6)
        button.layer.cornerRadius = 7
        button.isHidden = true
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        confUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func createCell() {
        guard let user = user else { return }
        nameLabel.text = user.fullName
        followersButton.setTitle("Followers: \(user.followedByCount)", for: .normal)
        followingButton.setTitle("Following: \(user.followsCount)", for: .normal)
        avatarImageView.image = user.avatar
        
        followUnfollowButton.addTarget(self, action: #selector(tapFollowUnfollow), for: .touchUpInside)
    }
    
    @objc private func tapFollowUnfollow() {
        guard let user = user else { return }
        delegate?.tapFollowUnfollowButton(user: user)
    }
    
    private func confUI() {
        addSubview(avatarImageView)
        addSubview(nameLabel)
        addSubview(followersButton)
        addSubview(followingButton)
        addSubview(followUnfollowButton)
        
        let constraints = [avatarImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 8),
                           avatarImageView.topAnchor.constraint(equalTo: self.topAnchor, constant: 8),
                           avatarImageView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -8),
                           avatarImageView.widthAnchor.constraint(equalTo: avatarImageView.heightAnchor),
                           
                           nameLabel.leadingAnchor.constraint(equalTo: avatarImageView.trailingAnchor, constant: 8),
                           nameLabel.topAnchor.constraint(equalTo: avatarImageView.topAnchor),
                           
                           followersButton.leadingAnchor.constraint(equalTo: avatarImageView.trailingAnchor, constant: 8),
                           followersButton.bottomAnchor.constraint(equalTo: avatarImageView.bottomAnchor),
                           
                           followingButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -8),
                           followingButton.bottomAnchor.constraint(equalTo: avatarImageView.bottomAnchor),
                           
                           followUnfollowButton.topAnchor.constraint(equalTo: nameLabel.topAnchor),
                           followUnfollowButton.trailingAnchor.constraint(equalTo: followingButton.trailingAnchor)]
        
        NSLayoutConstraint.activate(constraints)
    }
}
