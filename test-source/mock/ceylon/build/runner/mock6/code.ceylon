import ceylon.build.task { goal }

"no doc"
shared void function1() {
}

"this is a goal"
goal
shared void goal1() {
}

goal("hello")
shared void goal2() {
}

"this is a goal"
goal
shared Null goal4 = null;
