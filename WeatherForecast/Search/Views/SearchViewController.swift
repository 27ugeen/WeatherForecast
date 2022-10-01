//
//  SearchViewController.swift
//  WeatherForecast
//
//  Created by GiN Eugene on 30/9/2022.
//

import UIKit
import CoreLocation

class SearchViewController: UIViewController {
    //MARK: - props
    private let viewModel: SearchViewModel
    
    private let cityCellID = SearchTableViewCell.cellId
    
    private var selectedCity: CityStub?
    private var cities: [CityStub] = [] {
        didSet {
            tableView.reloadData()
        }
    }
    
    var getWeatherAction: ((_ coordinates: CLLocationCoordinate2D) -> Void)?
    
    //MARK: - init
    init(viewModel: SearchViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        nil
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
        setupNavBar()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillShow(notification:)),
                                               name: UIResponder.keyboardWillShowNotification,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillHide(notification:)),
                                               name: UIResponder.keyboardWillHideNotification,
                                               object: nil)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    //MARK: - subviews
    private let tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = Palette.mainTextColor
        tableView.separatorStyle = .none
        return tableView
    }()
    
    private lazy var searchTextField: UITextField = {
        let text = UITextField()
        text.backgroundColor = Palette.mainTextColor
        text.layer.cornerRadius = 4
        text.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        text.tintColor = .lightGray
        text.textColor = Palette.secondTextColor
        text.placeholder = "Enter at least two letters..."
        text.placeholderColor(color: .lightGray)
        text.textAlignment = .left
        text.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 8, height: text.frame.height))
        text.leftViewMode = .always
        text.becomeFirstResponder()
        
        text.addTarget(self, action: #selector(textChanged), for: .editingChanged)
        return text
    }()
    
    //MARK: - methods
    private func setupNavBar() {
        self.navigationController?.navigationBar.tintColor = Palette.mainTextColor
        self.navigationItem.titleView = searchTextField
        self.searchTextField.frame = CGRect(x: 0, y: 0,
                                            width: (self.navigationController?.navigationBar.frame.size.width)!,
                                            height: 30)
        
        let leftBarButton = UIBarButtonItem(image: UIImage(named: "ic_back") ,
                                            style: .done,
                                            target: self,
                                            action: #selector(leftBtnTapped))
        let rightBarButton = UIBarButtonItem(image: UIImage(named: "ic_search"),
                                             style: .plain,
                                             target: self,
                                             action: #selector(rightBtnTapped))
        self.navigationItem.setLeftBarButton(leftBarButton, animated: true)
        self.navigationItem.setRightBarButton(rightBarButton, animated: true)
    }
    
    @objc private func textChanged() {
        guard searchTextField.text?.count ?? 0 > 1 else {
            self.cities = []
            return
        }
        self.viewModel.getCities(searchTextField.text ?? "") { data in
            self.cities = data
        }
    }
    
    private func getCityWeather(_ coord: CLLocationCoordinate2D) {
        self.getWeatherAction?(coord)
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc private func leftBtnTapped() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc private func rightBtnTapped() {
        let lat = selectedCity?.lat ?? 0
        let lon = selectedCity?.lon ?? 0
        self.getCityWeather(CLLocationCoordinate2D(latitude: lat, longitude: lon))
    }
    
}
// MARK: - setup views
extension SearchViewController {
    private func setupViews() {
        view.backgroundColor = Palette.mainTintColor
        view.addSubview(tableView)
        
        tableView.register(SearchTableViewCell.self, forCellReuseIdentifier: cityCellID)
        
        tableView.dataSource = self
        tableView.delegate = self
        
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
        ])
    }
}
//MARK: - UITableViewDataSource
extension SearchViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cities.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cityCell = tableView.dequeueReusableCell(withIdentifier: cityCellID,
                                                        for: indexPath) as? SearchTableViewCell {
            let name = cities[indexPath.row].name
            let country = cities[indexPath.row].country
            
            cityCell.backgroundColor = Palette.mainTextColor
            cityCell.selectionStyle = .none
            cityCell.cityLabel.text = "\(name), \(country)"
            return cityCell
        }
        return UITableViewCell()
    }
}
//MARK: - UITableViewDelegate
extension SearchViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cityCell = tableView.cellForRow(at: indexPath) as! SearchTableViewCell
        let city = cities[indexPath.row]
        
        self.selectedCity = city
        self.searchTextField.text = cityCell.cityLabel.text ?? ""
    }
}
// MARK: - setupKeyboard
private extension SearchViewController {
    @objc private func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            tableView.contentInset.bottom = keyboardSize.height
            tableView.verticalScrollIndicatorInsets = UIEdgeInsets(top: 0, left: 0, bottom: keyboardSize.height, right: 0)
        }
    }
    @objc private func keyboardWillHide(notification: NSNotification) {
        tableView.contentInset.bottom = .zero
        tableView.verticalScrollIndicatorInsets = .zero
    }
}
