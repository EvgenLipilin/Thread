//
//  ProfileViewController.swift
//  Course2FinalTask
//
//  Created by Евгений on 26.07.2020.
//  Copyright © 2020 e-Legion. All rights reserved.

import UIKit
import DataProvider


class ProfileViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    private let userClass = Users()
    private let postClass = Posts()
    private lazy var block = BlockViewController(view: (tabBarController?.view)!)
    private lazy var alert = AlertViewController(view: self)
    var user: User?
    var currentUser: User?
    private var usersFollowingUser: [User]?
    private var usersFollowedByUser: [User]?
    private var postsOfCurrentUser: [Post]?
    private let nibNameAndIdentifier = "ProfileCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        createCurrentUserAndPosts()
        
        collectionView.register(UINib(nibName: nibNameAndIdentifier, bundle: nil), forCellWithReuseIdentifier: nibNameAndIdentifier)
        collectionView.register(ProfileHeaderCell.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: identifierHeader)
        
        collectionView.dataSource = self
        collectionView.delegate = self
    }
    
    //    Обновляет массив постов при публикации нового поста
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        createPostsArray()
    }
    
    // Создает текущего пользователя и массив его постов
    private func createCurrentUserAndPosts() {
        
        //Создает профиль текущего пользователя
        if self.user == nil {
            block.startAnimating()
            self.userClass.currentUser(queue: .global()) { [weak self] (user) in
                guard let self = self else { return }
                guard user != nil else { return }
                self.currentUser = user
                self.user = user
                DispatchQueue.main.async {
                    self.navigationItem.title = self.user?.username
                    self.createPostsArray()
                }
            }
            
            // Создание профилей других пользователей
        } else {
            DispatchQueue.main.async {
                self.navigationItem.title = self.user?.username
            }
            createPostsArray()
        }
    }
    
    //Создание массива постов
    private func createPostsArray() {
        
        block.startAnimating()
        guard self.user != nil else { return }
        self.postClass.findPosts(by: self.user!.id, queue: .global()) { [weak self] (postsArray) in
            guard let self = self else { return }
            guard postsArray != nil else { return }
            self.postsOfCurrentUser = postsArray
            DispatchQueue.main.async {
                self.collectionView.reloadData()
                self.block.stopAnimating()
            }
        }
    }
    
    //Переход на страницу подписчиков
    private func presentFollowers(button: UIButton) {
        button.addTarget(self, action: #selector(presentVCFollowers), for: .touchUpInside)
    }
    
    //Переход на страницу подписчиков*
    @objc private func presentVCFollowers() {
        
        block.startAnimating()
        guard let user = user else { return }
        userClass.usersFollowingUser(with: user.id , queue: .global()) { [weak self] (usersArray) in
            guard let self = self else { return }
            guard usersArray != nil else { return }
            self.usersFollowingUser = usersArray
            if let array = self.usersFollowingUser {
                DispatchQueue.main.async {
                    self.block.stopAnimating()
                    self.navigationController?.pushViewController(FollowersTableViewController(usersArray: array, titleName: "Followers", user: user), animated: true)
                }
            }
        }
    }
    
    //Переход на страницу подписок
    private func presentFollowing(button: UIButton) {
        button.addTarget(self, action: #selector(presentVCFollowing), for: .touchUpInside)
    }
    
    //Переход на страницу подписок*
    @objc private func presentVCFollowing() {
        block.startAnimating()
        guard let user = user else { return }
        userClass.usersFollowedByUser(with: user.id, queue: DispatchQueue.global()) { [weak self] (usersArray) in
            guard let self = self else { return }
            guard usersArray != nil else { self.alert.createAlert {_ in
                self.usersFollowedByUser = []
                }
                return }
            self.usersFollowedByUser = usersArray
            if let array = self.usersFollowedByUser {
                DispatchQueue.main.async {
                    self.block.stopAnimating()
                    self.navigationController?.pushViewController(FollowersTableViewController(usersArray: array, titleName: "Following", user: user), animated: true)
                }
            }
        }
    }
}


extension ProfileViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
        
        func numberOfSections(in collectionView: UICollectionView) -> Int {
            1
        }
        
        func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
            guard let postArray = postsOfCurrentUser else { return 0 }
            return postArray.count
        }
        
        func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: nibNameAndIdentifier, for: indexPath) as? ProfileCell else { return UICollectionViewCell()}
            guard let posts = postsOfCurrentUser else { return UICollectionViewCell() }
            
            let post = posts[indexPath.item]
            cell.setupCell(post: post)
            return cell
        }
        
        func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
            CGSize(width: collectionView.bounds.width / 3, height: collectionView.bounds.width / 3)
        }
        
        func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
            0
        }
        
        func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
            CGSize(width: view.frame.width, height: 86)
        }
        
        func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
            guard let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: identifierHeader, for: indexPath) as? ProfileHeaderCell else { return UICollectionReusableView() }
            guard let user = user else { return header }
            header.currentUser = currentUser
            header.user = user
            header.createCell()
            header.delegate = self
            presentFollowers(button: header.followersButton)
            presentFollowing(button: header.followingButton)
            
            return header
        }
    }

extension ProfileViewController: FollowUnfollowDelegate {
    
    //Подписаться-подписаться на-от пользователя
    func tapFollowUnfollowButton(user: User) {
        
        if user.currentUserFollowsThisUser {
            userClass.unfollow(user.id, queue: .global()) { (_) in
                self.userClass.user(with: user.id, queue: .global()) { [weak self] (user) in
                    guard let self = self else { return }
                    guard let user = user else { self.alert.createAlert {_ in}
                        return }
                    self.user = user
                    DispatchQueue.main.async {
                        self.collectionView.reloadData()
                    }
                }
            }
            
        } else {
            userClass.follow(user.id, queue: .global()) { (_) in
                self.userClass.user(with: user.id, queue: .global()) { [weak self] (user) in
                    guard let self = self else { return }
                    guard let user = user else { self.alert.createAlert {_ in}
                        return }
                    self.user = user
                    DispatchQueue.main.async {
                        self.collectionView.reloadData()
                    }
                }
            }
        }
    }
}
