"""
   Gateway package between Ceylon and sealed package.
   May not call anything directly into sealed package, but must use [[Gateway]] reflection methods instead.
   Especially may not call anything of the Ant implementation.
"""
package ceylon.build.tasks.ant.internal;
