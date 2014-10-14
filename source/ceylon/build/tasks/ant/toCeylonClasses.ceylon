import ceylon.collection {
    HashMap,
    ArrayList
}

import java.lang {
    JBoolean = Boolean,
    JString=String
}
import java.util {
    JMap=Map,
    JList=List
}

Boolean toBoolean(Anything jBoolean) {
    switch (jBoolean)
    case (is JBoolean) {
        return jBoolean == JBoolean.\iTRUE;
    }
    else {
        throw Exception("Boolean expected.");
    }
}

String toString(Anything jString) {
    switch (jString)
    case (is JString) {
        return jString.string;
    }
    else {
        throw Exception("Java String expected.");
    }
}

String? toStringOrNull(Anything jString) {
    switch (jString)
    case (is Null) {
        return null;
    }
    case (is JString) {
        return jString.string;
    }
    else {
        throw Exception("Java String expected.");
    }
}

List<Object> toObjectList(Anything jList) {
    switch (jList)
    case (is JList<out Object>) {
        ArrayList<Object> arrayList = ArrayList<Object>();
        value jIterator = jList.iterator();
        while (jIterator.hasNext()){
            Object item = jIterator.next();
            arrayList.add(item);
        }
        return arrayList;
    }
    else {
        throw Exception("Java List filled with Java Strings expected.");
    }
}

List<String> toStringList(Anything jList) {
    switch (jList)
    case (is JList<out JString>) {
        ArrayList<String> arrayList = ArrayList<String>();
        value jIterator = jList.iterator();
        while (jIterator.hasNext()){
            JString jString = jIterator.next();
            arrayList.add(jString.string);
        }
        return arrayList;
    }
    else {
        throw Exception("Java List filled with Java Strings expected.");
    }
}

Map<String,String> toStringMap(Anything jMap) {
    switch (jMap)
    case (is JMap<out Anything,out Anything>) {
        HashMap<String,String> hashMap = HashMap<String,String>();
        value jEntries = jMap.entrySet();
        value jIterator = jEntries.iterator();
        while (jIterator.hasNext()){
            value jEntry = jIterator.next();
            String key = toString(jEntry.key);
            String item = toString(jEntry.\ivalue);
            hashMap.put(key.string, item.string);
        }
        return hashMap;
    }
    else {
        throw Exception("Java Map filled with Java Strings expected.");
    }
}

