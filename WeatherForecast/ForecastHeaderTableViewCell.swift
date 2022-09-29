//
//  ForecastHeaderTableViewCell.swift
//  WeatherForecast
//
//  Created by GiN Eugene on 28/9/2022.
//

import UIKit

class ForecastHeaderTableViewCell: UITableViewCell {
    //MARK: - props
    
    static let cellId = "ForecastHeaderTableViewCell"
    
    //MARK: - init
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    //MARK: - subviews
    
    private let currentDateLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        label.text = "\(Date())"
        label.textColor = Palette.mainTextColor
        return label
    }()
    
    private let mainImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(named: "ic_white_day_cloudy")
        imageView.image = imageView.image?.withRenderingMode(.alwaysTemplate)
        imageView.tintColor = Palette.mainTextColor
        return imageView
    }()
    
    private let tempImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(named: "ic_temp")
        imageView.image = imageView.image?.withRenderingMode(.alwaysTemplate)
        imageView.tintColor = Palette.mainTextColor
        return imageView
    }()
    
    private let humidityImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(named: "ic_humidity")
        imageView.image = imageView.image?.withRenderingMode(.alwaysTemplate)
        imageView.tintColor = Palette.mainTextColor
        return imageView
    }()
    
    private let windImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(named: "ic_wind")
        imageView.image = imageView.image?.withRenderingMode(.alwaysTemplate)
        imageView.tintColor = Palette.mainTextColor
        return imageView
    }()
    
    private let tempLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 18, weight: .regular)
        label.text = "27°/19°"
        label.textColor = Palette.mainTextColor
        return label
    }()
    
    private let humidityLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 18, weight: .regular)
        label.text = "33%"
        label.textColor = Palette.mainTextColor
        return label
    }()
    
    private let windSpeedLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 18, weight: .regular)
        label.text = "5 m/s"
        label.textColor = Palette.mainTextColor
        return label
    }()
    
    private let windDirectionImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(named: "icon_wind_ne")
        imageView.image = imageView.image?.withRenderingMode(.alwaysTemplate)
        imageView.tintColor = Palette.mainTextColor
        return imageView
    }()
}
//MARK: - setupViews
extension ForecastHeaderTableViewCell {
    private func setupViews() {
        contentView.backgroundColor = Palette.mainTintColor
        contentView.addSubview(currentDateLabel)
        contentView.addSubview(mainImageView)
        contentView.addSubview(tempImageView)
        contentView.addSubview(humidityImageView)
        contentView.addSubview(windImageView)
        contentView.addSubview(tempLabel)
        contentView.addSubview(humidityLabel)
        contentView.addSubview(windSpeedLabel)
        contentView.addSubview(windDirectionImageView)
        
        NSLayoutConstraint.activate([
            currentDateLabel.leadingAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            currentDateLabel.topAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.topAnchor, constant: 16),
            
            mainImageView.topAnchor.constraint(equalTo: currentDateLabel.bottomAnchor, constant: 54),
            mainImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 6),
//            mainImageView.widthAnchor.constraint(equalToConstant: 150),
//            mainImageView.heightAnchor.constraint(equalToConstant: 90),
            mainImageView.widthAnchor.constraint(equalToConstant: 210),
            mainImageView.heightAnchor.constraint(equalToConstant: 140),
            
            tempImageView.topAnchor.constraint(equalTo: mainImageView.topAnchor, constant: 25),
            tempImageView.leadingAnchor.constraint(equalTo: mainImageView.trailingAnchor, constant: 30),
            tempImageView.widthAnchor.constraint(equalToConstant: 18),
            tempImageView.heightAnchor.constraint(equalToConstant: 20),
            
            humidityImageView.topAnchor.constraint(equalTo: tempImageView.bottomAnchor, constant: 15),
            humidityImageView.leadingAnchor.constraint(equalTo: mainImageView.trailingAnchor, constant: 30),
            humidityImageView.widthAnchor.constraint(equalToConstant: 18),
            humidityImageView.heightAnchor.constraint(equalToConstant: 20),
            
            windImageView.topAnchor.constraint(equalTo: humidityImageView.bottomAnchor, constant: 15),
            windImageView.leadingAnchor.constraint(equalTo: mainImageView.trailingAnchor, constant: 30),
            windImageView.widthAnchor.constraint(equalToConstant: 18),
            windImageView.heightAnchor.constraint(equalToConstant: 20),
            
            tempLabel.topAnchor.constraint(equalTo: tempImageView.topAnchor),
            tempLabel.leadingAnchor.constraint(equalTo: tempImageView.trailingAnchor, constant: 10),
            
            humidityLabel.topAnchor.constraint(equalTo: humidityImageView.topAnchor),
            humidityLabel.leadingAnchor.constraint(equalTo: humidityImageView.trailingAnchor, constant: 10),
            
            windSpeedLabel.topAnchor.constraint(equalTo: windImageView.topAnchor),
            windSpeedLabel.leadingAnchor.constraint(equalTo: windImageView.trailingAnchor, constant: 10),
            
            windDirectionImageView.topAnchor.constraint(equalTo: windImageView.topAnchor, constant:  -5),
            windDirectionImageView.leadingAnchor.constraint(equalTo: windSpeedLabel.trailingAnchor),
            windDirectionImageView.widthAnchor.constraint(equalToConstant: 30),
            windDirectionImageView.heightAnchor.constraint(equalToConstant: 30)
        ])
    }
}
