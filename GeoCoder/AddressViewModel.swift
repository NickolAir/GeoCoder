import Foundation
import CoreLocation

class AddressViewModel {
    private let geocoder = CLGeocoder()
    var onError: ((String) -> Void)?
    var onLocationFound: ((CLLocation) -> Void)?

    func findLocation(for address: String) {
        guard !address.isEmpty else {
            onError?("Введите адрес")
            return
        }

        geocoder.geocodeAddressString(address) { [weak self] placemarks, error in
            if let error = error {
                self?.onError?(error.localizedDescription)
                return
            }

            guard let location = placemarks?.first?.location else {
                self?.onError?("Адрес не найден")
                return
            }

            self?.onLocationFound?(location)
        }
    }
}
