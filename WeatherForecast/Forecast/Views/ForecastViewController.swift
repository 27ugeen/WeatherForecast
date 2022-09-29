//
//  ViewController.swift
//  WeatherForecast
//
//  Created by GiN Eugene on 28/9/2022.
//

import UIKit
import CoreLocation

class ForecastViewController: UIViewController {
    //MARK: - props
    private let viewModel: ForecastViewModel
    
    private let headerID = ForecastHeaderTableViewCell.cellId
    private let tFHoursID = ForecastTFHoursTableViewCell.cellId
    private let dailyID = ForecastDailyTableViewCell.cellId
    
    private var forecastModel: ForecastStub? {
        didSet {
            tableView.reloadData()
        }
    }
    
    //MARK: - init
    init(viewModel: ForecastViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        nil
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = Palette.mainTintColor
        navigationController?.navigationBar.tintColor = Palette.mainTextColor
        //        ForecastDataModel().getData()
        
        //TODO: - need to take out this logic
        lazy var locationManager = CLLocationManager()
        
        viewModel.takeWeatherForecast(locationManager.location?.coordinate ?? CLLocationCoordinate2D(latitude: 47.09608, longitude: 37.54817)) { fModel, cModel in
            self.viewModel.createCurrentForecastStub(fModel, cModel) { forecast in
                self.forecastModel = forecast
//                print(self.forecastModel)
            }
        }
        
        setupViews()
        setupNuvButtons()
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
        //TODO: - style?
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        return tableView
    }()
    
    //MARK: - methods
    private func setupNuvButtons() {
        let leftBarButton = UIBarButtonItem(image: UIImage(named: "ic_place") , style: .done, target: self, action: #selector(leftBtnTapped))
        let rightBarButton = UIBarButtonItem(image: UIImage(named: "ic_my_location"), style: .plain, target: self, action: #selector(rightBtnTapped))
        let leftBarTitle = UIBarButtonItem.init(customView: titleLabel)
        self.navigationItem.setLeftBarButtonItems([leftBarButton, leftBarTitle], animated: true)
        self.navigationItem.setRightBarButton(rightBarButton, animated: true)
    }
    
    @objc private func leftBtnTapped() {
        print("left tapped")
    }
    
    @objc private func rightBtnTapped() {
        print("right tapped")
    }
}

//MARK: - setupViews
extension ForecastViewController {
    private func setupViews() {
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
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let hModel = forecastModel?.current[0]
        //TODO: -
        self.titleLabel.text = forecastModel?.city
        
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
            
            switch hModel?.weather[0].descript {
            case "Clear":
                if isDay {
                    hCell.weatherImageView.image = UIImage(named: "ic_white_day_bright")
                } else {
                    hCell.weatherImageView.image = UIImage(named: "ic_white_night_bright")
                }
            case "Clouds":
                if isDay {
                    hCell.weatherImageView.image = UIImage(named: "ic_white_day_cloudy")
                } else {
                    hCell.weatherImageView.image = UIImage(named: "ic_white_night_cloudy")
                }
            case "Rain":
                if isDay {
                    hCell.weatherImageView.image = UIImage(named: "ic_white_day_shower")
                } else {
                    hCell.weatherImageView.image = UIImage(named: "ic_white_night_shower")
                }
            case "Drizzle":
                if isDay {
                    hCell.weatherImageView.image = UIImage(named: "ic_white_day_rain")
                } else {
                    hCell.weatherImageView.image = UIImage(named: "ic_white_night_rain")
                }
            case "Thunderstorm":
                if isDay {
                    hCell.weatherImageView.image = UIImage(named: "ic_white_day_thunder")
                } else {
                    hCell.weatherImageView.image = UIImage(named: "ic_white_night_thunder")
                }
            case .none:
                if isDay {
                    hCell.weatherImageView.image = UIImage(named: "ic_white_day_cloudy")
                } else {
                    hCell.weatherImageView.image = UIImage(named: "ic_white_night_cloudy")
                }
            case .some(_):
                if isDay {
                    hCell.weatherImageView.image = UIImage(named: "ic_white_day_cloudy")
                } else {
                    hCell.weatherImageView.image = UIImage(named: "ic_white_night_cloudy")
                }
            }
            
            hCell.currentDateLabel.text = Double(hModel?.currentTime ?? 0).dateFormatted("E").uppercased() + ", " + Double(hModel?.currentTime ?? 0).dateFormatted("d MMMM")
            hCell.tempLabel.text = "\(Int(dModel?.dTempDay.rounded() ?? 0))°/ \(Int(dModel?.dTempNight.rounded() ?? 0))°"
            hCell.humidityLabel.text = "\(hModel?.humidity ?? 0)%"
            hCell.windSpeedLabel.text = "\(Int(hModel?.windSpeed ?? 0)) m/s"
            return hCell
        case 1:
            let tFHCell = tableView.dequeueReusableCell(withIdentifier: tFHoursID) as! ForecastTFHoursTableViewCell
            tFHCell.model = forecastModel
            return tFHCell
        default:
            let dCell = tableView.dequeueReusableCell(withIdentifier: dailyID) as! ForecastDailyTableViewCell
            //            if dailyCell.isSelected {
            //                dailyCell.tempLabel.text = "000"
            //            } else {
            //                dailyCell.tempLabel.text = "111"
            //            }
            
            let dModel = forecastModel?.daily[indexPath.row - 2]
            //            print(dModel)
            
            switch dModel?.dWeather[0].descript {
            case "Clear":
                dCell.weatherImageView.image = UIImage(named: "ic_white_day_bright")?.withTintColor(Palette.secondTextColor)
            case "Clouds":
                dCell.weatherImageView.image = UIImage(named: "ic_white_day_cloudy")?.withTintColor(Palette.secondTextColor)
            case "Rain":
                dCell.weatherImageView.image = UIImage(named: "ic_white_day_shower")?.withTintColor(Palette.secondTextColor)
            case "Drizzle":
                dCell.weatherImageView.image = UIImage(named: "ic_white_day_rain")?.withTintColor(Palette.secondTextColor)
            case "Thunderstorm":
                dCell.weatherImageView.image = UIImage(named: "ic_white_day_thunder")?.withTintColor(Palette.secondTextColor)
            case .none:
                dCell.weatherImageView.image = UIImage(named: "ic_white_day_cloudy")?.withTintColor(Palette.secondTextColor)
            case .some(_):
                dCell.weatherImageView.image = UIImage(named: "ic_white_day_cloudy")?.withTintColor(Palette.secondTextColor)
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.row > 1 {
            let dailyCell = tableView.cellForRow(at: indexPath) as! ForecastDailyTableViewCell
            
            dailyCell.tempLabel.textColor = Palette.secondTintColor
            dailyCell.dayLabel.textColor = Palette.secondTintColor
            dailyCell.weatherImageView.tintColor = Palette.secondTintColor
            
            
            dailyCell.wrapperView.layer.shadowColor = UIColor.black.cgColor
            dailyCell.wrapperView.layer.shadowOpacity = 1
            dailyCell.wrapperView.layer.shadowOffset = .zero
            dailyCell.wrapperView.layer.shadowRadius = 10
            dailyCell.wrapperView.layer.shadowPath = UIBezierPath(rect: dailyCell.wrapperView.bounds).cgPath
            dailyCell.wrapperView.layer.rasterizationScale = UIScreen.main.scale
            
            //            self.goToDailyDetailAction?(indexPath.row - 3)
            print(indexPath.row)
            tableView.reloadRows(at: [indexPath], with: .automatic)
            
        }
    }
}


