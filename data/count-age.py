from pyspark import SparkConf, SparkContext
import collections

def parse_lines(line):
    fields = line.split(',')
    age = int(fields[2])
    num_of_friends = int(fields[3])
    return (age, num_of_friends)

conf = SparkConf().setMaster("local").setAppName("RatingsHistogram")
sc = SparkContext(conf = conf)

lines = sc.textFile("./material/fakefriends.csv")
rdd = lines.map(parse_lines)
print(rdd)

# (33, 385)
# (33, 250)
# (34, 178)
totalsByAge = rdd.mapValues(lambda x: (x, 1)).reduceByKey(lambda x, y: (x[0] + y[0], x[1] + y[1]))
# (33, (385,1))
# (33, (250,1))
# (34, (178,1))

results = totalsByAge.collect()
for result in results:
    print result

# result    
# (59, (1980, 9))
# (60, (1419, 7))
# (61, (2306, 9))
# (62, (2870, 13))
# (63, (1536, 4))
# (64, (3376, 12))
# (65, (1491, 5))
# (66, (2488, 9))
# (67, (3434, 16))
# (68, (2696, 10))
# (69, (2352, 10))

averagesByAge = totalsByAge.mapValues(lambda x: x[0] / x[1])
results = averagesByAge.collect()
for result in results:
    print result

# result        
# (51, 302)
# (52, 340)
