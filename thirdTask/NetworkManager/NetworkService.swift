//
//  NetworkService.swift
//  thirdTask
//
//  Created by Владимир Курганов on 13.09.2022.
//

import Foundation
import UIKit

//https://api.unsplash.com/
//search/
//photos?
//client_id=D5gI1GG0bygjJBskI6m-ddOYXNn5wF0JfIAO5Y6uXks
//&page=1
//&per_page=5
//&query=people

//MARK: - Path
fileprivate enum ApiKey {
    static let searchPhoto = "https://api.unsplash.com/search/photos?"
    static let clientId = "client_id=D5gI1GG0bygjJBskI6m-ddOYXNn5wF0JfIAO5Y6uXks&"
    static let page = "page="
    static let perPage = "&per_page=10&query=people"
}

//MARK: - NetworkServiceProtocol
protocol NetworkServiceProtocol {
    func fetchData(numberPage: Int, _ completion: @escaping ([ResultPhoto]) -> Void)
    func downloadImage(url: URL, completion: @escaping (UIImage?) -> Void)
    func getCachedImage(url: URL, completion: @escaping (UIImage?) -> Void)
    var imageCache: NSCache<NSString, UIImage> { get set }
}

//MARK: - NetworkService
final class NetworkService: NetworkServiceProtocol {
    
    var imageCache = NSCache<NSString, UIImage>()
    
    //MARK: - Methods
    func getCachedImage(url: URL, completion: @escaping (UIImage?) -> Void) {
        let imageCache = imageCache.object(forKey: url.absoluteString as NSString)
        DispatchQueue.main.async {
            completion(imageCache)
        }
    }
    
    func downloadImage(url: URL, completion: @escaping (UIImage?) -> Void)   {
        if let imageCache = imageCache.object(forKey: url.absoluteString as NSString) {
            DispatchQueue.main.async {
                completion(imageCache)
            }
        } else {
            let request = URLRequest(url: url, cachePolicy: URLRequest.CachePolicy.returnCacheDataElseLoad, timeoutInterval: 10)
            let dataTask = URLSession.shared.dataTask(with: request) { [weak self] data, response, error in

                guard error == nil,
                    data != nil,
                    let response = response as? HTTPURLResponse,
                    response.statusCode == 200,
                    let self = self else {
                        return
                }

                guard let image = UIImage(data: data ?? Data()) else { return }
                self.imageCache.setObject(image, forKey: url.absoluteString as NSString)
                DispatchQueue.main.async {
                    completion(image)
                }
            }
            dataTask.resume()
        }
    }
    
    func fetchData(numberPage: Int, _ completion: @escaping ([ResultPhoto]) -> Void) {
        
        let numberPage = String(numberPage)
        let url = ApiKey.searchPhoto + ApiKey.clientId + ApiKey.page + numberPage + ApiKey.perPage
    
        guard let url = URL(string: url) else { return }
        
        let session = URLSession.shared
        session.dataTask(with: url) { data, response, error in
            
            guard error == nil else { return }
    
            if let data = data,
                      let response = response as? HTTPURLResponse {
                print(response.statusCode)
                
                do {
                    let result =  try JSONDecoder().decode(Profile.self, from: data)
                    completion(result.results)
            
                } catch {
                    print("Failed to connect \(error.localizedDescription)")
                }
            }
        }.resume()
    }
}
