//
//  configureImageView.swift
//  productsApp
//
//  Created by ibaikaa on 18/1/23.
//

import UIKit


//Функция, которая принимает UIImageView и название иконки и безопасно ставит картинку к нужному UIImageView.
//В случае, если название картинки указано неверно, поставится дефолтная системная картинка.
public func configureImageView(_ imageView: UIImageView, withIconNamed iconName: String, cell id: String) {
    guard let icon = UIImage(systemName: iconName) else {
        print("Oops! Couldn't set image named \(iconName) for imageView of cell with id \(id)") //for developers
        imageView.image = UIImage(systemName: "face.smiling.fill")!
        return
    }
    
    imageView.image = icon
}
