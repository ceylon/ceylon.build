import ceylon.build.task { Task, Context, done }

"""Returns a `Task` to that echoes the specified message on the console"""
shared Task echo(String message) {
    return function(Context context) {
        context.writer.info(message);
        return done;
    };
}