//
//  ProfileCell.swift
//  Course2FinalTask
//
//  Created by Евгений on 09.08.2020.
//  Copyright © 2020 e-Legion. All rights reserved.
//
//


import UIKit
import DataProvider

class ProfileCell: UICollectionViewCell {
    
    @IBOutlet weak var postImage: UIImageView!
    
    func setupCell(post: Post) {
        postImage.image = post.image
    }
}

