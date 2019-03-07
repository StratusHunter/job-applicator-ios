//
// Created by Terence Baker on 2019-02-27.
//

import Foundation

struct Settings {

    static let instance = Settings()

    let baseURL: String

    private init() {

        baseURL = Bundle.main.infoDictionary!["baseURL"] as! String
    }
}
