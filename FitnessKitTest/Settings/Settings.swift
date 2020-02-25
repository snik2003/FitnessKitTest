//
//  Settings.swift
//  FitnessKitTest
//
//  Created by Сергей Никитин on 25/02/2020.
//  Copyright © 2020 Snik2003. All rights reserved.
//

import Foundation

enum Method: String {
    case getShedule = "schedule/get_group_lessons_v2/1/"
}

final class Settings {
    static let shared = Settings()
    
    let url = "https://sample.fitnesskit-admin.ru/"
    
    let fontTitleName = "AppleSDGothicNeo-Bold"
    let fontDescName = "AppleSDGothicNeo-Semibold"
    let fontName = "AppleSDGothicNeo-Regular"
    
    let serverErrorMessage = "Ошибка обращения к серверу. Повторите попытку позже."
    let noInternetError = "Отсутствует подключение к сети Интернет"
}
