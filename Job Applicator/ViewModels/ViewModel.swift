//
// Created by Terence Baker on 2019-02-27.
// Copyright (c) 2019 Bulb Studios Ltd. All rights reserved.
//

import UIKit
import Moya
import RxSwift

struct ViewModel {

    private let service = MoyaProvider<JobApplicationService>()

    private func createTeamList(team: String) -> [String] {

        return team.split(separator: ",").map { String($0) }
    }

    private func createURLList(url: String) -> [String] {

        return url.split(separator: "\n").map { String($0) }
    }

    func validateApplication(name: String, email: String, teams: String, about: String, urls: String) -> Bool {

        let emailValid = !email.isEmpty && email.isEmail
        let teamsValid = !createTeamList(team: teams).isEmpty
        let urlsValid = !createURLList(url: urls).isEmpty

        return !name.isEmpty && emailValid && teamsValid && !about.isEmpty && urlsValid
    }

    func createApplication(name: String, email: String, teams: String, about: String, urls: String) -> JobApplication {

        return JobApplication(name: name, email: email, about: about,
                              urls: createURLList(url: urls), teams: createTeamList(team: teams))
    }

    func performApplyRequest(application: JobApplication) -> Single<APIResult<JobApplication>> {

        return service.rx.request(.apply(application: application))
                .filterSuccessfulStatusCodes()
                .map(JobApplication.self)
                .map { APIResult.success($0) }
                .catchError { Single.just(APIResult.error($0)) }
    }
}
