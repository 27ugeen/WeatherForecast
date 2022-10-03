//
//  ForecastTFHoursTableViewCell.swift
//  WeatherForecast
//
//  Created by GiN Eugene on 29/9/2022.
//

import Foundation
import UIKit

class ForecastTFHoursTableViewCell: UITableViewCell {
    //MARK: - props
    static let cellId = "ForecastTFHoursTableViewCell"
    private let collectionCellID = ForecastTFHoursCollectionViewCell.cellId
    
    var viewModel: ForecastViewModelProtocol!
    var model: ForecastStub? {
        didSet {
            tFHoursCollectionView.reloadData()
        }
    }
    //MARK: - init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    //MARK: - subviews
    private lazy var tFHoursCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        
        let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collection.translatesAutoresizingMaskIntoConstraints = false
        collection.showsHorizontalScrollIndicator = false
        collection.backgroundColor = Palette.secondTintColor
        
        collection.isPagingEnabled = true
        
        collection.register(ForecastTFHoursCollectionViewCell.self, forCellWithReuseIdentifier: collectionCellID)
        
        collection.dataSource = self
        collection.delegate = self
        
        return collection
    }()
}
//MARK: - setupView
extension ForecastTFHoursTableViewCell {
    private func setupViews() {
        self.backgroundColor = Palette.secondTintColor
        self.selectionStyle = .none
        contentView.addSubview(tFHoursCollectionView)
        
        NSLayoutConstraint.activate([
            tFHoursCollectionView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            tFHoursCollectionView.topAnchor.constraint(equalTo: contentView.topAnchor),
            tFHoursCollectionView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            tFHoursCollectionView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
}
//MARK: - UICollectionViewDataSource
extension ForecastTFHoursTableViewCell: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        //TODO: - received 48h
        return 24
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = tFHoursCollectionView.dequeueReusableCell(withReuseIdentifier: collectionCellID,
                                                             for: indexPath) as! ForecastTFHoursCollectionViewCell
        
        let hModel = model?.hourly[indexPath.item]
        let cModel = model?.current[0]
        
        let localOffset = TimeZone.current.secondsFromGMT()
        let timeOffset = (model?.timezoneOffset ?? 0) - localOffset
        
        let isDay: Bool = viewModel.determineTheTimeOfTheDay(hModel?.hTime ?? 0,
                                                             model?.timezoneOffset ?? 0,
                                                             cModel?.sunrise ?? 0,
                                                             cModel?.sunset ?? 0)
        
        if let descript = hModel?.hWeather[0].descript {
            let icon = viewModel.setWeatherIcon(isDay, descript)
            cell.weatherImageView.image = UIImage(named: icon)
        }
        cell.timeLabel.text = "\(Double((hModel?.hTime ?? 0) + timeOffset).dateFormatted("HH"))⁰⁰"
        cell.tempLabel.text = "\(Int((hModel?.hTemp ?? 0).rounded()))°"
        return cell
    }
}
//MARK: - UICollectionViewDelegateFlowLayout
extension ForecastTFHoursTableViewCell: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 80, height: 146)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}
