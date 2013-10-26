import ceylon.test { createTestRunner }

void run() {
    value testRunner = createTestRunner([`module test.ceylon.build.tasks.ceylon`]);
    value result = testRunner.run();
    print(result);
}
