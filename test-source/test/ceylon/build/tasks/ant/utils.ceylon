import ceylon.build.tasks.ant {
    AntDefinition
}
import ceylon.file {
    Nil,
    Path,
    Directory,
    parsePath,
    File
}
import ceylon.language.meta.model {
    Interface
}

File|Directory|Nil retrieveActualResource(String effectiveBaseDirectory, String relativeResourceName) {
    Path exampleFilePath = parsePath(effectiveBaseDirectory + "/" + relativeResourceName);
    File|Directory|Nil actualResource = exampleFilePath.resource.linkedResource;
    return actualResource;
}

void verifyResource(String effectiveBaseDirectory, String relativeResourceName, Interface<File|Directory|Nil> expectedResourceType, String failMessage) {
    File|Directory|Nil actualResource = retrieveActualResource(effectiveBaseDirectory, relativeResourceName);
    if(expectedResourceType.typeOf(actualResource)) {
        //print("``relativeResourceName`` is ``expectedResourceType``");
    } else {
        throw Exception("``failMessage``: ``relativeResourceName`` is not ``expectedResourceType``");
    }
}

AntDefinition? filterAntDefinition({AntDefinition*} antDefinitions, String antName) {
    {AntDefinition*} filteredAntDefinitions = antDefinitions.filter { (AntDefinition antDefintion) => (antDefintion.antName == antName); };
    switch (filteredAntDefinitions.size)
    case (0) {
        return null;
    }
    case (1) {
        return filteredAntDefinitions.first;
    }
    else {
        throw Exception("More than one Ant type/task found for ``antName``");
    }
}

void printAntDefinitions({AntDefinition*} antDefinitions) {
    AntDefinition[] sortedAntDefinitions = antDefinitions.sort((AntDefinition x, AntDefinition y) => x <=> y);
    for(antDefinition in sortedAntDefinitions) {
        value antName = antDefinition.antName.padTrailing(22);
        value wrapped = antDefinition.implementationWrapped then "WRAP" else "    ";
        value className = antDefinition.effectiveElementTypeClassName;
        print("``antName`` ``wrapped`` ``className``");
    }
}

void printAdditionalAntDefinitions({AntDefinition*} antDefinitions1, {AntDefinition*} antDefinitions2) {
    {AntDefinition*} filteredAntDefinitions = antDefinitions2.filter(
        (AntDefinition element) => !antDefinitions1.contains(element)
    );
    printAntDefinitions(filteredAntDefinitions);
}
