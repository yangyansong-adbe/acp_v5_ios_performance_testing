/*
 Copyright 2020 Adobe. All rights reserved.
 This file is licensed to you under the Apache License, Version 2.0 (the "License");
 you may not use this file except in compliance with the License. You may obtain a copy
 of the License at http://www.apache.org/licenses/LICENSE-2.0
 Unless required by applicable law or agreed to in writing, software distributed under
 the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR REPRESENTATIONS
 OF ANY KIND, either express or implied. See the License for the specific language
 governing permissions and limitations under the License.
 */

import SwiftUI

struct ContentView: View {
    @State var status = "..."
    var body: some View {
        HStack {
            Text(status)
        }
        VStack {
            Button(action: {
                MyExtension.EVENT_HUB_BOOTED = false
                MyExtension.RULES_CONSEQUENCE_EVENTS = 0
                self.status = "...."
                
                ACPCore.setLogLevel(ACPMobileLogLevel.error)
                do {
                    ACPLifecycle.registerExtension()
                    ACPIdentity.registerExtension()
                    ACPSignal.registerExtension()
                    
                    try ACPCore.registerExtension(MyExtension.self)
                    ACPCore.configure(withAppId: "94f571f308d5/fec7505defe0/launch-eaa54c95a6b5-development")
                    ACPCore.start{
                        ACPCore.lifecycleStart(nil)
                    }
                    for _ in 0...10000{
                        if MyExtension.EVENT_HUB_BOOTED {
                            self.status = "Eventhub Booted"
                            break
                        }else{
                            usleep(100)
                        }
                    }
                } catch let error as NSError {
                    print("\(error.domain) .... \(error.code)")
                }
                

            }) {
                Text("Load AEP SDK")
                    .frame(minWidth: 0, maxWidth: .infinity)
                    .padding()
                    .background(Color.gray)
                    .foregroundColor(.white)
                    .font(.caption)
            }.cornerRadius(5)
            Button(action: {
                MyExtension.EVENT_HUB_BOOTED = false
                MyExtension.RULES_CONSEQUENCE_EVENTS = 0
                self.status = "...."
                do{
                    for _ in 0...999{
                        let event = try ACPExtensionEvent(name: "ddd", type: "com.adobe.eventType.generic.track", source: "com.adobe.eventSource.requestContent", data:  ["action" : "action"])
                         try ACPCore.dispatchEvent(event)
                    }
                    for _ in 0...500000{
                        if MyExtension.RULES_CONSEQUENCE_EVENTS >= 10000 {
                            self.status = "10000 Rules were Evaluated"
                            break
                        }else{
                            usleep(100)
                        }
                    }
                }catch let error as NSError {
                    print("\(error.domain) .... \(error.code)")
                }
               
            }) {
                Text("Evaluate Rules")
                    .frame(minWidth: 0, maxWidth: .infinity)
                    .padding()
                    .background(Color.gray)
                    .foregroundColor(.white)
                    .font(.caption)
            }.cornerRadius(5)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
