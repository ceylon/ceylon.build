import ceylon.file { ExistingResource, Nil, Path, Directory }

Path initializeTestFolder(String testId) {
    Path output = baseWorkingPath.childPath(testId);
    value resource = output.resource;
    "Test folder already exists"
    assert(is Nil resource);
    return resource.createDirectory().path;
}

Path dataPath(String subpath) {
    value childPath = baseDataPath.childPath(subpath);
    "Resource doesn't exist"
    assert(childPath.resource is ExistingResource);
    return childPath;
}

String shortname(Path path) {
    [String*] elements = path.elements;
    assert(nonempty elements);
    return elements.last;
}

Directory createDirectoryFromPath(Path path) {
    value resource = path.resource;
    "Resource shouldn't exist yet"
    assert(is Nil resource);
    return resource.createDirectory();
}
