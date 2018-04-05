//
//  JsonParser.swift
//  OutlookCalendar
//
//  Created by Roopa Natarajan on 4/4/18.
//  Copyright © 2018 Microsoft. All rights reserved.
//

import Foundation

class JsonParser {
    
    static let jsonResponse = "[ {\"eventId\":\"c03af640-1eea-4453-9b7e-c4f0c517cd7f\",\"eventTitle\":\"meeting21\",\"eventDescription\":\"My own description, Id:46\",\"eventTimeUTC\":\"2017-08-24T06:38:10\",\"eventDuration\":\"110\",\"location\":{\"locationId\":\"bebea314-1e1d-416c-af5b-bdcc6d825006\",\"buildingNumber\":\"9\",\"roomNumber\":\"24\"},\"organizer\":{\"person\":{\"personId\":\"a5f29441-ed04-41c2-bef3-ec67cfa63335\",\"firstName\":\"p25-myFirstName-18k\",\"lastName\":\"r8-MyLastName-2u\",\"alias\":\"p25-me-2u\"}},\"attendees\":[{\"attendeeId\":\"6a736278-ca25-4d37-83bb-e04af92b6800\",\"person\":{\"personId\":\"a3c9f386-97ac-49a9-9625-78913b5b1d8c\",\"firstName\":\"p11-myFirstName-6r\",\"lastName\":\"l14-MyLastName-23w\",\"alias\":\"p11-e-23w\"},\"status\":\"accepted\"},{\"attendeeId\":null,\"person\":{\"personId\":\"99862e2a-2cee-4c92-b230-43fea93155ef\",\"firstName\":\"c28-myFirstName-27u\",\"lastName\":\"a1-MyLastName-13q\",\"alias\":\"c28-e-13q\"},\"status\":\"declined\"},{\"attendeeId\":null,\"person\":{\"personId\":\"4a2819a2-e233-4ba1-a964-96c334311324\",\"firstName\":\"q1-myFirstName-27s\",\"lastName\":\"m0-MyLastName-4z\",\"alias\":\"q1-mme-4z\"},\"status\":\"accepted\"}]},{\"eventId\":\"65a04fa1-5521-48e8-87c1-61e1bb8b0c98\",\"eventTitle\":\"meeting57\",\"eventDescription\":\"My own description, Id:94\",\"eventTimeUTC\":\"2017-06-28T00:06:08\",\"eventDuration\":\"21\",\"location\":{\"locationId\":\"f466a2de-e383-4c09-9ddf-50e96b1e7cbf\",\"buildingNumber\":\"50\",\"roomNumber\":\"3\"},\"organizer\":{\"person\":{\"personId\":\"4f2ad49d-94f3-4be2-bc62-7022cfea6216\",\"firstName\":\"k2-myFirstName-14i\",\"lastName\":\"q7-MyLastName-3e\",\"alias\":\"k2-mme-3e\"}},\"attendees\":[{\"attendeeId\":\"1f806cc3-7695-484b-8556-7cfabf17fcda\",\"person\":{\"personId\":\"ad573394-8295-41ec-ba8e-6c35355730c8\",\"firstName\":\"p24-myFirstName-5t\",\"lastName\":\"c19-MyLastName-0w\",\"alias\":\"p24-me-0w\"},\"status\":\"none\"},{\"attendeeId\":null,\"person\":{\"personId\":\"c6e8e3be-04fe-45e7-a430-370fb7893145\",\"firstName\":\"x6-myFirstName-15m\",\"lastName\":\"e6-MyLastName-27y\",\"alias\":\"x6-me-27y\"},\"status\":\"none\"},{\"attendeeId\":null,\"person\":{\"personId\":\"359529ff-fd8d-458e-917b-38b260eaddf7\",\"firstName\":\"u9-myFirstName-16z\",\"lastName\":\"f6-MyLastName-11l\",\"alias\":\"u9-me-11l\"},\"status\":\"accepted\"}]} ]"
    
    static func JSONParseArray() -> [AnyObject]? {
        if let data = jsonResponse.data(using: String.Encoding.utf8, allowLossyConversion: false) {
            do {
                if let array = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers)  as? [AnyObject] {
                    return array
                }
            } catch {
                print("error")
                //handle errors here
            }
        }
        return nil
    }
}
