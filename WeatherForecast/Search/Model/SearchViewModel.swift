//
//  SearchViewModel.swift
//  WeatherForecast
//
//  Created by GiN Eugene on 1/10/2022.
//

import Foundation
import CoreLocation

struct CityStub {
    let country: String
    let name: String
    let lat: Double
    let lon: Double
}

class SearchViewModel {
    //MARK: - props
    private let dataModel: ForecastDataModel
    
    private var cities: [CityStub] = []
    
    //MARK: - init
    init(dataModel: ForecastDataModel) {
        self.dataModel = dataModel
    }
    //MARK: - methods
    private func createCityStub(_ model: CityModel, completition: @escaping (CityStub) -> Void) {
        let newCity = CityStub(country: model.country.toCountry(),
                               name: model.name,
                               lat: model.lat,
                               lon: model.lon)
        completition(newCity)
    }
    
    func getCities(_ text: String, completition: @escaping ([CityStub]) -> Void) {
        self.cities = []
        self.dataModel.takeLocFromName(text) { arr in
            arr.forEach { el in
                self.createCityStub(el) { city in
                    self.cities.append(city)
                    completition(self.cities)
                }
            }
        }
    }
}
