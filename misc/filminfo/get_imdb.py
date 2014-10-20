#!/usr/bin/python3

from urllib import request
import json

filename = 'The Lost World: Jurassic Park (1997).avi';
#print(filename)

filepart = filename.split("_dvd_")[0]
filepart = filepart.split(".")[0]
title = filepart.split("(")[0].lstrip().rstrip()

#title = title.replace(" ","_")
stitle = title.replace("å","-")
stitle = stitle.replace("ä","-")
stitle = stitle.replace("ö","-")
#print (filepart.split("("))
if len(filepart.split("(")) > 1:
    year = filepart.split("(")[1].split(")")[0].lstrip().rstrip()
    print (title)
    print (year)
    url = "http://mymovieapi.com/?"+"title="+stitle+"&year="+year+"&type=json&plot=full"
else:
    url = "http://mymovieapi.com/?"+"title="+stitle+"&type=json&plot=full"
    print (title)

#print (url)
print()

print(url)
#try:
response = request.urlopen(url)
print (response)
#except:
    #response=""

content = response.read().decode("utf8")
print(content)

if content.find(":404,") == -1: # No content found
    data = json.loads(content)
    info = data.pop();

    title = info.get("title")
    try:
        genre = info.get("genres")[0]
    except:
        genre = "unknown"
    try:
        runtime = info.get("runtime")[0].split(" ")[0]
    except:
        runtime = "unknown"
    year = info.get("year")
    try:
        language = info.get("language")[0]
    except:
        language = "unknown"
    imdb_url = info.get("imdb_url")

    ostr = "{}, {}, {}, {}, {}, {}, {}\n".format(
        title,genre,runtime,year,language,imdb_url,filename)

    f = open("film_info.csv","w") # opens file
    
    f.write(ostr)
    f.close()

else:
    print(content)

