//
//  ViewController.swift
//  WeatherForecast
//
//  Created by GiN Eugene on 28/9/2022.
//

import UIKit

class ForecastViewController: UIViewController {
    //MARK: - props
    private let viewModel: ForecastViewModel
    
    private let headerID = ForecastHeaderTableViewCell.cellId
    private let tFHoursID = ForecastTFHoursTableViewCell.cellId
    
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
        //        viewModel.getData()
        
        setupViews()
        setupNuvButtons()
    }
    //MARK: - subviews
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
        
        self.navigationItem.setLeftBarButton(leftBarButton, animated: true)
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
//        tableView.register(DetailNightTableViewCell.self, forCellReuseIdentifier: nightCellID)
//        tableView.register(SunMoonTableViewCell.self, forCellReuseIdentifier: sunMoonCellID)
//        tableView.register(AirQTableViewCell.self, forCellReuseIdentifier: airQCellID)
        
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
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let headerCell = tableView.dequeueReusableCell(withIdentifier: headerID) as! ForecastHeaderTableViewCell
        let tFHCell = tableView.dequeueReusableCell(withIdentifier: tFHoursID) as! ForecastTFHoursTableViewCell
        
//        let localOffset = TimeZone.current.secondsFromGMT()
//        let timeOffset = (model?.timezoneOffset ?? 0) - localOffset
        
        switch indexPath.row {
        case 0:
            return headerCell
        case 1:
            return tFHCell
        default:
            return headerCell
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
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        if indexPath.row > 2 {
//            self.goToDailyDetailAction?(indexPath.row - 3)
//        }
    }
}


