//
// Created by Terence Baker on 2019-03-07.
// Copyright (c) 2019 Bulb Studios Ltd. All rights reserved.
//

import XCTest
@testable import Job_Applicator
import Moya

class ViewModelTests: XCTestCase {

    private var viewModel: ViewModel!
    private let aName = "A Name"
    private let email = "test@test.com"
    private let team = Team.android.rawValue
    private let about = "About text"
    private let url = "https://test.com"

    override func setUp() {

        viewModel = ViewModel(service: MoyaProvider<JobApplicationService>(stubClosure: MoyaProvider.immediatelyStub))
    }

    override func tearDown() {

    }

    func testValidationApplication() {

        //Valid
        XCTAssertTrue(viewModel.validateApplication(name: aName, email: email, teams: team, about: about, urls: url))

        ///Missing Properties
        XCTAssertFalse(viewModel.validateApplication(name: "", email: email, teams: team, about: about, urls: url))
        XCTAssertFalse(viewModel.validateApplication(name: aName, email: "", teams: team, about: about, urls: url))
        XCTAssertFalse(viewModel.validateApplication(name: aName, email: email, teams: "", about: about, urls: url))
        XCTAssertFalse(viewModel.validateApplication(name: aName, email: email, teams: team, about: "", urls: url))
        XCTAssertFalse(viewModel.validateApplication(name: aName, email: email, teams: team, about: about, urls: ""))
    }

    func testJobApplication() {

        let application = viewModel.createApplication(name: aName, email: email,
                                                      teams: "\(team), \(Team.ios.rawValue)", about: about,
                                                      urls: "\(url)\n\(url)")

        //Property Mapping
        XCTAssertEqual(application.name, aName)
        XCTAssertEqual(application.email, email)
        XCTAssertEqual(application.about, about)
        XCTAssertEqual(application.teams.first, team)
        XCTAssertEqual(application.urls.first, url)

        //Array counts
        XCTAssertEqual(application.teams.count, 2)
        XCTAssertEqual(application.urls.count, 2)
    }
}
