//
//  UIApplicationExtension.swift
//  CardGame
//
//  Created by 이창수 on 2023/05/30.
//

import UIKit

extension UIApplication {
    var window: UIWindow? {
        let windowScene = connectedScenes.first as? UIWindowScene
        let window = windowScene?.windows.first
        
        return window
    }
}
