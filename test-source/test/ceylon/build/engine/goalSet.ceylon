import ceylon.build.engine { exitCodes }
import ceylon.build.task { Goal, GoalSet, Task, Context, Outcome, done }
import ceylon.test { test, assertEquals, assertTrue }

test void shouldListGoalsFromGoalSet() {
    value goals = goalsAndGoalSets();
    value writer = MockWriter();
    value result = callEngine(goals, [], writer);
    assertEquals(result.exitCode, exitCodes.noGoalToRun);
    assertEquals(definitionsNames(result), sort(names(goals)));
    assertEquals(execution(result), []);
    assertEquals(success(result), []);
    assertEquals(failed(result), []);
    assertEquals(notRun(result), []);
    assertEquals(writer.errorMessages.sequence[0], "# no goal to run, available goals are: [a, b, c, d, e, f, g]");
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
    assertEquals(definitionsNames(result), sort(names(goals)));
    assertEquals(execution(result), ["d"]);
    assertEquals(success(result), ["d"]);
    assertEquals(failed(result), []);
    assertEquals(notRun(result), []);
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
