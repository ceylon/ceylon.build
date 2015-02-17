"""
   Wrapper package for interfacing with Ant.
   
   Implementation details:
   May not call anything directly into underlying package `sealed`, but must use `Gateway` reflection methods instead.
   Especially may not call anything of the Ant implementation.
"""
shared package ceylon.build.tasks.ant;
