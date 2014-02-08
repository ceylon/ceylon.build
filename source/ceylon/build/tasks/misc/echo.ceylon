import ceylon.build.task { context }

"""Returns a `Task` to that echoes the specified message on the console"""
shared void echo(String message) {
    context.writer.info(message);
}