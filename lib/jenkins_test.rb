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

    def ut
      `set -o pipefail && env NSUnbufferedIO=YES`
      `xcodebuild -workspace zouzous-tvos.xcworkspace \
        -scheme zouzous-tvos \
        -configuration Debug \
        -destination 'platform=tvOS Simulator,name=Apple TV 4K' \
        -derivedDataPath './Build/Test_output/' \
        -enableCodeCoverage YES clean build test`
      
      `xsltproc -o ./Build/Test_output/report.junit ./scripts/plist_to_junit.xsl ./Build/Test_output/Logs/Test/*.xcresult/TestSummaries.plist`
      
    end

    def cocoapods
      `rvm 2.3.3 do bundle exec pod update`
      `rvm 2.3.3 do bundle exec pod install`
    end


  end

end
