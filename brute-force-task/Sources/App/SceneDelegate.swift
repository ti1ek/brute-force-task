//
//  SceneDelegate.swift
//  brute-force-task
//
//  Created by Zhuldyz Bukeshova on 20.04.2023.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: windowScene)
        let MainViewController = MainViewController()
        window?.rootViewController = MainViewController
        window?.makeKeyAndVisible()
    }
}
