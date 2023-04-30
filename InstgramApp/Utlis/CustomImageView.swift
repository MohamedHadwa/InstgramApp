//
//  CustomImageView.swift
//  InstgramApp
//
//  Created by Mohamed Hadwa on 04/02/2023.
//

import UIKit

class CustomImageView :UIImageView {
    var lastURLUsedToLoadImage :String?
    
    func loadImage (urlString : String) {
        lastURLUsedToLoadImage = urlString
        print("loading image ...")
        guard let url = URL(string: urlString) else { return }
        
        URLSession.shared.dataTask(with: url) { (data, response, err) in
            if let err = err {
                print("Failed to fetch post image:", err)
                return
            }
            if url.absoluteString != self.lastURLUsedToLoadImage {
                return
            }
            
            guard let imageData = data else { return }
            
            let photoImage = UIImage(data: imageData)
            
            DispatchQueue.main.async {
                self.image = photoImage
            }
            
        }.resume()
    }
}
