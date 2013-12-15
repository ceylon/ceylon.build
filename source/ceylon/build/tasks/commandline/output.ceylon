import ceylon.build.task { Writer }
import ceylon.process { Process }
import ceylon.file { Reader }
import java.lang { Runnable, Thread }

"Redirects `process` standard output and standard error streams respectively to `writer.info` and `writer.error`.
 
 This function uses 2 threads:
 - One thread to write messages from stdout pipe
 - One thread to write messages from stderr pipe
 
 This function embed given `writer` into a thread-safe container to avoid call to `writer.info`
 to interfere with simultaneous call to `writer.error`.
 This means there's no need to provide a thread-safe `Writer`.
 
 This implementation doesn't guarantee that messages order between stderr and stdout will be preserved.
 However, it does guarantee that messages order within stderr and within stdout will be preserved."
void pipeOutputs(Process process, Writer writer) {
    value synchronisedWriter  = SynchronizedWriter(writer);
    if (is Reader output = process.output) {
        startThread(write(synchronisedWriter.stdout, output));
    }
    if (is Reader error = process.error) {
        startThread(write(synchronisedWriter.stderr, error));
    }
}

"Fills the `messagesQueue` queue with messages from `reader`"
Anything() write(Anything(String) writer, Reader reader) {
    return function() {
        while (exists line = reader.readLine()) {
            writer(line);
        }
        return null;
    };
}

void startThread(Anything() action) {
    object runnable satisfies Runnable {
        shared actual void run() {
            action();
        }
    }
    Thread(runnable).start();
}