// load dependencies
#import "ext/jasmine-uiautomation.js"
#import "ext/jasmine-reporters/ext/jasmine.js"
#import "reporter/jasmine.uiautomation_junit_reporter.js"
#import "ext/jasmine-main-thread.js"

// load test specs
#import "specs/calculator-test.js"

jasmine.getEnv().addReporter(new jasmine.JUnitXmlReporter());
jasmine.getEnv().execute();