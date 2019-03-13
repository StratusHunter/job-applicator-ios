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

    func test_validateApplication_withValidData_assertTrue() {

        let validData = viewModel.validateApplication(name: aName, email: email, teams: team, about: about, urls: url)

        XCTAssertTrue(validData, "Valid data no longer considered valid")
    }

    func test_validateApplication_withMissingData_assertFalse() {

        let nameMissing = viewModel.validateApplication(name: "", email: email, teams: team, about: about, urls: url)
        let emailMissing = viewModel.validateApplication(name: aName, email: "", teams: team, about: about, urls: url)
        let teamMissing = viewModel.validateApplication(name: aName, email: email, teams: "", about: about, urls: url)
        let aboutMissing = viewModel.validateApplication(name: aName, email: email, teams: team, about: "", urls: url)
        let urlMissing = viewModel.validateApplication(name: aName, email: email, teams: team, about: about, urls: "")

        XCTAssertFalse(nameMissing, "Name should not be empty")
        XCTAssertFalse(emailMissing, "Email should not be empty")
        XCTAssertFalse(teamMissing, "Team should not be empty")
        XCTAssertFalse(aboutMissing, "About should not be empty")
        XCTAssertFalse(urlMissing, "URLs should not be empty")
    }

    func test_validationApplication_withIncorrectData_assertFalse() {

        let emailInvalid = viewModel.validateApplication(name: aName, email: "Not an email", teams: team, about: about, urls: url)
        let teamInvalid = viewModel.validateApplication(name: aName, email: email, teams: "Not a team", about: about, urls: url)
        let urlInvalid = viewModel.validateApplication(name: aName, email: email, teams: team, about: about, urls: "Not a url")

        XCTAssertFalse(emailInvalid, "Email validation failing")
        XCTAssertFalse(teamInvalid, "Team validation failing")
        XCTAssertFalse(urlInvalid, "URL validation failing")
    }

    func test_createApplication_validatePropertyMapping_assertEqual() {

        let application = viewModel.createApplication(name: aName,
                                                      email: email,
                                                      teams: team,
                                                      about: about,
                                                      urls: url)

        XCTAssertEqual(application.name, aName, "Name property not mapped correctly")
        XCTAssertEqual(application.email, email, "Email property not mapped correctly")
        XCTAssertEqual(application.about, about, "About property not mapped correctly")
        XCTAssertEqual(application.teams.first, team, "Team property not mapped correctly")
        XCTAssertEqual(application.urls.first, url, "URL property not mapped correctly")
    }

    func test_createApplication_validateArrayPopulation_assertEqual() {

        let application = viewModel.createApplication(name: aName,
                                                      email: email,
                                                      teams: "\(team), \(Team.ios.rawValue)",
                                                      about: about,
                                                      urls: "\(url)\n\(url)")

        XCTAssertEqual(application.teams.count, 2, "Unexpected team array size")
        XCTAssertEqual(application.urls.count, 2, "Unexpected URL array size")
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
