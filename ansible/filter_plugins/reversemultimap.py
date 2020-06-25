# Sort of reverse multimaps a list of objects to another list of objects using a key and a list field in each object
# Example:
# {"my_key":"a key", "my_list":["hello", "array"]},
# {"my_key":"another key", "my_list":["oops", "wow"]}
# called with:
# Objects | mapwithkey('my_key', 'my_list', 'mapped_field')
# Will result in the following list:
# {"my_key": "a key", "mapped_field": "hello"}
# {"my_key": "a key", "mapped_field": "array"}
# {"my_key": "another key", "mapped_field": "oops"}
# {"my_key": "another key", "mapped_field": "wow"}
class FilterModule(object):
    def filters(self):
        return { 'reversemultimap': self.reversemultimap }

    def reversemultimap(self, objects, key, list, mapped_field_name):
        new_list = []
        for object in objects:
            for item in object[list]:
                mapped_obj = { }
                mapped_obj[key] = object[key]
                mapped_obj[mapped_field_name] = item
                new_list.append(mapped_obj)
        return new_list