import ceylon.build.engine { exitCodes }
import ceylon.build.task { Goal, GoalSet, Task, Context, Outcome, done }
import ceylon.test { test, assertEquals, assertTrue }

test void shouldListGoalsFromGoalSet() {
    value goals = goalsAndGoalSets();
    value writer = MockWriter();
    value result = callEngine(goals, [], writer);
    assertEquals(result.exitCode, exitCodes.noGoalToRun);
    assertEquals(names(result.availableGoals), names(goals));
    assertEquals(result.executionList, []);
    assertEquals(result.executed, []);
    assertEquals(result.failed, []);
    assertEquals(result.notRun, []);
    assertEquals(writer.errorMessages.sequence[0], "# no goal to run, available goals are: [a, c, d, e, b, f, g]");
}

test void shouldRunGoalsImportedFromGoalSet() {
    variable Boolean executed = false;
    Outcome task(Context context) {
        executed = true;
        return done;
    }
    value goals = goalsAndGoalSets(task);
    value writer = MockWriter();
    value result = callEngine(goals, ["d"], writer);
    assertEquals(result.exitCode, exitCodes.success);
    assertEquals(names(result.availableGoals), names(goals));
    assertEquals(names(result.executionList), ["d"]);
    assertEquals(names(result.executed), ["d"]);
    assertEquals(result.failed, []);
    assertEquals(result.notRun, []);
    assertTrue(executed);
    assertEquals(writer.infoMessages.sequence[1], "# running goals: [d] in order");
}

{<Goal|GoalSet>+} goalsAndGoalSets(Task task = noOp) {
    Goal goalA = Goal("a", [task]);
    Goal goalB = Goal("b", [task]);
    Goal goalC = Goal("c", [task]);
    Goal goalD = Goal("d", [task]);
    Goal goalE = Goal("e", [task]);
    Goal goalF = Goal("f", [task]);
    Goal goalG = Goal("g", [task]);
    GoalSet goalSetCDE = GoalSet({goalC, goalD, goalE});
    GoalSet goalSetFG = GoalSet({goalF, goalG});
    return [goalA, goalSetCDE, goalB, goalSetFG];
}
