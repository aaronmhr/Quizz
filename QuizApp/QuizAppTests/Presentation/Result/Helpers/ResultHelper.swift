//
//  ResultHelper.swift
//  QuizAppTests
//
//  Created by Aaron Huánuco on 13/12/20.
//  Copyright © 2020 Aaron Huánuco. All rights reserved.
//

@testable import QuizEngine

extension Result {
    static func make(answers: [Question: Answer] = [:], score: Int = 0) -> Result<Question, Answer> {
        Result(answers: answers, score: score)
    }
}

extension Result: Equatable where Answer: Equatable {
    public static func == (lhs: Result<Question, Answer>, rhs: Result<Question, Answer>) -> Bool {
        lhs.score == rhs.score && lhs.answers == rhs.answers
    }
}

extension Result: Hashable where Answer: Hashable {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(answers)
        hasher.combine(score)
    }
}
