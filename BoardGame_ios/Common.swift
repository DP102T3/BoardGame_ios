import Foundation
import UIKit

// 實機
// let URL_SERVER = "http://192.168.0.101:8080/Spot_MySQL_Web/"
// 模擬器
let common_url = "http://127.0.0.1:8080/BoardGame_Web/"
let common_url_forChat = "http://127.0.0.1:8080/DevBG/"
let common_url_shop = "http://127.0.0.1:8080/Advertisement_Server/"

func executeTask(_ url_server: URL, _ requestParam: [String: Any], completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) {
    // requestParam值為Any就必須使用JSONSerialization.data()，而非JSONEncoder.encode()
    let jsonData = try! JSONSerialization.data(withJSONObject: requestParam)
    var request = URLRequest(url: url_server)
    request.httpMethod = "POST"
    request.cachePolicy = NSURLRequest.CachePolicy.reloadIgnoringLocalCacheData
    request.httpBody = jsonData
    let sessionData = URLSession.shared
    let task = sessionData.dataTask(with: request, completionHandler: completionHandler)
    task.resume()
}

func showSimpleAlert(message: String, viewController: UIViewController) {
    let alertController = UIAlertController(title: "", message: message, preferredStyle: .alert)
    let cancel = UIAlertAction(title: "Cancel", style: .cancel)
    alertController.addAction(cancel)
    /* 呼叫present()才會跳出Alert Controller */
    viewController.present(alertController, animated: true, completion:nil)
}

// 存入UserDefaults（登入帳號）
func saveUserDefaults(_ key: String, _ value: String) {
    if let data = try? JSONEncoder().encode(value) {
        UserDefaults.standard.set(data, forKey: key)
    }
}

// 從UserDefaults取出（登入帳號）
func loadUserDefaults(_ forKey: String) -> String {
    if let data = UserDefaults.standard.data(forKey: forKey){
        if let value = try? JSONDecoder().decode(String.self, from: data){return value}
    }
    return ""
}
