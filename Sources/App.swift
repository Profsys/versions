import Foundation

class App {
    
    // MARK: Types
    
    let session = URLSession.shared
    let urls = [
        "http://test-integrator.profsys.no",
        "https://profsys-integrator.no",
        "https://itunes.apple.com/no/lookup?bundleId=no.bmf.rutine",
        "https://itunes.apple.com/no/lookup?bundleId=no.norsktrevare.rutine",
        "https://itunes.apple.com/no/lookup?bundleId=no.profsys.avvik"
    ]
    
    init(with args: [String]) {
        run(args: args)
    }
    
    
    func run(args: [String]) {
        useInput(args: args)
    }
    
    private func useInput(args: [String]) {
        print(args)
        
        for url in urls {
            checkVersion(for: url)
        }
        sleep(3)
    }
    
    private func checkVersion(for urlString: String) {
        // TODO: Support Android
        if urlString.contains("itunes") {
            printAppStoreInfo(with: urlString)
        } else {
            printServerInfo(with: urlString)
        }
    }
    
    private func printAppStoreInfo(with urlString: String) {
        let url = URL(string: urlString)
        fetchPayload(with: url, completionHandler: { payload in
            let entry = (payload["results"] as? [AnyObject])?[0]
            guard let name = entry?["artistName"] as? String,
                let app = entry?["trackName"] as? String,
                let version = entry?["version"] as? String else {
                    print("Error: could not load payload for \(url)")
                    return
            }
            print("iOS", " * \(name) \(app) \(version)")
        })
    }
    
    private func printServerInfo(with urlString: String) {
        let url = URL(string: urlString + "/ny/api/v2/config/version")
        fetchPayload(with: url, completionHandler: { (payload) -> Void in
            let branch = payload["branch"] as! String
            let commitIdAbbrev = payload["commitIdAbbrev"] as! String
            let tags = payload["tags"] as! String
            let commitTime = payload["commitTime"] as! String
            print(urlString, separator: "", terminator: " ")
            print(" * (\(commitTime)), \(commitIdAbbrev) ", separator: "", terminator: " ")
            print("[\(branch)] \(tags)")
        })
    }
    
    private func fetchPayload(with url: URL?, completionHandler: (payload: AnyObject) -> Void) {
        guard let url = url else { print("Error: could not get version")
            return
        }
        
        session.dataTask(with: url) { (data, response, error) in
            guard let data = data else {
                print("Error: did not get proper data", response, error)
                return
            }
            do {
                let serializedData = try JSONSerialization
                    .jsonObject(with: data, options: .allowFragments)
                completionHandler(payload: serializedData)
            } catch {
                print("Error: something went wrong \(error)")
            }
        }.resume()
    }
}
