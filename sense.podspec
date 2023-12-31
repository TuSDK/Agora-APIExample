Pod::Spec.new do |spec|
   spec.name          = "senseLib"
   spec.version       = "1.0"
   spec.summary       = "Agora iOS video SDK"
   spec.description   = "iOS library for agora A/V communication, broadcasting and data channel service."
   spec.homepage      = "https://docs.agora.io/en/Agora%20Platform/downloads"
   spec.license       = { "type" => "Copyright", "text" => "Copyright 2018 agora.io. All rights reserved.\n"}
   spec.author        = { "Agora Lab" => "developer@agora.io" }
   spec.platform      = :ios
   spec.source        = { :git => "" }
   spec.source_files = 'SenseLib/**/*.{h,m, model}'
   spec.library = "z"
   spec.vendored_libraries = "SenseLib/**/*.a"
   spec.resource_bundles    = {"SenseLib" => "SenseLib/**/*.bundle"}
   spec.resources = "SenseLib/**/*.zip"
   spec.requires_arc  = true
   spec.ios.deployment_target  = '9.0'
 end