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

import Foundation

public class MyExtension: ACPExtension{
    
    public static var EVENT_HUB_BOOTED = false
    
    public static var RULES_CONSEQUENCE_EVENTS = 0
    
    override init(){
        super.init()
        try? self.api.registerWildcardListener(MyListener.self)
    }
    
    public override func name() -> String? {
        return "MyExtension"
    }
    
    public override func version() -> String? {
         return "0.1"
    }
    
    public override func onUnregister() {
        super.onUnregister()
    }
    public override func unexpectedError(_ error: Error) {
        super.unexpectedError(error)
    }
}

fileprivate class MyListener: ACPExtensionListener{
    override init(){
        super.init()
    }
    override func hear(_ event: ACPExtensionEvent) {
        if event.eventSource == "com.adobe.eventSource.booted" {
            MyExtension.EVENT_HUB_BOOTED = true
        }
        if event.eventType == "com.adobe.eventType.rulesEngine", event.eventSource == "com.adobe.eventSource.responseContent", event.eventName == "Rules Event" {
            MyExtension.RULES_CONSEQUENCE_EVENTS += 1
        }
    }
}
