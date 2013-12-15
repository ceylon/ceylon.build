package ceylon.build.tasks.commandline;

import ceylon.build.task.Writer;

class SynchronizedWriter {

    private final Writer writer;

    SynchronizedWriter(Writer writer) {
        this.writer = writer;
    }

    public synchronized void stdout(java.lang.String message) {
        writer.info(message);
    }
    
    public synchronized void stderr(java.lang.String message) {
        writer.error(message);
    }
}
