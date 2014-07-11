"type of [[noop]] attribute"
shared abstract class NoOp() of noop {}

"value that should be assigned / returned by [[goal]]s
 without operation"
shared object noop extends NoOp() {}