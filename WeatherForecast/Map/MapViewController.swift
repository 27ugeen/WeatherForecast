//
//  MapViewController.swift
//  WeatherForecast
//
//  Created by GiN Eugene on 30/9/2022.
//

import UIKit
import MapKit
import CoreLocation

class MapViewController: UIViewController {
    //MARK: - props
    private let mapView: MKMapView
    private let locationManager: CLLocationManager
    private var userAnnotations: [MKPointAnnotation] = []
    
    var getWeatherAction: ((_ coordinates: CLLocationCoordinate2D) -> Void)?
    
    //MARK: - init
    init(mapView: MKMapView, locationManager: CLLocationManager) {
        self.mapView = mapView
        self.locationManager = locationManager
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupMapView()
        checkUserLocationPermissions()
    }
    //MARK: - subviews
    private lazy var deletePinsButton: UIButton = {
        let btn = UIButton()
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.setTitle("Delete pins", for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        btn.setTitleColor(Palette.mainTextColor, for: .normal)
        btn.setTitleColor(.red, for: .highlighted)
        btn.addTarget(self, action: #selector(deletePins), for: .touchUpInside)
        return btn
    }()
    
    private lazy var longGesture = UILongPressGestureRecognizer(target: self, action: #selector(addPoint))
    
    //MARK: - methods
    private func checkUserLocationPermissions() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = 100
        locationManager.startUpdatingLocation()
        
        switch locationManager.authorizationStatus {
        case .notDetermined:
            locationManager.requestAlwaysAuthorization()
        case .denied, .restricted:
            showAlert(message: "Please, set permission for your location in settings")
        case .authorizedAlways, .authorizedWhenInUse:
            mapView.showsUserLocation = true
        @unknown default:
            fatalError("Unknown status")
        }
    }
    
    private func getPointWeather(_ destinationPoint: CLLocationCoordinate2D) {
        self.getWeatherAction?(destinationPoint)
        self.navigationController?.popViewController(animated: true)
    }
    
    private func showAlertOkCancel(_ props: CLLocationCoordinate2D) {
        let alertVC = UIAlertController(title: "Make a choice",
                                        message: "Would you like to get the weather forecast for this point?",
                                        preferredStyle: UIAlertController.Style.alert)
        
        alertVC.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
//            self.mapView.removeOverlays(self.mapView.overlays)
            self.getPointWeather(props)
        }))
        alertVC.addAction(UIAlertAction(title: "Cancel", style: .destructive, handler: nil))
        self.present(alertVC, animated: true, completion: nil)
    }
    
    @objc private func addPoint(gestureRecognizer: UIGestureRecognizer) {
        if gestureRecognizer.state == UIGestureRecognizer.State.began {
            let touchPoint = longGesture.location(in: mapView)
            let pointCoords = mapView.convert(touchPoint, toCoordinateFrom: mapView)
            let wayAnnotation = MKPointAnnotation()
            wayAnnotation.coordinate = pointCoords
            
            CLGeocoder().reverseGeocodeLocation(CLLocation(latitude: pointCoords.latitude, longitude: pointCoords.longitude)) { (placemarks, error) -> Void in
                if let unwrError = error as? NSError {
                    print("Reverse geocoder failed with error" + unwrError.localizedDescription)
                    return
                }
                
                if let unwrPlacemarks = placemarks {
                    if unwrPlacemarks.count > 0 {
                        let pm = unwrPlacemarks[0]
                        wayAnnotation.title = (pm.thoroughfare ?? "") + ", " + (pm.subThoroughfare ?? "")
                        wayAnnotation.subtitle = pm.subLocality
                        
                        self.mapView.addAnnotation(wayAnnotation)
                    } else {
                        wayAnnotation.title = "Unknown Place"
                        self.mapView.addAnnotation(wayAnnotation)
                        print("Problem with the data received from geocoder")
                    }
                    self.userAnnotations.append(wayAnnotation)
                }
            }
        }
    }
    
    @objc private func deletePins() {
        self.mapView.removeAnnotations(userAnnotations)
        self.mapView.removeAnnotations(mapView.annotations)
//        print(mapView.annotations)
    }
}
//MARK: - setupMapView
extension MapViewController {
    private func setupMapView() {
        mapView.translatesAutoresizingMaskIntoConstraints = false
        
        mapView.addGestureRecognizer(longGesture)
        mapView.delegate = self
        
        mapView.showsScale = true
        mapView.showsCompass = true
        
        view.addSubview(mapView)
        mapView.addSubview(deletePinsButton)
        
        NSLayoutConstraint.activate([
            mapView.topAnchor.constraint(equalTo: view.topAnchor),
            mapView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            mapView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            mapView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            deletePinsButton.trailingAnchor.constraint(equalTo: mapView.safeAreaLayoutGuide.trailingAnchor, constant: -12),
            deletePinsButton.bottomAnchor.constraint(equalTo: mapView.safeAreaLayoutGuide.bottomAnchor, constant: -24),
        ])
    }
}
//MARK: - CLLocationManagerDelegate
extension MapViewController: CLLocationManagerDelegate {
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        checkUserLocationPermissions()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first else { return }
        
        let region = MKCoordinateRegion(center: location.coordinate, latitudinalMeters: 42000, longitudinalMeters: 42000)
        mapView.setRegion(region, animated: true)
    }
}
//MARK: - MKMapViewDelegate
extension MapViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        if let unwrAnnotation = view.annotation {
            self.showAlertOkCancel(unwrAnnotation.coordinate)
        }
    }
}
