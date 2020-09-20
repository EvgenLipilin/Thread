import Cocoa
import Foundation


public struct Bread {
    public enum BreadType: UInt32 {
        case small = 1
        case medium
        case big
    }
    public let breadType: BreadType
    public static func make() -> Bread {
        guard let breadType = Bread.BreadType(rawValue: UInt32(arc4random_uniform(3) + 1)) else {
            fatalError("Incorrect random value")
        }
        return Bread(breadType: breadType)
    }
    public func bake() {
        let bakeTime = breadType.rawValue
        sleep(UInt32(bakeTime))
    }
}

//Домашнее задание 1
// Класс хранилища
class Storage {
    
    var storage = [Bread]()
    let conditions = NSCondition()
    
    var storageIsEmpty: Bool {
        storage.isEmpty
    }
    
    func addToStorage(_ bread: Bread) {
        
        conditions.lock()
        storage.append(bread)
        conditions.signal()
        conditions.unlock()
        
    }
    
    func pickupFromStorage() -> Bread {
        
        conditions.lock()
        while (storage.isEmpty) {
            conditions.wait()
        }
        let bread = storage.removeLast()
        conditions.unlock()
        return bread
        
    }
}

//Пораждающий поток:
class GenerationFlow: Thread {
    
    var storage: Storage
    
    init (storage: Storage) {
    self.storage = storage
        
    }
    
    override func main() {
        
        let timer = Timer(timeInterval: 2, target: self, selector: #selector(startCounter), userInfo: nil, repeats: true)
        let runLoop = RunLoop.current
        runLoop.add(timer, forMode: .default)
        runLoop.run(until: Date(timeIntervalSinceNow: 20))
    }
    
    @objc private func startCounter() {
        storage.addToStorage(Bread.make())
        //print("положил в хранилище хлеб")
        
    }
}

// Рабочий поток:
class WorkFlow: Thread {
    
    var storage: Storage
    
    init (storage: Storage) {
    self.storage = storage
        
    }
    
    override func main() {
        
        while generationFlow.isExecuting == true || storage.storageIsEmpty == false {
                let bread = storage.pickupFromStorage()
                Bread.bake(bread)
               // print("Забрал из хранилища хлеб и начинаю печь")
            
            }
        }
}

//Запуск программы:
let storageBread = Storage()
let generationFlow = GenerationFlow(storage: storageBread)
let workFlow = WorkFlow(storage: storageBread)

generationFlow.start()
workFlow.start()




