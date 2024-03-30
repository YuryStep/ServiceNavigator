//
//  NetworkService.swift
//  ServiceNavigator
//
//  Created by Юрий Степанчук on 30.03.2024.
//

import Foundation

protocol NetworkServiceProtocol {
    func fetchServiceInfo(completion: @escaping (Result<ServicesNetworkModel, NetworkError>) -> Void)
    func fetchServiceInfoWithIconImageData(completion: @escaping (Result<ServicesNetworkModel, NetworkError>) -> Void)
    func fetchImageData(from urlString: String, completion: @escaping (Result<Data, NetworkError>) -> Void)
}

final class NetworkService: NetworkServiceProtocol {
    private enum Constants {
        static let fixedStringURL = "https://publicstorage.hb.bizmrg.com/sirius/result.json"
    }

    func fetchServiceInfoWithIconImageData(completion: @escaping (Result<ServicesNetworkModel, NetworkError>) -> Void) {
        fetchServiceInfo { [weak self] servicesInfoFetchingResult in
            guard let self else { return }

            switch servicesInfoFetchingResult {
            case let .success(servicesInfoWithoutIconImageData):
                var servicesWithIconImageData: [Service] = []
                let group = DispatchGroup()

                for var service in servicesInfoWithoutIconImageData.body.services {
                    group.enter()
                    fetchImageData(from: service.iconURL) { result in
                        switch result {
                        case let .success(imageData):
                            service.iconImageData = imageData
                            servicesWithIconImageData.append(service)
                        case .failure:
                            servicesWithIconImageData.append(service)
                        }
                        group.leave()
                    }
                }

                group.notify(queue: .main) {
                    let updatedServicesInfo = ServicesNetworkModel(body: Body(services: servicesWithIconImageData), status: servicesInfoWithoutIconImageData.status)
                    completion(.success(updatedServicesInfo))
                }
            case let .failure(networkError):
                completion(.failure(networkError))
            }
        }
    }

    func fetchServiceInfo(completion: @escaping (Result<ServicesNetworkModel, NetworkError>) -> Void) {
        guard let url = URL(string: Constants.fixedStringURL) else { completion(.failure(.invalidURL))
            return
        }

        fetchData(from: url) { [weak self] dataFetchingResult in
            guard let self else { return }

            switch dataFetchingResult {
            case let .success(data):
                parseServicesInfo(from: data) { decodingResult in
                    DispatchQueue.main.async {
                        switch decodingResult {
                        case let .success(servicesInfo): completion(.success(servicesInfo))
                        case let .failure(error): completion(.failure(error))
                        }
                    }
                }
            case let .failure(error):
                DispatchQueue.main.async { completion(.failure(error)) }
            }
        }
    }

    func fetchImageData(from urlString: String, completion: @escaping (Result<Data, NetworkError>) -> Void) {
        guard let url = URL(string: urlString) else {
            completion(.failure(.invalidURL))
            return
        }

        fetchData(from: url) { result in
            DispatchQueue.main.async {
                switch result {
                case let .success(imageData):
                    completion(.success(imageData))
                case let .failure(error):
                    completion(.failure(error))
                }
            }
        }
    }

    private func fetchData(from url: URL?, completion: @escaping (Result<Data, NetworkError>) -> Void) {
        guard let url else { completion(.failure(.invalidURL))
            return
        }

        let dataTask = URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            guard let self else { return }

            if let error {
                handleNetworkError(error, completion)
            } else {
                handleHTTPResponse(response, data, completion)
            }
        }
        dataTask.resume()
    }

    private func handleNetworkError(_ error: Error, _ completion: @escaping (Result<Data, NetworkError>) -> Void) {
        if let error = error as NSError?, error.code == NSURLErrorNotConnectedToInternet {
            completion(.failure(.noInternetConnection))
        } else {
            completion(.failure(.requestFailed))
        }
    }

    private func handleHTTPResponse(_ response: URLResponse?, _ data: Data?, _ completion: @escaping (Result<Data, NetworkError>) -> Void) {
        guard let httpResponse = response as? HTTPURLResponse else {
            completion(.failure(.noServerResponse))
            return
        }

        switch httpResponse.statusCode {
        case 200:
            if let data {
                completion(.success(data))
            } else {
                completion(.failure(.noDataInServerResponse))
            }
        default:
            completion(.failure(.badResponse(statusCode: httpResponse.statusCode)))
        }
    }

    private func parseServicesInfo(from data: Data, completion: @escaping (Result<ServicesNetworkModel, NetworkError>) -> Void) {
        let decoder = JSONDecoder()
        do {
            let servicesInfo = try decoder.decode(ServicesNetworkModel.self, from: data)
            completion(.success(servicesInfo))
        } catch {
            completion(.failure(NetworkError.decodingFailed))
        }
    }
}
