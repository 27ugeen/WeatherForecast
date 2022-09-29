//
//  ForecastTFHoursCollectionViewCell.swift
//  WeatherForecast
//
//  Created by GiN Eugene on 29/9/2022.
//

import UIKit

class ForecastTFHoursCollectionViewCell: UICollectionViewCell {
    //MARK: - props
    static let cellId = "ForecastTFHoursCollectionViewCell"
    
    //MARK: - init
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    //MARK: - subviews
    let timeLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "01⁰⁰"
        label.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        label.textColor = Palette.mainTextColor
        return label
    }()
    
    let weatherImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(named: "ic_white_day_cloudy")
        imageView.image = imageView.image?.withRenderingMode(.alwaysTemplate)
        imageView.tintColor = Palette.mainTextColor
        return imageView
    }()
    
    let tempLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "27°"
        label.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        label.textColor = Palette.mainTextColor
        return label
    }()
}
//MARK: - setupViews
extension ForecastTFHoursCollectionViewCell {
    private func setupViews() {
        contentView.addSubview(timeLabel)
        contentView.addSubview(weatherImageView)
        contentView.addSubview(tempLabel)
        
        NSLayoutConstraint.activate([
            
            timeLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 28),
            timeLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            
            weatherImageView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            weatherImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor, constant: 8),
            weatherImageView.widthAnchor.constraint(equalToConstant: 28),
            weatherImageView.heightAnchor.constraint(equalToConstant: 28),
            
            tempLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor, constant: 4),
            tempLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -28),
        ])
    }
}

