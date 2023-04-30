//
//  Post.swift
//  InstgramApp
//
//  Created by Mohamed Hadwa on 02/02/2023.
//

import Foundation


struct Post {
    let imageUrl :String
    init(dictionary : [String :Any]) {
        self.imageUrl = dictionary["imageUrl"] as? String ?? ""
    }
}
