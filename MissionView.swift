//
//  MissionView.swift
//  MoonShot
//
//  Created by Vitor Grangeia on 02/07/25.
//

import SwiftUI

struct RetangleView: View {
    var body: some View {
        Rectangle()
            .frame(height: 2)
            .foregroundColor(Color(.lightGray))
            .padding(.vertical)
    }
}

struct MissionView: View {
    struct CrewMember {
        let role: String
        let astronaut: Astronaut
    }
    let mission: Mission
    let crew: [CrewMember]

    var body: some View {
                ScrollView {
            VStack {
                Image(mission.image)
                    .resizable()
                    .scaledToFit()
                    .containerRelativeFrame(.horizontal) { width, axis in
                        width * 0.6
                    }
                Text(mission.formattedLaunchDate)
                    .padding(.top)

                VStack(alignment: .leading) {
                    
                    RetangleView()
                    
                    Text("Mission Highlights")
                        .font(.title.bold())
                        .padding(.bottom, 5)

                    Text(mission.description)
                    
                    RetangleView()
                    
                    Text("Crew")
                        .font(.title.bold())
                        .padding(.bottom, 5)

                }
                .padding(.horizontal)
                
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack {
                        ForEach(crew, id: \.role) { crewMember in
                            NavigationLink {
                                AstronautView(astronaut: crewMember.astronaut)
                            } label: {
                                HStack {
                                    Image(crewMember.astronaut.id)
                                        .resizable()
                                        .frame(width: 104, height: 72)
                                        .clipShape(Capsule())
                                        .overlay(
                                            Capsule()
                                                .strokeBorder(Color.white, lineWidth: 1)
                                        )

                                    VStack(alignment: .leading) {
                                        Text(crewMember.astronaut.name)
                                            .foregroundColor(.white)
                                            .font(.headline)
                                        Text(crewMember.role)
                                            .foregroundColor(Color.white.opacity(0.5))
                                    }
                                }
                                .padding(.horizontal)
                            }
                        }
                    }
                }

                .padding(.horizontal)
            }
            .padding(.bottom)
        }
        .navigationTitle(mission.displayName)
        .navigationBarTitleDisplayMode(.inline)
        .background(.darkBackground)
    }
    
    init(mission: Mission, astronauts: [String: Astronaut]) {
        // Armazena a missão recebida (contém id, descrição, e uma lista de tripulantes com seus IDs e funções)
        self.mission = mission

        // Cria o array 'crew' contendo CrewMember (cada um com função + astronauta completo)
        self.crew = mission.crew.map { member in
            // member é do tipo CrewRole (ex: name: "armstrong", role: "Commander")
            // Aqui tentamos encontrar no dicionário de astronautas um item com chave igual ao 'name' (id do astronauta)
            if let astronaut = astronauts[member.name] {
                // Se o astronauta for encontrado, criamos um CrewMember com a função e os dados completos do astronauta
                return CrewMember(role: member.role, astronaut: astronaut)
            } else {
                // Se não for encontrado, significa que há erro no JSON ou nos dados — paramos a execução
                fatalError("Missing \(member.name)")
            }
        }
    }


}

#Preview {
    let missions: [Mission] = Bundle.main.decode("missions.json")
    let astronauts: [String: Astronaut] = Bundle.main.decode("astronauts.json")

    return MissionView(mission: missions[0], astronauts: astronauts)
        .preferredColorScheme(.dark)
}


