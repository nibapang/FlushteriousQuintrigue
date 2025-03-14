//
//  QuinNumberPuzzleVC.swift
//  FlushteriousQuintrigue
//
//  Created by Sun on 2025/3/14.
//

import UIKit

class QuinNumberPuzzleVC: UIViewController {
    
    @IBOutlet weak var targetLabel: UILabel!
    @IBOutlet weak var resultLabel: UILabel!
    @IBOutlet weak var starLabel: UILabel!

    @IBOutlet var numberButtons: [UIButton]!
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var subtractButton: UIButton!
    @IBOutlet weak var multiplyButton: UIButton!
    @IBOutlet weak var divideButton: UIButton!
    @IBOutlet weak var resetButton: UIButton!
    @IBOutlet weak var nextPuzzleButton: UIButton!

    var targetNumber = 0
    var currentResult: Int = 0
    var lastOperation: String? = nil
    var equationHistory: String = "" // Stores the equation history

    var puzzles: [(target: Int, numbers: [Int])] = []
    var currentPuzzleIndex = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        generatePuzzles()
        setupNewGame()
    }

    func generatePuzzles() {
        for _ in 1...5 {
            let target = Int.random(in: 50...150)
            let numbers = [4, 7, 8, 15, 20, 25].shuffled()
            puzzles.append((target, numbers))
        }
    }

    func setupNewGame() {
        if currentPuzzleIndex >= puzzles.count {
            showAlert(title: "Game Over", message: "You've completed all puzzles!")
            return
        }

        let puzzle = puzzles[currentPuzzleIndex]
        targetNumber = puzzle.target
        targetLabel.text = "Target: \(targetNumber)"
        resultLabel.text = "Result: 0"
        starLabel.text = "Stars: ⭐⭐⭐"

        equationHistory = ""
        currentResult = 0
        lastOperation = nil

        for (index, button) in numberButtons.enumerated() {
            button.setTitle("\(puzzle.numbers[index])", for: .normal)
            button.isEnabled = true
            button.alpha = 1.0 // Ensure buttons appear enabled
        }
    }

    @IBAction func numberTapped(_ sender: UIButton) {
        guard let numberValue = Int(sender.currentTitle ?? "") else { return }

        if let operation = lastOperation {
            // Apply the operation with the selected number
            applyOperation(operation, with: numberValue)
            lastOperation = nil // Reset operation after applying
        } else {
            // If no operation was selected, just set the result to the tapped number
            currentResult = numberValue
            equationHistory = "\(numberValue)" // Start equation history
        }

        resultLabel.text = "Result: \(currentResult)"

        checkResult()
    }

    
    @IBAction func operationTapped(_ sender: UIButton) {
        guard currentResult != 0 else { return } // Prevent operation selection without a number
        lastOperation = sender.titleLabel?.text
    }

    func applyOperation(_ operation: String, with number: Int) {
        let previousResult = currentResult // Store the previous result before applying the operation

        switch operation {
        case "+": currentResult += number
        case "-": currentResult -= number
        case "×": currentResult *= number
        case "÷":
            if number != 0 { currentResult /= number }
        default: break
        }

        // Update equation history
        equationHistory += " \(operation) \(number) = \(currentResult)"

        resultLabel.text = "Result: \(currentResult)"
        checkResult()
    }

    @IBAction func resetTapped(_ sender: UIButton) {
        setupNewGame()
    }

    @IBAction func nextPuzzleTapped(_ sender: UIButton) {
        currentPuzzleIndex += 1
        setupNewGame()
    }

    func checkResult() {
        let difference = abs(currentResult - targetNumber)
        var stars = 0

        if difference == 0 {
            stars = 3
        } else if difference <= 10 {
            stars = 2
        } else if difference <= 25 {
            stars = 1
        }

        let starText = ["⭐", "⭐⭐", "⭐⭐⭐"]
        starLabel.text = "Stars: \(stars > 0 ? starText[stars - 1] : "No Stars")"

        if difference == 0 {
            showAlert(title: "Puzzle Complete!", message: "You hit the target and earned 3 stars! ⭐⭐⭐")
        }
    }

    func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default) { _ in
            self.nextPuzzleTapped(self.nextPuzzleButton)
        })
        present(alert, animated: true)
    }
}

