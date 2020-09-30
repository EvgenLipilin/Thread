//
//  Password generator.swift
//  Week3TestWork
//
//  Copyright © 2018 E-legion. All rights reserved.
//

import Foundation

class PasswordGenerator {
    
    //Возвращает рандомно сренерированную строку заданной длины
    func randomString(length: Int) -> String {
        
        let letters = Consts.joinedString as NSString
        let len = UInt32(letters.length)
        
        var randomString = ""
        
        for _ in 0 ..< length {
            let rand = arc4random_uniform(len)
            var nextChar = letters.character(at: Int(rand))
            randomString += NSString(characters: &nextChar, length: 1) as String
        }
        
        return randomString
    }
}
