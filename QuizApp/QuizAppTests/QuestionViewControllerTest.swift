//
//  QuestionViewControllerTest.swift
//  QuizAppTests
//
//  Created by Aaron Huánuco on 15/09/2019.
//  Copyright © 2019 Aaron Huánuco. All rights reserved.
//

import Foundation
import XCTest
@testable import QuizApp

class QuestionViewControllerTest: XCTestCase {
    
    func test_viewDidLoad_rendersQuestionHeaderText() {
        XCTAssertEqual(makeSUT(question: "Q1").headerLabel.text, "Q1")
    }
    
    func test_viewDidLoad_withOneOption_rendersOneOptions() {
        XCTAssertEqual(makeSUT(options: []).tableView.numberOfRows(inSection: 0), 0)
        XCTAssertEqual(makeSUT(options: ["A1"]).tableView.numberOfRows(inSection: 0), 1)
        XCTAssertEqual(makeSUT(options: ["A1", "A2"]).tableView.numberOfRows(inSection: 0), 2)
    }
    
    func test_viewDidLoad_withOneOption_rendersOneOptionText() {
        XCTAssertEqual(makeSUT(options: ["A1"]).tableView.title(at: 0), "A1")
        XCTAssertEqual(makeSUT(options: ["A1", "A2"]).tableView.title(at: 1), "A2")
    }
    
    func test_optionSelected_withSingleSelection_notifiesDelegateWithLastSelection() {
        var receivedAnswer: [String] = []
        let sut = makeSUT(options: ["A1", "A2"]) { receivedAnswer = $0 }
        
        sut.tableView.select(row: 0)
        XCTAssertEqual(receivedAnswer, ["A1"])
        
        sut.tableView.select(row: 1)
        XCTAssertEqual(receivedAnswer, ["A2"])
    }
    
    func test_optionDeselected_withSingleSelection_doesNotNotifyDelegateWithEmptySelection() {
        var callbackCount = 0
        let sut = makeSUT(options: ["A1", "A2"]) { _ in callbackCount += 1 }
        
        sut.tableView.select(row: 0)
        XCTAssertEqual(callbackCount, 1)
        
        sut.tableView.deselect(row: 0)
        XCTAssertEqual(callbackCount, 1)
    }
    
    func test_optionSelected_withMultipleSelectionEnabled_notifiesDelegateWithLastSelection() {
        var receivedAnswer: [String] = []
        let sut = makeSUT(options: ["A1", "A2"], isMultipleSelection: true) { receivedAnswer = $0 }

        sut.tableView.select(row: 0)
        XCTAssertEqual(receivedAnswer, ["A1"])

        sut.tableView.select(row: 1)
        XCTAssertEqual(receivedAnswer, ["A1", "A2"])
    }
    
    func test_optionDeselected_withMultipleSelectionEnabled_notifiesDelegate() {
        var receivedAnswer: [String] = []
        let sut = makeSUT(options: ["A1", "A2"], isMultipleSelection: true) { receivedAnswer = $0 }
        
        sut.tableView.select(row: 0)
        XCTAssertEqual(receivedAnswer, ["A1"])
        
        sut.tableView.deselect(row: 0)
        XCTAssertEqual(receivedAnswer, [])
    }
    
    // MARK: Helpers
    
    func makeSUT(question: String = "",
                 options: [String] = [],
                 isMultipleSelection: Bool = false,
                 selection: @escaping ([String]) -> Void = { _ in }) -> QuestionViewController {
        let sut = QuestionViewController(question: question, options: options, selection: selection)
        sut.loadViewIfNeeded()
        sut.tableView.allowsMultipleSelection = isMultipleSelection
        return sut
    }
}
