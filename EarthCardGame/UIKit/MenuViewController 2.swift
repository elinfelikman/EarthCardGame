import UIKit
import CoreLocation

final class MenuViewController: UIViewController {
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var sideLabel: UILabel!
    @IBOutlet weak var startButton: UIButton!

    private(set) var isUserEastSide: Bool = false
    private let thresholdLongitude: CLLocationDegrees = 34.817549168324334

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        sideLabel.text = "Determining side..."
        startButton.isEnabled = false
        fetchLocationOnce()
    }

    private func fetchLocationOnce() {
        LocationManager.shared.requestOneShotLocation { [weak self] location in
            DispatchQueue.main.async {
                guard let self = self else { return }
                if let lon = location?.coordinate.longitude {
                    self.isUserEastSide = lon > self.thresholdLongitude
                } else {
                    // Default side if location unavailable
                    self.isUserEastSide = false
                }
                self.sideLabel.text = self.isUserEastSide ? "East Side" : "West Side"
                self.startButton.isEnabled = true
            }
        }
    }

    @IBAction func startTapped(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let game = storyboard.instantiateViewController(withIdentifier: "GameViewController") as? GameViewController else { return }
        let name = (nameTextField.text?.isEmpty == false) ? nameTextField.text! : "Player"
        game.userName = name
        game.isUserEastSide = isUserEastSide
        navigationController?.pushViewController(game, animated: true)
    }
}
