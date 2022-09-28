//
//  ViewController.swift
//  WeatherForecast
//
//  Created by GiN Eugene on 28/9/2022.
//

import UIKit

class ForecastViewController: UIViewController {
    //MARK: - props
    let viewModel: ForecastViewModel
    
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
        
        view.backgroundColor = .blue
        viewModel.getData()
    }


}

