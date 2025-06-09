//
//
//
// Created by: Patrik Drab on 08/06/2025
// Copyright (c) 2025 MHD
//
//

let allStationInfos: [StationInfo] = [
    
    StationInfo(id: "station=Pod_Salgovikom-1", stationName: "Pod Šalgovíkom", location: StationLocation(latitude: 48.993385, longitude: 21.275310)),
    StationInfo(id: "station=Pod_Salgovikom-2", stationName: "Pod Šalgovíkom", location: StationLocation(latitude: 48.993591, longitude: 21.275630)),

    StationInfo(id: "station=Vansovej-1", stationName: "Vansovej", location: StationLocation(latitude: 48.991848, longitude: 21.271312)),
    StationInfo(id: "station=Vansovej-2", stationName: "Vansovej", location: StationLocation(latitude: 48.992116, longitude: 21.271200)),

    StationInfo(id: "station=Laca_Novomeskeho-1", stationName: "Laca Novomeského", location: StationLocation(latitude: 48.989623, longitude: 21.267387)),
    StationInfo(id: "station=Laca_Novomeskeho-2", stationName: "Laca Novomeského", location: StationLocation(latitude: 48.990221, longitude: 21.267006)),

    StationInfo(id: "station=Martina_Benku-1", stationName: "Martina Benku", location: StationLocation(latitude: 48.987238, longitude: 21.264865)),
    StationInfo(id: "station=Martina_Benku-2", stationName: "Martina Benku", location: StationLocation(latitude: 48.987085, longitude: 21.264278)),

    
    StationInfo(id: "station=Pavla_Horova-1", stationName: "Pavla Horova", location: StationLocation(latitude: 48.983796, longitude: 21.263999)),
    StationInfo(id: "station=Pavla_Horova-2", stationName: "Pavla Horova", location: StationLocation(latitude: 48.983776, longitude: 21.263494)),

    
    StationInfo(id: "station=Lesnicka-1", stationName: "Lesnícka", location: StationLocation(latitude: 48.979298, longitude: 21.264117)),
    StationInfo(id: "station=Lesnicka-2", stationName: "Lesnícka", location: StationLocation(latitude: 48.978848, longitude: 21.263717)),

    
    StationInfo(id: "station=Skara-1", stationName: "Škára", location: StationLocation(latitude: 48.982052, longitude: 21.255581)),
    StationInfo(id: "station=Skara-2", stationName: "Škára", location: StationLocation(latitude: 48.981275, longitude: 21.256685)),
    
    StationInfo(id: "station=Zeleznicna_stanica-1", stationName: "Železničná stanica", location: StationLocation(latitude: 48.984187, longitude: 21.249929)),
    StationInfo(id: "station=Zeleznicna_stanica-2", stationName: "Železničná stanica", location: StationLocation(latitude: 48.983123, longitude: 21.249814)),

    StationInfo(id: "station=Cierny_most-1", stationName: "Čierny most", location: StationLocation(latitude: 48.989701, longitude: 21.246981)),
    StationInfo(id: "station=Cierny_most-2", stationName: "Čierny most", location: StationLocation(latitude: 48.989834, longitude: 21.246570)),

    StationInfo(id: "station=Divadlo_Jonasa_Zaborskeho-1", stationName: "Divadlo Jonáša Záborského", location: StationLocation(latitude: 48.993302, longitude: 21.244259)),
    
    StationInfo(id: "station=Velka_posta-1", stationName: "Veľká pošta", location: StationLocation(latitude: 48.991618, longitude: 21.245135)),

    
    StationInfo(id: "station=Na_Hlavnej-1", stationName: "Na Hlavnej", location: StationLocation(latitude: 48.995679, longitude: 21.242192)),
    StationInfo(id: "station=Na_Hlavnej-2", stationName: "Na Hlavnej", location: StationLocation(latitude: 48.996022, longitude: 21.241690)),

    StationInfo(id: "station=Trojica-1", stationName: "Trojica", location: StationLocation(latitude: 49.000214, longitude: 21.239353)),
    StationInfo(id: "station=Trojica-2", stationName: "Trojica", location: StationLocation(latitude: 48.999304, longitude: 21.239677)),

    StationInfo(id: "station=Poliklinika-1", stationName: "Poliklinika", location: StationLocation(latitude: 49.000817, longitude: 21.233234)),
    StationInfo(id: "station=Poliklinika-2", stationName: "Poliklinika", location: StationLocation(latitude: 49.000857, longitude: 21.236005)),

    StationInfo(id: "station=Clementisova-1", stationName: "Clementisova", location: StationLocation(latitude: 49.001686, longitude: 21.224418)),
    StationInfo(id: "station=Clementisova-2", stationName: "Clementisova", location: StationLocation(latitude: 49.001680, longitude: 21.223915)),

    StationInfo(id: "station=Volgogradska-1", stationName: "Volgogradská", location: StationLocation(latitude: 49.004180, longitude: 21.221071)),
    StationInfo(id: "station=Volgogradska-2", stationName: "Volgogradská", location: StationLocation(latitude: 49.003652, longitude: 21.220724)),

    
    StationInfo(id: "station=Namestie_Kralovnej_pokoja-1", stationName: "Námestie Královnej pokoja", location: StationLocation(latitude: 49.006695, longitude: 21.221511)),
    StationInfo(id: "station=Namestie_Kralovnej_pokoja-2", stationName: "Námestie Královnej pokoja", location: StationLocation(latitude: 49.007014, longitude: 21.221384)),
    
    StationInfo(id: "station=VUKOV-1", stationName: "VUKOV", location: StationLocation(latitude: 49.010566, longitude: 21.222265)),
    StationInfo(id: "station=VUKOV-2", stationName: "VUKOV", location: StationLocation(latitude: 49.012228, longitude: 21.222307)),

    StationInfo(id: "station=Centrum-1", stationName: "Centrum", location: StationLocation(latitude: 49.017061, longitude: 21.223517)),
    StationInfo(id: "station=Centrum-2", stationName: "Centrum", location: StationLocation(latitude: 49.016808, longitude: 21.223247)),
    
    StationInfo(id: "station=Prostejovska-1", stationName: "Prostejovská", location: StationLocation(latitude: 49.020839, longitude: 21.224791)),
    StationInfo(id: "station=Prostejovska-2", stationName: "Prostejovská", location: StationLocation(latitude: 49.020744, longitude: 21.224411)),
    
    StationInfo(id: "station=Sidlisko_III-1", stationName: "Sídlisko III", location: StationLocation(latitude: 49.023482, longitude: 21.228982)),
    StationInfo(id: "station=Sidlisko_III-2", stationName: "Sídlisko III", location: StationLocation(latitude: 49.023397, longitude: 21.228424)),
    
    
    
    StationInfo(id: "station=Sibirska-1", stationName: "Sibírska", location: StationLocation(latitude: 49.00087032521478, longitude: 21.272355890990337)),
    StationInfo(id: "station=Sibirska-2", stationName: "Sibírska", location: StationLocation(latitude: 49.001066672336286, longitude: 21.272552932360625)),
    
    StationInfo(id: "station=Karpatska-1", stationName: "Karpatská", location: StationLocation(latitude: 48.99721881475276, longitude: 21.270023570563403)),
    StationInfo(id: "station=Karpatska-2", stationName: "Karpatská", location: StationLocation(latitude: 48.996165652077096, longitude: 21.26919498457593)),
    
    StationInfo(id: "station=Jurkovicova-1", stationName: "Jurkovicová", location: StationLocation(latitude: 48.994353022813655, longitude: 21.26832975418699)),
    StationInfo(id: "station=Jurkovicova-2", stationName: "Jurkovicová", location: StationLocation(latitude: 48.99390722566285, longitude: 21.26738005675036)),
    
    
    
    
    StationInfo(id: "station=Obrancov_mieru-1", stationName: "Obrancov mieru", location: StationLocation(latitude: 48.99700719879617, longitude: 21.228343917009212)),
    StationInfo(id: "station=Obrancov_mieru-2", stationName: "Obrancov mieru", location: StationLocation(latitude: 48.998051509515705, longitude: 21.228114645006364)),
    
    
    StationInfo(id: "station=Duchnovicovo_namestie-1", stationName: "Duchnovičovo námestie", location: StationLocation(latitude: 48.99335677179716, longitude: 21.23263499297877)),
    StationInfo(id: "station=Duchnovicovo_namestie-2", stationName: "Duchnovičovo námestie", location: StationLocation(latitude: 48.99374923288802, longitude: 21.232571290514283)),
    
    StationInfo(id: "station=Presovska_univerzita-1", stationName: "Presovská univerzita", location: StationLocation(latitude: 48.98982268541388, longitude: 21.235612481437617)),
    StationInfo(id: "station=Presovska_univerzita-2", stationName: "Presovská univerzita", location: StationLocation(latitude: 48.99023238051137, longitude: 21.23558785887793)),
    
    StationInfo(id: "station=Skultetyho-1", stationName: "Skultétyho", location: StationLocation(latitude: 48.98666789780169, longitude: 21.241820120059074)),
    StationInfo(id: "station=Skultetyho-2", stationName: "Skultétyho", location: StationLocation(latitude: 48.986455142920725, longitude: 21.241609492641572)),
    
    
    StationInfo(id: "station=Namestie_mladeze-1", stationName: "Námestie mládeze", location: StationLocation(latitude: 48.995492205778596, longitude: 21.229556438913416)),
]

