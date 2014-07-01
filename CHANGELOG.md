v0.0.18
- forces gzip compression (gargantuan performance boost on embedded queries)

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
