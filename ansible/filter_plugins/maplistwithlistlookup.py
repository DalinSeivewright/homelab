from ansible.errors import AnsibleFilterError

class FilterModule(object):
    def filters(self):
        return { 'maplistwithlistlookup': self.maplistwithlistlookup }

    def maplistwithlistlookup(self, sourceObjectList, sourceKey, targetObjectList, targetKey):
        new_list = []
        for objects in sourceObjectList:
            sourceKeyValue = objects[sourceKey]
            added = False
            for item in targetObjectList:
                if sourceKeyValue == item[targetKey]:
                    new_list.append(item)
                    added = True
            if not added:
                print(sourceKeyValue)
                raise AnsibleFilterError('Source value ' + targetKey + ' does not exist in target object list.')

        print(new_list)
        return new_list