# Author: Javier Martínez-López 2022

# Resources:
# https://docs.openeo.cloud/getting-started/r/
# https://openeo.org/documentation/1.0/cookbook/#spatial-aggregation-aggregate-spatial

library(openeo) 

# connection

con = connect(host = "https://openeo.cloud")

#con = connect(host = "openeo-dev.vito.be")

 login() # development version from GitHub

### Annual mean NDVI

p = processes()

datacube1 = p$load_collection(
  #id = "CGLS_NDVI_V3_GLOBAL",
  id = 'CGLS_NDVI300_V1_GLOBAL',
  spatial_extent = list("west" = -3.6701819762247494, "south" = 36.807954545454564, "east" = -2.4735910671338406, "north" = 37.29),
  temporal_extent = list("2016-01-01T00:00:00Z", "2022-01-01T00:00:00Z"))

datacube2 = p$drop_dimension(data = datacube1, name = "bands")

reducer_mean = function(data, context) {
	return(p$mean(data = data))
}

reducer_sd = function(data, context) {
	return(p$sd(data = data))
}

datacube5b = p$aggregate_temporal_period(period = "year", data = datacube2, reducer = reducer_mean)
datacube6b = p$aggregate_temporal_period(period = "year", data = datacube2, reducer = reducer_sd)

datacube5 = p$aggregate_temporal(
  data = datacube5b,
  intervals = list(list("2016-01-01T00:00:00Z", "2022-01-01T00:00:00Z")),
#  labels = list(2016, 2017, 2018, 2019, 2020, 2021),
  reducer = reducer_mean)

datacube6 = p$aggregate_temporal(
  data = datacube6b,
  intervals = list(list("2016-01-01T00:00:00Z", "2022-01-01T00:00:00Z")),
#  labels = list(2016, 2017, 2018, 2019, 2020, 2021),
  reducer = reducer_mean)

overlap_resolver = function(x, y, context = NULL) {
	datacube1 = p$divide(x = x, y = y)
	return(datacube1)
}

datacube7 = p$merge_cubes(cube1 = datacube6, cube2 = datacube5, overlap_resolver = overlap_resolver)

#datacube7 = p$apply(datacube6, function(x, context) {p$divide(x, x)}) #p$divide(x = datacube6, y = datacube5)

#datacube7 = p$merge_cubes(datacube6,datacube5)

#datacube8 = p$apply(datacube6, function(x, context) {p$divide(x, x)})
  
ndvi_mean_interannual_mean = p$save_result(data = datacube5, format = "GTIFF")
ndvi_sd_interannual_mean = p$save_result(data = datacube6, format = "GTIFF")
ndvi_sd_interannual = p$save_result(data = datacube6b, format = "netCDF")
ndvi_cv_interannual = p$save_result(data = datacube7, format = "GTIFF")
#result3 = p$save_result(data = datacube7, format = "netCDF")

###

job_id = create_job(graph=ndvi_cv_interannual, title="Job_name", description="This is a test")#,format="netCDF")

start_job(job_id)

list_jobs()

# See job at: https://editor.openeo.cloud/

# or use the job id (in this example 'cZ2ND0Z5nhBFNQFq') as index to get a particular job overview
#jobs$cZ2ND0Z5nhBFNQFq

# alternatively request detailed information about the job
#describe_job(job = job)

# When the job is finished:
result_obj = list_results(job_id)

download_results(job = result_obj$assets, folder = "./result_interannual_mean")



# NDVI seasonal coefficient of variation [stdDev/Mean]



# Month of maximum NDVI



