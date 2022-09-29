//
//  ForecastDailyTableViewCell.swift
//  WeatherForecast
//
//  Created by GiN Eugene on 29/9/2022.
//

import UIKit

class ForecastDailyTableViewCell: UITableViewCell {
    //MARK: - props
    
    static let cellId = "ForecastDailyTableViewCell"
    
    //MARK: - init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    //MARK: - subviews
    let wrapperView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Palette.mainTextColor
//        view.contentMode = .scaleAspectFill
//        view.layer.cornerRadius = 4
//        view.layer.shadowColor = UIColor.red.cgColor
//        view.layer.shadowOpacity = 0.8
//        view.layer.shadowOffset = .zero
//        view.layer.shadowRadius = 100
//        view.layer.shadowPath = UIBezierPath(rect: view.bounds).cgPath
//        view.layer.rasterizationScale = UIScreen.main.scale
        view.clipsToBounds = true
//        view.layer.borderWidth = 1
//        view.layer.borderColor = UIColor.black.cgColor
        return view
    }()
    
    let dayLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 18, weight: .regular)
        label.textColor = Palette.secondTextColor
        label.text = "sun"
        return label
    }()
    
    let tempLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 18, weight: .regular)
        label.text = "27°/19°"
        label.textColor = Palette.secondTextColor
        return label
    }()
    
    let weatherImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(named: "ic_white_day_cloudy")
        imageView.image = imageView.image?.withRenderingMode(.alwaysTemplate)
        imageView.tintColor = Palette.secondTextColor
        return imageView
    }()
}
//MARK: - setupViews
extension ForecastDailyTableViewCell {
    private func setupViews() {
        contentView.addSubview(wrapperView)
        
//        wrapperView.layer.shadowColor = UIColor.red.cgColor
//        wrapperView.layer.shadowOpacity = 0.8
//        wrapperView.layer.shadowOffset = .zero
//        wrapperView.layer.shadowRadius = 100
//        wrapperView.layer.shadowPath = UIBezierPath(rect: wrapperView.bounds).cgPath
//        wrapperView.layer.rasterizationScale = UIScreen.main.scale
        
        wrapperView.addSubview(dayLabel)
        wrapperView.addSubview(tempLabel)
        wrapperView.addSubview(weatherImageView)
        
        NSLayoutConstraint.activate([
            wrapperView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            wrapperView.topAnchor.constraint(equalTo: contentView.topAnchor),
            wrapperView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            wrapperView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            
            dayLabel.leadingAnchor.constraint(equalTo: wrapperView.leadingAnchor, constant: 20),
            dayLabel.centerYAnchor.constraint(equalTo: wrapperView.centerYAnchor),
            
            tempLabel.centerXAnchor.constraint(equalTo: wrapperView.centerXAnchor),
            tempLabel.centerYAnchor.constraint(equalTo: wrapperView.centerYAnchor),
            
            weatherImageView.trailingAnchor.constraint(equalTo: wrapperView.trailingAnchor,constant: -20),
            weatherImageView.centerYAnchor.constraint(equalTo: wrapperView.centerYAnchor),
            weatherImageView.heightAnchor.constraint(equalToConstant: 28),
            weatherImageView.widthAnchor.constraint(equalToConstant: 28)
        ])
    }
}
