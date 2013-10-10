"""Represents an element (`Goal` or `GoalGroup`) that can be referenced by its name"""
shared interface Named of Goal|GoalGroup {
    "Element's name"
    shared formal String name;
}
