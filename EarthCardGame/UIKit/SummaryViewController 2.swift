import UIKit

final class SummaryViewController: UIViewController {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var backButton: UIButton!

    var userName: String = "Player"
    var userScore: Int = 0
    var pcScore: Int = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        updateLabels()
    }

    private func updateLabels() {
        let winner: String
        if userScore > pcScore {
            winner = userName
        } else {
            winner = "PC"
        }
        titleLabel.text = "Winner: \(winner)"
        scoreLabel.text = "\(userScore) - \(pcScore)"
    }

    @IBAction func backToMenuTapped(_ sender: UIButton) {
        navigationController?.popToRootViewController(animated: true)
    }
}
