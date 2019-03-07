//
// Created by Terence Baker on 2019-03-04.
//

import Foundation

enum APIResult<T> {

    case success(T)
    case error(Error)
}
