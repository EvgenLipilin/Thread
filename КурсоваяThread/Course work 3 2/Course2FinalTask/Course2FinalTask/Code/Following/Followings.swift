//
//  Followings.swift
//  Course2FinalTask
//
//  Created by Евгений on 26.07.2020.
//  Copyright © 2020 e-Legion. All rights reserved.
//

import UIKit
import DataProvider


class FollowersTableViewController: UITableViewController {
    
    private var usersArray = [User]()
    private var titleName: String
    private var user: User
    private lazy var block = BlockViewController(view: (tabBarController?.view)!)
    private lazy var alert = AlertViewController(view: self)
    private let userClass = Users()
    private let storyboardName = "Storyboard"
    private let profileVCIdentifier = "ProfileViewController"
    
    init(usersArray: [User], titleName: String, user: User) {
        self.usersArray = usersArray
        self.titleName = titleName
        self.user = user
        super.init(style: .plain)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(FollowersCell.self, forCellReuseIdentifier: identifier)
        title = titleName
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 45
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return usersArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath) as? FollowersCell else { return UITableViewCell() }
        let user = usersArray[indexPath.row]
        cell.createCell(user: user)
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        goToUserProfile(user: usersArray[indexPath.row])
    }
    
    //    Переход в профиль пользователя
    func goToUserProfile(user: User) {
        let storyboard = UIStoryboard(name: storyboardName, bundle: nil)
        guard let profileVC = storyboard.instantiateViewController(withIdentifier: profileVCIdentifier) as? ProfileViewController else { alert.createAlert {_ in}
            return }
        profileVC.user = user
        show(profileVC, sender: nil)
    }
}
