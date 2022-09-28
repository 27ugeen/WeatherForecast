//
//  SceneDelegate.swift
//  WeatherForecast
//
//  Created by GiN Eugene on 28/9/2022.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let scene = (scene as? UIWindowScene) else { return }
        
        let vm = ForecastViewModel()
        let vc = ForecastViewController(viewModel: vm)
        
        let navVC = UINavigationController(rootViewController: vc)
        
        window = UIWindow(windowScene: scene)
        window?.rootViewController = navVC
        window?.makeKeyAndVisible()
    }
}
