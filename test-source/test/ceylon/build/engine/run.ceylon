import ceylon.test { createTestRunner }

void run() {
    value testRunner = createTestRunner([`module test.ceylon.build.engine`]);
    value result = testRunner.run();
    print(result);
}
