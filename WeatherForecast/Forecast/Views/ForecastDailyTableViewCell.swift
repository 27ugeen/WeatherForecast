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
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        self.selectedBackgroundView?.backgroundColor = Palette.mainTextColor
        dayLabel.textColor = selected ? Palette.mainTintColor : Palette.secondTextColor
        tempLabel.textColor = selected ? Palette.mainTintColor : Palette.secondTextColor
        weatherImageView.tintColor = selected ? Palette.mainTintColor : Palette.secondTextColor
        wrapperView.layer.shadowColor = selected ? Palette.mainShadowTextColor.cgColor : .none
        wrapperView.layer.shadowOpacity = selected ? 0.8 : .zero
    }
    //MARK: - subviews
    private let wrapperView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Palette.mainTextColor
        view.layer.masksToBounds = false
        view.layer.shadowRadius = 15
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
        self.backgroundColor = Palette.mainTextColor
        contentView.addSubview(wrapperView)
        
        wrapperView.addSubview(dayLabel)
        wrapperView.addSubview(tempLabel)
        wrapperView.addSubview(weatherImageView)
        
        NSLayoutConstraint.activate([
            wrapperView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            wrapperView.topAnchor.constraint(equalTo: contentView.topAnchor),
            wrapperView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            wrapperView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            
            dayLabel.leadingAnchor.constraint(equalTo: wrapperView.leadingAnchor, constant: 20),
            dayLabel.topAnchor.constraint(equalTo: wrapperView.topAnchor),
            dayLabel.trailingAnchor.constraint(equalTo: wrapperView.trailingAnchor),
            dayLabel.bottomAnchor.constraint(equalTo: wrapperView.bottomAnchor),
            
            tempLabel.centerXAnchor.constraint(equalTo: wrapperView.centerXAnchor),
            tempLabel.centerYAnchor.constraint(equalTo: wrapperView.centerYAnchor),
            
            weatherImageView.trailingAnchor.constraint(equalTo: wrapperView.trailingAnchor,constant: -20),
            weatherImageView.centerYAnchor.constraint(equalTo: wrapperView.centerYAnchor),
            weatherImageView.heightAnchor.constraint(equalToConstant: 28),
            weatherImageView.widthAnchor.constraint(equalToConstant: 28)
        ])
    }
}
