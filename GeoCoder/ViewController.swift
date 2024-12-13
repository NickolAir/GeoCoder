import UIKit
import MapKit

class ViewController: UIViewController {

    private let viewModel = AddressViewModel()

    private lazy var addressTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Введите адрес"
        textField.borderStyle = .roundedRect
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()

    private lazy var findButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Найти", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    private lazy var mapView: MKMapView = {
        let mapView = MKMapView()
        mapView.translatesAutoresizingMaskIntoConstraints = false
        return mapView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupBindings()
    }

    private func setupUI() {
        view.backgroundColor = .white
        view.addSubview(addressTextField)
        view.addSubview(findButton)
        view.addSubview(mapView)

        NSLayoutConstraint.activate([
            addressTextField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            addressTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            addressTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            addressTextField.heightAnchor.constraint(equalToConstant: 40),

            findButton.topAnchor.constraint(equalTo: addressTextField.bottomAnchor, constant: 16),
            findButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            findButton.heightAnchor.constraint(equalToConstant: 40),

            mapView.topAnchor.constraint(equalTo: findButton.bottomAnchor, constant: 20),
            mapView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            mapView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            mapView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])

        findButton.addTarget(self, action: #selector(findButtonTapped), for: .touchUpInside)
    }

    private func setupBindings() {
        viewModel.onError = { [weak self] errorMessage in
            DispatchQueue.main.async {
                self?.showAlert(message: errorMessage)
            }
        }

        viewModel.onLocationFound = { [weak self] location in
            DispatchQueue.main.async {
                self?.updateMap(with: location)
            }
        }
    }

    @objc private func findButtonTapped() {
        guard let address = addressTextField.text else { return }
        viewModel.findLocation(for: address)
    }

    private func updateMap(with location: CLLocation) {
        let coordinate = location.coordinate
        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinate
        annotation.title = "Найденный адрес"
        mapView.addAnnotation(annotation)

        let region = MKCoordinateRegion(center: coordinate, latitudinalMeters: 500, longitudinalMeters: 500)
        mapView.setRegion(region, animated: true)
    }

    private func showAlert(message: String) {
        let alert = UIAlertController(title: "Ошибка", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
}
