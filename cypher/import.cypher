// Create indexes for faster lookup
CREATE INDEX ON :Service(serviceName);
CREATE INDEX ON :Category(categoryName);
CREATE INDEX ON :Region(regionName);
CREATE INDEX ON :Location(locationName);
CREATE INDEX ON :Location(countryName);
CREATE INDEX ON :Location(continentName);

// Create constraints
CREATE CONSTRAINT ON (s:Service) ASSERT s.serviceId IS UNIQUE;
CREATE CONSTRAINT ON (sc:Category) ASSERT sc.categoryId IS UNIQUE;
CREATE CONSTRAINT ON (r:Region) ASSERT r.regionId IS UNIQUE;
CREATE CONSTRAINT ON (l:Location) ASSERT l.locationId IS UNIQUE;

// Create services
USING PERIODIC COMMIT
LOAD CSV WITH HEADERS FROM "file:///data/services.csv" as row
CREATE (:Service {serviceName: row.Service, serviceId: row.ID});

// Create service categories
USING PERIODIC COMMIT
LOAD CSV WITH HEADERS FROM "file:///data/categories.csv" as row
CREATE (:Category {categoryName: row.Category, categoryId: row.ID});

// Create regions
USING PERIODIC COMMIT
LOAD CSV WITH HEADERS FROM "file:///data/regions.csv" as row
CREATE (:Region {regionName: row.Region, regionId: row.ID});

// Create locations
USING PERIODIC COMMIT
LOAD CSV WITH HEADERS FROM "file:///data/locations.csv" as row
CREATE (:Location {locationName: row.Location, locationId: row.ID, countryName: row.Country, continentName: row.Continent});

// Create relationships: Service to Category
USING PERIODIC COMMIT
LOAD CSV WITH HEADERS FROM "file:///data/services.csv" AS row
MATCH (service:Service {serviceId: row.ID})
MATCH (category:Category {categoryId: row.CategoryID})
MERGE (service)-[:CATEGORY]->(category);

// Create relationship for service to service (parent-child)
USING PERIODIC COMMIT
LOAD CSV WITH HEADERS FROM "file:///data/services.csv" AS row
MATCH (child:Service {serviceId: row.ID})
MATCH (parent:Service {serviceId: row.ParentID})
MERGE (parent)-[:PARENT_OF]->(child);

// Create relationships: Region to Service
USING PERIODIC COMMIT
LOAD CSV WITH HEADERS FROM "file:///data/serviceregions.csv" AS row
MATCH (service:Service {serviceId: row.ServiceID})
MATCH (region:Region {regionId: row.RegionID})
MERGE (region)-[:OFFERS]->(service);

// Create relationships: Region to Location
USING PERIODIC COMMIT
LOAD CSV WITH HEADERS FROM "file:///data/regions.csv" AS row
MATCH (region:Region {regionId: row.ID})
MATCH (location:Location {locationId: row.LocationID})
MERGE (region)-[:LOCATED_IN]->(location);