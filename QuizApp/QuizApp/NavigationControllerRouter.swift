//
//  NavigationControllerRouter.swift
//  QuizApp
//
//  Created by Aaron Huánuco on 13/12/20.
//  Copyright © 2020 Aaron Huánuco. All rights reserved.
//

import UIKit
import QuizEngine

class NavigationControllerRouter: Router {
    private let navigationController: UINavigationController
    private let factory: ViewControllerFactory

    init(_ navigationController: UINavigationController, factory: ViewControllerFactory) {
        self.navigationController = navigationController
        self.factory = factory
    }

    func routeTo(question: Question<String>, answerCallback: @escaping ([String]) -> Void) {
        let viewController = factory.questionViewController(for: question, answerCallback: answerCallback)
        show(viewController)
    }

    func routeTo(result: Result<Question<String>, [String]>) {
        let viewController = factory.resultsViewController(for: result)
        show(viewController)
    }

    private func show(_ viewController: UIViewController) {
        navigationController.pushViewController(viewController, animated: true)
    }
}
