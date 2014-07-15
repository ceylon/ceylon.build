import ceylon.file { Nil, Path, Directory, parsePath, File }
import ceylon.build.tasks.ant { activeAntProject, AntProject, AntDefinition }
import ceylon.language.meta.model { Interface }
import ceylon.test { test, assertTrue }

File|Directory|Nil retrieveActualResource(String relativeResourceName) {
    AntProject antProject = activeAntProject();
    String effectiveBaseDirectory = antProject.effectiveBaseDirectory();
    Path exampleFilePath = parsePath(effectiveBaseDirectory + "/" + relativeResourceName);
    File|Directory|Nil actualResource = exampleFilePath.resource.linkedResource;
    return actualResource;
}

void verifyResource(String relativeResourceName, Interface<File|Directory|Nil> expectedResourceType, String failMessage) {
    File|Directory|Nil actualResource = retrieveActualResource(relativeResourceName);
    if(expectedResourceType.typeOf(actualResource)) {
        print("``relativeResourceName`` is ``expectedResourceType``");
    } else {
        throw Exception("``failMessage``: ``relativeResourceName`` is not ``expectedResourceType``");
    }
}

AntDefinition? filterAntDefinition({AntDefinition*} antDefinitions, String antName) {
    {AntDefinition*} filteredAntDefinitions = antDefinitions.filter { function selecting(AntDefinition antDefintion) => (antDefintion.antName == antName); };
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

void printAntDefinitions({AntDefinition*}? antDefinitions = null) {
    {AntDefinition*} printedAntDefinitions;
    if (exists antDefinitions) {
        printedAntDefinitions = antDefinitions;
    } else {
        AntProject antProject = activeAntProject();
        printedAntDefinitions = antProject.allTopLevelAntDefinitions();
    }
    for(antDefinition in printedAntDefinitions) {
        value antName = antDefinition.antName.padTrailing(22);
        value wrapped = antDefinition.implementationWrapped then "#" else " ";
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
