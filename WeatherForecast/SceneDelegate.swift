//
//  SceneDelegate.swift
//  WeatherForecast
//
//  Created by GiN Eugene on 28/9/2022.
//

import UIKit
import MapKit
import CoreLocation

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let scene = (scene as? UIWindowScene) else { return }
        
        let mapView = MKMapView()
        let locManager = CLLocationManager()
        
        let dm = ForecastDataModel()
        let vm = ForecastViewModel(dataModel: dm)
        let searchVM = SearchViewModel(dataModel: dm)
        let vc = ForecastViewController(viewModel: vm,
                                        searchVM: searchVM,
                                        mapView: mapView,
                                        locationManager: locManager)
//        let vc = SearchViewController()
        
        let navVC = UINavigationController(rootViewController: vc)
        
        window = UIWindow(windowScene: scene)
        window?.rootViewController = navVC
        window?.makeKeyAndVisible()
    }
}
