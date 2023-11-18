import UIKit

var greeting = "Hello, playground"


let nums = [1,2,3,4,5,6,7,8]


let evens = nums.filter {  $0 % 2 == 0 }

print(evens)

//http://demo3662440.mockable.io/



struct User : Decodable {
    let name: String
    let id: Int
}

enum NetworkError: Error {
    
    case invalidURL
}


protocol NetworkActions {
    func request(_ url: String) async throws -> User
}
struct NetworkManager: NetworkActions {
    func request(_ url: String) async throws -> User {
        guard let urlObj = URL(string: url) else {
            throw NetworkError.invalidURL
        }
        
        let (data, response) = try await URLSession.shared.data(from: urlObj)
    
        return try JSONDecoder().decode(User.self, from: data)
    }
}

class ViewModel {
    private let networkManager: NetworkActions
    
    init(networkManager: NetworkActions) {
        self.networkManager = networkManager
    }
    
    func getUser() {
        Task {
            
            do {
                let user = try await networkManager.request("https://demo3662440.mockable.io/")
                print(user)
            }catch {
                print(error)
            }
        }
    }
}

let viewModel = ViewModel(networkManager: NetworkManager())


viewModel.getUser()



func add<T: Numeric>(a: T, b: T) -> T {
    return a + b
}









