
// Service and categories offered in Region -  North Europe
MATCH (r:Region {regionName:'North Europe'})-[o:OFFERS]->(s:Service)-[c:CATEGORY]->() RETURN r,o,c;

// Services offered in Region - Eastern US
MATCH (r:Region {regionName:'East US'})-[o:OFFERS]->(s:Service)-[p:PARENT_OF]->() RETURN r,s,o,p

// List Services by Location, Region 
MATCH (s:Service)<--(r:Region)-->(l:Location)
RETURN l.locationName as Location, collect(distinct r.regionName) as Regions, collect(distinct s.serviceName) as Services;

// List Services by Location, Region where Country is United States
MATCH (s:Service)<--(r:Region)-->(l:Location {countryName: 'United States'})
RETURN l.locationName as Location, collect(distinct r.regionName) as Regions, collect(distinct s.serviceName) as Services;

// List Services with Category available by Regions
MATCH (c:Category)<--(s:Service)<--(r:Region)
RETURN s.serviceName as Service, c.categoryName as Category,  collect(distinct r.regionName) as Regions
ORDER BY Category, Service
