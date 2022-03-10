// 'cc' in this script refers to the canopy data that was sourced from http://observatoire.cmm.qc.ca/observatoire-grand-montreal/produits-cartographiques/donnees-georeferencees/
// the canopy data was loaded into GEE as an asset and then worked with from there 
// the canopy data is a raster layer and this code vectorized it so it could be used in scripts B1-B3

var landcover = cc.select('b1');

var classes = landcover.reduceToVectors({
  reducer: ee.Reducer.countEvery(), 
  scale: 30,
  maxPixels: 1e8
});
var result = ee.FeatureCollection(classes);

Map.addLayer(result);

Export.table.toDrive({
  collection: result,
  description:'canopycover',
  fileFormat: 'SHP'
});
