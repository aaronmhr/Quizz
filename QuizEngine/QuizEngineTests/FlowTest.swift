//
//  FlowTest.swift
//  QuizEngineTests
//
//  Created by Aaron Huánuco on 15/09/2019.
//  Copyright © 2019 Aaron Huánuco. All rights reserved.
//

import Foundation
import XCTest
@testable import QuizEngine

class FlowTest: XCTestCase {
    
    func test_start_withNoQuestions_doesNotDelegateQuestionHandling() {
        makeSUT(questions: []).start()
        
        XCTAssertTrue(delegate.handledQuestions.isEmpty)
    }
    
    func test_start_withOneQuestions_delegatesCorrectQuestionHandling() {
        makeSUT(questions: ["Q1"]).start()
        
        XCTAssertEqual(delegate.handledQuestions, ["Q1"])
    }
    
    func test_start_withOneQuestions_delegatesAnotherCorrectQuestionHandling() {
        makeSUT(questions: ["Q2"]).start()
        
        XCTAssertEqual(delegate.handledQuestions, ["Q2"])
    }
    
    func test_start_withTwoQuestions_delegatesFirstQuestionHandling() {
        makeSUT(questions: ["Q1", "Q2"]).start()
        
        XCTAssertEqual(delegate.handledQuestions, ["Q1"])
    }
    
    func test_startTwice_withTwoQuestions_delegatesFirstQuestionHandlingTwice() {
        let sut = makeSUT(questions: ["Q1", "Q2"])
        
        sut.start()
        sut.start()
        
        XCTAssertEqual(delegate.handledQuestions, ["Q1", "Q1"])
    }
    
    func test_startAndAnswerFirstAndSecondQuestion_withThreeQuestions_delegatesSecondAndThirdQuestionHandling() {
        let sut = makeSUT(questions: ["Q1", "Q2", "Q3"])
        sut.start()
        
        delegate.answerCallback("A1")
        delegate.answerCallback("A2")
        
        XCTAssertEqual(delegate.handledQuestions, ["Q1", "Q2", "Q3"])
    }
    
    func test_startAndAnswerFirstQuestion_withOneQuestion_doesNotDelegateQuestionHandling() {
        let sut = makeSUT(questions: ["Q1"])
        sut.start()
        
        delegate.answerCallback("A1")
        
        XCTAssertEqual(delegate.handledQuestions, ["Q1"])
    }
    
    func test_start_withNoQuestions_delegatesResultHandling() {
        makeSUT(questions: []).start()
        
        XCTAssertEqual(delegate.handledResult!.answers, [:])
    }
    
    func test_start_withOneQuestion_doesNotDelegateResultHandling() {
        makeSUT(questions: ["Q1"]).start()
        
        XCTAssertNil(delegate.handledResult)
    }
    
    func test_startAndAnswerFirstQuestion_withTwoQuestions_doesNotDelegateResultHandling() {
        let sut = makeSUT(questions: ["Q1", "Q2"])
        sut.start()
        
        delegate.answerCallback("A1")
        
        XCTAssertNil(delegate.handledResult)
    }
    
    func test_startAndAnswerFirstAndSecondQuestion_withTwoQuestion_delegatesResultHandling() {
        let sut = makeSUT(questions: ["Q1", "Q2"])
        sut.start()
        
        delegate.answerCallback("A1")
        delegate.answerCallback("A2")
        
        XCTAssertEqual(delegate.handledResult?.answers, ["Q1" : "A1", "Q2": "A2"])
    }

    func test_startAndAnswerFirstAndSecondQuestion_withTwoQuestion_scores() {
        let sut = makeSUT(questions: ["Q1", "Q2"]) { _ in 10}
        sut.start()

        delegate.answerCallback("A1")
        delegate.answerCallback("A2")

        XCTAssertEqual(delegate.handledResult?.score, 10)
    }

    func test_startAndAnswerFirstAndSecondQuestion_withTwoQuestion_scoresWithRightAnswers() {
        var receivedAnswers = [String: String]()
        let sut = makeSUT(questions: ["Q1", "Q2"]) { answers in
            receivedAnswers = answers
            return 0
        }
        sut.start()

        delegate.answerCallback("A1")
        delegate.answerCallback("A2")

        XCTAssertEqual(receivedAnswers, ["Q1" : "A1", "Q2": "A2"])
    }
    
    // MARK: Helpers

    private let delegate = DelegateSpy()

    private weak var weakSUT: Flow<String, String, DelegateSpy>?

    override func tearDown() {
        super.tearDown()

        XCTAssertNil(weakSUT, "Memory leak detected. Weak reference to the SUT instance is not nil.")
    }
    
    private func makeSUT(questions: [String],
                 scoring: @escaping ([String: String]) -> Int = { _ in 0 }) -> Flow<String, String, DelegateSpy> {
        let sut = Flow(questions: questions, router: delegate, scoring: scoring)
        weakSUT = sut
        return sut
    }

    private class DelegateSpy: Router, QuizDelegate {

        var handledQuestions: [String] = []
        var handledResult: QuizEngine.Result<String, String>? = nil
        var answerCallback: (String) -> Void = { _ in }

        func handle(question: String, answerCallback: @escaping (String) -> Void) {
            handledQuestions.append(question)
            self.answerCallback = answerCallback
        }

        func handle(result: Result<String, String>) {
            handledResult =  result
        }

        func routeTo(question: String, answerCallback: @escaping (String) -> Void) {
            handle(question: question, answerCallback: answerCallback)
        }

        func routeTo(result: Result<String, String>) {
            handle(result: result)
        }
    }
}
