//
//  Feeds.swift
//  Course2FinalTask
//
//  Created by Евгений on 09.08.2020.
//  Copyright © 2020 e-Legion. All rights reserved.
//

import UIKit
import DataProvider


class FeedViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    private let userClass = Users()
    private let postClass = Posts()
    private lazy var block = BlockViewController(view: (tabBarController?.view)!)
    private lazy var alert = AlertViewController(view: self)
    private var postsArray: [Post]?
    private var currentUser: User?
    private var usersLikedPost: [User]?
    private var user: User?
    private let nibNameAndIdentifier = "FeedCell"
    private let storyboardName = "Storyboard"
    private let profileViewControllerIdentifier = "ProfileViewController"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        createCurrentUser()
        createPostsArrayWithBlock()
        
        title = "Feed"
        collectionView.register(UINib(nibName: "Feed", bundle: nil), forCellWithReuseIdentifier: nibNameAndIdentifier)
        collectionView.dataSource = self
        collectionView.delegate = FeedCell() as? UICollectionViewDelegate
    }
    
    
    //    Обновляет UI и скроллит в начало ленты при новой публикации
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        createPostsArrayWithBlock()
        collectionView.scrollToItem(at: IndexPath(item: 0, section: 1), at: .top, animated: true)
    }
    
    //    Создает карент пользователя
    private func createCurrentUser() {
        userClass.currentUser(queue: DispatchQueue.global()) { [weak self] user in
            guard let self = self else { return }
            guard user != nil else { self.alert.createAlert {_ in}
                return }
            DispatchQueue.main.async {
                self.currentUser = user
            }
        }
    }
    
    //    Создает массив постов без блокировки UI для лайков
    func createPostsArrayWithoutBlock() {
        postClass.feed(queue: DispatchQueue.global()) { [weak self] (postsArray) in
            guard let self = self else { return }
            guard postsArray != nil else { self.alert.createAlert { _ in
                self.postsArray = [] }
                return }
            DispatchQueue.main.async {
                self.postsArray = postsArray
                self.collectionView.reloadData()
            }
        }
    }
    
    //    Создает массив постов с блокировкой UI
    private func createPostsArrayWithBlock() {
        block.startAnimating()
        postClass.feed(queue: DispatchQueue.global()) { [weak self] (postsArray) in
            guard let self = self else { return }
            guard postsArray != nil else { self.alert.createAlert { _ in
                self.postsArray = [] }
                return }
            DispatchQueue.main.async {
                self.postsArray = postsArray
                self.block.stopAnimating()
                self.collectionView.reloadData()
            }
        }
    }
    
    //    Cоздание ViewCont и переход в профиль пользователя
    private func goToUserProfile(user: User) {
        let storyboard = UIStoryboard(name: storyboardName, bundle: nil)
        guard let profileVC = storyboard.instantiateViewController(withIdentifier: profileViewControllerIdentifier) as? ProfileViewController else { alert.createAlert {_ in}
            return }
        profileVC.currentUser = currentUser
        profileVC.user = user
        show(profileVC, sender: nil)
    }
}

//    MARK:- DataSource and Delegate
extension FeedViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let array = postsArray else { return 0 }
        return array.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: nibNameAndIdentifier, for: indexPath) as? FeedCell else { return UICollectionViewCell()}
        guard let array = postsArray else { return UICollectionViewCell() }
        let post = array[indexPath.item]
        cell.post = post
        cell.setupCell()
        cell.delegate = self
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: view.bounds.width, height: 600)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        20
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
}


extension FeedViewController: LikeImageButtonDelegate {
    
    //Показывает всех лайкнушвших пост юзеров
    func likesLabelTapped(post: Post) {
        
        block.startAnimating()
        self.userClass.user(with: post.author, queue: .global()) { [weak self] (user) in
            guard let self = self else { return }
            guard user != nil else { self.alert.createAlert {_ in}
                return }
            self.user = user
            DispatchQueue.main.async {
                self.block.stopAnimating()
                if let user = self.user {
                    self.goToUserProfile(user: user)
                }
            }
        }
    }
    
    //    Создает массив пользователей, которые лайкнули публикацию и показывает их
    func tapLikes(post: Post) {
        
        block.startAnimating()
        self.postClass.usersLikedPost(with: post.id, queue: DispatchQueue.global()) { [weak self] (usersArray) in
            guard let self = self else { return }
            guard usersArray != nil else { return }
            self.usersLikedPost = usersArray
            guard let array = self.usersLikedPost else { return }
            
            self.userClass.user(with: post.author, queue: .global()) { [weak self] (user) in
                guard let self = self else { return }
                guard user != nil else { return }
                self.user = user
                guard let myUser = self.user else { return }
                
                DispatchQueue.main.async {
                    self.block.stopAnimating()
                    self.navigationController?.pushViewController(FollowersTableViewController(usersArray: array, titleName: "Likes", user: myUser), animated: true)
                }
            }
        }
    }
    
    //    Открывает профиль пользователя при нажатии на его фото или имя в ленте постов
    func tapAvatarAndUserName(post: Post) {
        block.startAnimating()
        self.userClass.user(with: post.author, queue: .global()) { [weak self] (user) in
            guard let self = self else { return }
            guard user != nil else { self.alert.createAlert {_ in}
                return }
            self.user = user
            DispatchQueue.main.async {
                self.block.stopAnimating()
                if let user = self.user {
                    self.goToUserProfile(user: user)
                }
            }
        }
    }
    
    //    Метод проставки лайка по двойном нажатии на изображение поста
    func tapBigLike(post: Post) {
        postClass.likePost(with: post.id, queue: DispatchQueue.global()) { [weak self] (_) in
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.createPostsArrayWithoutBlock()
            }
        }
    }
    
    //    Ставит или убирает лайк при нажатии на кнопку "сердце"
    func tapLiked(post: Post) {
        if post.currentUserLikesThisPost {
            postClass.unlikePost(with: post.id, queue: DispatchQueue.global()) { [weak self] (_) in
                guard let self = self else { return }
                DispatchQueue.main.async {
                    self.createPostsArrayWithoutBlock()
                }
            }
        } else {
            postClass.likePost(with: post.id, queue: DispatchQueue.global()) { [weak self] (_) in
                guard let self = self else { return }
                DispatchQueue.main.async {
                    self.createPostsArrayWithoutBlock()
                }
            }
        }
    }
}
