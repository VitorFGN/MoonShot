//
//  BumdleDecodable.swift
//  MoonShot
//
//  Created by Vitor Grangeia on 30/06/25.
//
import Foundation

extension Bundle {
    // Função para decodificar um arquivo JSON no Bundle e retornar um dicionário [String: Astronaut]
    func decode<T: Codable>(_ file: String) -> T {
        
        // Tenta encontrar a URL do arquivo JSON dentro do bundle do app usando o nome fornecido
        guard let url = self.url(forResource: file, withExtension: nil) else {
            fatalError("Failed to locate \(file) in bundle.") // Encerra se o arquivo não for encontrado
        }
        
        // Tenta carregar o conteúdo do arquivo em forma de Data (bytes)
        guard let data = try? Data(contentsOf: url) else {
            fatalError("Failed to load \(file) from bundle.") // Encerra se não conseguir carregar os dados
        }
        
        // Cria um decodificador JSON para transformar os dados em objetos Swift
        let decoder = JSONDecoder()
        let formatter = DateFormatter()
        formatter.dateFormat = "y-MM-dd"
        decoder.dateDecodingStrategy = .formatted(formatter)
        
        // Tenta decodificar os dados dentro de um bloco 'do-catch' para capturar erros detalhados
        do {
            // Tenta converter o JSON em um dicionário [String: Astronaut]
            return try decoder.decode(T.self, from: data)
            
        // Captura o erro quando uma chave esperada não é encontrada no JSON
        } catch DecodingError.keyNotFound(let key, let context) {
            fatalError("Failed to decode \(file) from bundle due to missing key '\(key.stringValue)' – \(context.debugDescription)")
            
        // Captura o erro quando há incompatibilidade de tipos (ex: string onde era esperado int)
        } catch DecodingError.typeMismatch(_, let context) {
            fatalError("Failed to decode \(file) from bundle due to type mismatch – \(context.debugDescription)")
            
        // Captura o erro quando um valor obrigatório está faltando no JSON
        } catch DecodingError.valueNotFound(let type, let context) {
            fatalError("Failed to decode \(file) from bundle due to missing \(type) value – \(context.debugDescription)")
            
        // Captura o erro quando o JSON está malformado ou inválido
        } catch DecodingError.dataCorrupted(_) {
            fatalError("Failed to decode \(file) from bundle because it appears to be invalid JSON.")
            
        // Captura quaisquer outros erros que possam ocorrer
        } catch {
            fatalError("Failed to decode \(file) from bundle: \(error.localizedDescription)")
        }
    }
}
