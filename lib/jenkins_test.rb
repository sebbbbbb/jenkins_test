require "jenkins_test/version"

module JenkinsTest

  class Console
  
    def lint
      `mkdir ./Build/Swiftlint_output`
      `swiftlint lint --reporter checkstyle > ./Build/Swiftlint_output/report.xml || true`
    end

    def build 
      `set -o pipefail && env NSUnbufferedIO=YES`
      `xcodebuild -workspace zouzous-tvos.xcworkspace -scheme zouzous-tvos -configuration Release archive -archivePath $PWD/build/zouzous-tvos.xcarchive` 
    end

    def clean
      `rm -rf ./Build/*`
      `rm -rf ~/Library/Developer/Xcode/DerivedData/zouzous-tvos*`
    end
  end

end
