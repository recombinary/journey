v0.1.8
- Fixes another bug with associations vanishing.

v0.1.7
- Actually fixed denormalization issues. Fixed a nasty bug where an associated resource 404 would cause an infinite loop of GET requests.

v0.1.6
- Attempted to fix denormalization issues (based on embedded objects and association ids) 

v0.1.5
- Fixed a bug where in `where_multiple` and `count_multiple` that performed destructive options on the argument hash (methods now use `dup`)

v0.1.4
- Fixed a bug where `batch_where` wasnt using `count_multiple` (therefore breaking for nested queries)

v0.1.3
- Added `batch_where` to account for massive queries timing out (e.g. 10k objects)

v0.0.21
- stomped out Rails load order bug by copying over entire Connection class (hacky)

v0.0.20
- fixes Rails load order bug with Connection (related to gzip patch)

v0.0.19
- forces gzip compression (gargantuan performance boost on embedded queries)

v0.0.18
- ?? missing

v0.0.17
- implements Oplog

v0.0.16
- added attachment path helpers

v0.0.15
- added compatibility around enum_sets from Journey (using indices rather than text values)

v0.0.14
- some sugar around enum_sets

v0.0.13
- Adds enum_set

v0.0.12
- Fixes some associated attribute vanishing

v0.0.11
- Adds opt-out for embeds via finder opts e.g. `Klass.all(embed: false)`

v0.0.10
- Adds Journey::Resource.count

v0.0.9
- Rescues from ActiveResource::ResourceNotFound when association_id is set but object doesn't exist
- Fixes embeds for associations with names different from their class
