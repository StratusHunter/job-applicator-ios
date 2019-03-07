//
// Created by Terence Baker on 2019-02-27.
//

import UIKit
import Moya
import RxSwift

struct ViewModel {

    private let service = MoyaProvider<JobApplicationService>()

    private func createTeamList(team: String) -> [Team?] {

        return team.split(separator: ",")
                .map { $0.replacingOccurrences(of: " ", with: "") } //Removes space for ', ' scenario
                .map { Team(rawValue: String($0)) }
    }

    private func createURLList(url: String) -> [URL?] {

        return url.split(separator: "\n").map { URL(string: String($0)) }
    }

    func validateApplication(name: String, email: String, teams: String, about: String, urls: String) -> Bool {

        let emailValid = !email.isEmpty && email.isEmail

        let teamList = createTeamList(team: teams)
        let teamsValid = !teamList.isEmpty && !teamList.contains(nil)

        let urlList = createURLList(url: urls)
        let urlsValid = !urlList.isEmpty && !urlList.contains(nil)

        return !name.isEmpty && emailValid && teamsValid && !about.isEmpty && urlsValid
    }

    func createApplication(name: String, email: String, teams: String, about: String, urls: String) -> JobApplication {

        let teamList = createTeamList(team: teams).compactMap { $0?.rawValue }
        let urlList = createURLList(url: urls).compactMap { $0?.absoluteString }

        return JobApplication(name: name, email: email, about: about, urls: urlList, teams: teamList)
    }

    func performApplyRequest(application: JobApplication) -> Single<APIResult<JobApplication>> {

        return service.rx.request(.apply(application: application))
                .filterSuccessfulStatusCodes()
                .map(JobApplication.self)
                .map { APIResult.success($0) }
                .catchError { Single.just(APIResult.error($0)) }
    }
}
