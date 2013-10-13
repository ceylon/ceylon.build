import ceylon.file { ExistingResource, Nil, Path }

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
