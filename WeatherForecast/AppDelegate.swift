//
//  AppDelegate.swift
//  WeatherForecast
//
//  Created by GiN Eugene on 28/9/2022.
//

import UIKit
import Swinject
import MapKit
import CoreLocation

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    //Create Swinject DI container
    private let container: Container = {
        let container = Container()
        container.register(MKMapView.self) { _ in MKMapView() }
        container.register(CLLocationManager.self) { _ in CLLocationManager() }
        container.register(DataModelProtocol.self) { _ in ForecastDataModel() }
        container.register(ForecastViewModelProtocol.self) { r in
            let viewModel = ForecastViewModel()
            viewModel.dataModel = r.resolve(DataModelProtocol.self)
            return viewModel
        }
        container.register(SearchViewModelProtocol.self) { r in
            let viewModel = SearchViewModel()
            viewModel.dataModel = r.resolve(DataModelProtocol.self)
            return viewModel
        }
        
        container.register(SearchViewController.self) { r in
            let controller = SearchViewController()
            controller.viewModel = r.resolve(SearchViewModelProtocol.self)
            return controller
        }
        container.register(MapViewController.self) { r in
            let controller = MapViewController()
            controller.mapView = r.resolve(MKMapView.self)
            controller.locationManager = r.resolve(CLLocationManager.self)
            return controller
        }
        container.register(ForecastViewController.self) { r in
            let controller = ForecastViewController()
            controller.locationManager = r.resolve(CLLocationManager.self)
            controller.viewModel = r.resolve(ForecastViewModelProtocol.self)
            controller.searchVC = r.resolve(SearchViewController.self)
            controller.mapVC = r.resolve(MapViewController.self)
            return controller
        }
        return container
    }()
    
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Instantiate a window.
        let window = UIWindow(frame: UIScreen.main.bounds)
        window.makeKeyAndVisible()
        self.window = window
        
        // Instantiate the root view controller with dependencies injected by the container.
        let navVC = UINavigationController(rootViewController: container.resolve(ForecastViewController.self)!)
        window.rootViewController = navVC
        return true
    }
}
