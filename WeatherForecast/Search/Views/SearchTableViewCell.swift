//
//  SearchTableViewCell.swift
//  WeatherForecast
//
//  Created by GiN Eugene on 1/10/2022.
//

import UIKit

class SearchTableViewCell: UITableViewCell {
    //MARK: - props
    static let cellId = "SearchTableViewCell"
    
    //MARK: - init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    //MARK: - subviews
    let cityLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = Palette.secondTextColor
        return label
    }()
    //MARK: - methods
    private func setupViews() {
        contentView.backgroundColor = Palette.mainTextColor
        contentView.addSubview(cityLabel)
        
        NSLayoutConstraint.activate([
            cityLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            cityLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor,constant: 20),
            cityLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            cityLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
}

