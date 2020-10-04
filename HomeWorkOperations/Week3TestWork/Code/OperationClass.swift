
import Foundation

class PasswordBrute: Operation {
    
    let characterArray = Consts.characterArray
    var startIndex = [Int]()
    var endIndex = [Int]()
    let imputPassword: String
    var findPasswordOperation: String?
    
    init(startIndexArray:[Int], endIndexArray:[Int], password: String ) {
        self.startIndex = startIndexArray
        self.endIndex = endIndexArray
        self.imputPassword = password
    }

    override func main() {
        
        var currentIndexArray = startIndex
        let maxIndexArray = characterArray.count
        
        // Цикл подбора пароля
        while true {
            
            // Формируем строку проверки пароля из элементов массива символов
            let currentPass = self.characterArray[currentIndexArray[0]] + self.characterArray[currentIndexArray[1]] + self.characterArray[currentIndexArray[2]] + self.characterArray[currentIndexArray[3]]
            
            // Выходим из цикла если пароль найден, или, если дошли до конца массива индексов
            if imputPassword == currentPass {
                findPasswordOperation = currentPass
                break
            } else {
                if currentIndexArray.elementsEqual(endIndex) {
                    break
                }
                
                // Если пароль не найден, то происходит увеличение индекса. Для этого в цикле, начиная с последнего элемента осуществляется проверка текущего значения. Если оно меньше максимального значения (61), то индекс просто увеличивается на 1.
                //Например было [0, 0, 0, 5] а станет [0, 0, 0, 6]. Если же мы уже проверили последний индекс, например [0, 0, 0, 61], то нужно сбросить его в 0, а "старший" индекс увеличить на 1. При этом далее в цикле проверяется переполение "старшего" индекса тем же алгоритмом.
                //Таким образом [0, 0, 0, 61] станет [0, 0, 1, 0]. И поиск продолжится дальше:  [0, 0, 1, 1],  [0, 0, 1, 2],  [0, 0, 1, 3] и т.д.
                for index in (0 ..< currentIndexArray.count).reversed() {
                    guard currentIndexArray[index] < maxIndexArray - 1 else {
                        currentIndexArray[index] = 0
                        continue
                    }
                    currentIndexArray[index] += 1
                    break
                }
            }
        }
    }
}
