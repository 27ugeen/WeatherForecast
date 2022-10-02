//
//  ViewController.swift
//  WeatherForecast
//
//  Created by GiN Eugene on 28/9/2022.
//

import UIKit
import MapKit
import CoreLocation

class ForecastViewController: UIViewController {
    //MARK: - props
    private let viewModel: ForecastViewModel
    private let searchVM: SearchViewModel
    private let mapView: MKMapView
    private let locationManager: CLLocationManager
    
    private let headerID = ForecastHeaderTableViewCell.cellId
    private let tFHoursID = ForecastTFHoursTableViewCell.cellId
    private let dailyID = ForecastDailyTableViewCell.cellId
    
    
    private var forecastModel: ForecastStub? {
        didSet {
            tableView.reloadData()
        }
    }
    
    //MARK: - init
    init(viewModel: ForecastViewModel,
         searchVM: SearchViewModel,
         mapView: MKMapView,
         locationManager: CLLocationManager) {
        self.viewModel = viewModel
        self.searchVM = searchVM
        self.mapView = mapView
        self.locationManager = locationManager
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        nil
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //MARK: - the OnBoarding screen (or another) is required to get the current coordinates
        let defCoord = CLLocationCoordinate2D(latitude: 47.09608, longitude: 37.54817)
        
        fetchWeatherData(defCoord)
        setupViews()
        setupNavButtons()
    }
    //MARK: - subviews
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = Palette.mainTextColor
        label.font = UIFont.systemFont(ofSize: 20, weight: .medium)
        label.text = "titleBar"
        return label
    }()
    
    private let tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.showsVerticalScrollIndicator = false
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        return tableView
    }()
    
    //MARK: - methods
    private func fetchWeatherData(_ coord: CLLocationCoordinate2D) {
        viewModel.takeWeatherForecast(coord) { forecast in
            self.forecastModel = forecast
            self.titleLabel.text = self.forecastModel?.city
        }
    }
    
    private func setupNavButtons() {
        let leftBarButton = UIBarButtonItem(image: UIImage(named: "ic_place") , style: .done, target: self, action: #selector(leftBtnTapped))
        let rightBarButton = UIBarButtonItem(image: UIImage(named: "ic_my_location"), style: .plain, target: self, action: #selector(rightBtnTapped))
        let leftBarTitle = UIBarButtonItem.init(customView: titleLabel)
        self.navigationItem.setLeftBarButtonItems([leftBarButton, leftBarTitle], animated: true)
        self.navigationItem.setRightBarButton(rightBarButton, animated: true)
    }
    
    @objc private func leftBtnTapped() {
        let mapVC = MapViewController(mapView: mapView, locationManager: locationManager)
        mapVC.getWeatherAction = { coord in
            self.fetchWeatherData(coord)
        }
        self.navigationController?.pushViewController(mapVC, animated: true)
    }
    
    @objc private func rightBtnTapped() {
        let searchVC = SearchViewController(viewModel: searchVM)
        searchVC.getWeatherAction = { coord in
            self.fetchWeatherData(coord)
        }
        self.navigationController?.pushViewController(searchVC, animated: true)
    }
}

//MARK: - setupViews
extension ForecastViewController {
    private func setupViews() {
        overrideUserInterfaceStyle = .dark
        navigationController?.navigationBar.tintColor = Palette.mainTextColor
        view.backgroundColor = Palette.mainTintColor
        view.addSubview(tableView)
        
        tableView.register(ForecastHeaderTableViewCell.self, forCellReuseIdentifier: headerID)
        tableView.register(ForecastTFHoursTableViewCell.self, forCellReuseIdentifier: tFHoursID)
        tableView.register(ForecastDailyTableViewCell.self, forCellReuseIdentifier: dailyID)
        
        tableView.dataSource = self
        tableView.delegate = self
        
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
}
//MARK: - UITableViewDataSource
extension ForecastViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (forecastModel?.daily.count ?? 0) + 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let hModel = forecastModel?.current[0]

        let localOffset = TimeZone.current.secondsFromGMT()
        let timeOffset = (forecastModel?.timezoneOffset ?? 0) - localOffset
        let curTime = Double((hModel?.currentTime ?? 0) + timeOffset).dateFormatted("HH")
        let sunrise = Double((hModel?.sunrise ?? 0) + timeOffset).dateFormatted("HH")
        let sunset = Double((hModel?.sunset ?? 0) + timeOffset).dateFormatted("HH")

        let isDay: Bool = curTime > sunrise && curTime <= sunset

        switch indexPath.row {
        case 0:
            let hCell = tableView.dequeueReusableCell(withIdentifier: headerID) as! ForecastHeaderTableViewCell
            let dModel = forecastModel?.daily[0]

            if let direct = hModel?.windDeg {
                let icon = viewModel.setWindDirection(direct)
                hCell.windDirectionImageView.image = UIImage(named: icon)
            }

            if let descript = hModel?.weather[0].descript {
                let icon = viewModel.setWeatherIcon(isDay, descript)
                hCell.weatherImageView.image = UIImage(named: icon)
            }

            hCell.currentDateLabel.text = Double(hModel?.currentTime ?? 0).dateFormatted("E").uppercased() + ", " + Double(hModel?.currentTime ?? 0).dateFormatted("d MMMM")
            hCell.tempLabel.text = "\(Int(dModel?.dTempDay.rounded() ?? 0))°/ \(Int(dModel?.dTempNight.rounded() ?? 0))°"
            hCell.humidityLabel.text = "\(hModel?.humidity ?? 0)%"
            hCell.windSpeedLabel.text = "\(Int(hModel?.windSpeed ?? 0)) m/s"
            return hCell
        case 1:
            let tFHCell = tableView.dequeueReusableCell(withIdentifier: tFHoursID) as! ForecastTFHoursTableViewCell

            tFHCell.model = forecastModel
            tFHCell.viewModel = viewModel
            return tFHCell
        default:
            let dCell = tableView.dequeueReusableCell(withIdentifier: dailyID) as! ForecastDailyTableViewCell
            let dModel = forecastModel?.daily[indexPath.row - 2]

            if let descript = dModel?.dWeather[0].descript {
                let icon = viewModel.setWeatherIcon(isDay, descript)
                dCell.weatherImageView.image = UIImage(named: icon)?.withRenderingMode(.alwaysTemplate)
            }
            dCell.dayLabel.text = Double(dModel?.dTime ?? 0).dateFormatted("E").uppercased()
            dCell.tempLabel.text = "\(Int(dModel?.dTempDay.rounded() ?? 0))° / \(Int(dModel?.dTempNight.rounded() ?? 0))°"
            return dCell
        }
    }
}
//MARK: - UITableViewDelegate
extension ForecastViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.row {
        case 0:
            return 228
        case 1:
            return 146
        default:
            return 70
        }
    }
}
