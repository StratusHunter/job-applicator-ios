//
// Created by Terence Baker on 2019-03-07.
//

import XCTest
@testable import Job_Applicator

import Moya
import RxBlocking
import RxTest

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

        //Incorrect Values
        XCTAssertFalse(viewModel.validateApplication(name: aName, email: "Not an email", teams: team, about: about, urls: url))
        XCTAssertFalse(viewModel.validateApplication(name: aName, email: email, teams: "Not a team", about: about, urls: url))
        XCTAssertFalse(viewModel.validateApplication(name: aName, email: email, teams: team, about: about, urls: "Not a url"))
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

    func testPerformRequest() throws {

        let application = JobApplication(name: aName, email: email, about: about, urls: [url], teams: [team])
        let response = try! viewModel.performApplyRequest(application: application).toBlocking().first()!

        switch (response) {
            case .success(let app):

                XCTAssertEqual(app.name, application.name)
                XCTAssertEqual(app.email, application.email)
                XCTAssertEqual(app.about, application.about)
                XCTAssertEqual(app.teams.first, application.teams.first)
                XCTAssertEqual(app.urls.first, application.urls.first)
            case .error:

                XCTFail()
        }
    }
}
