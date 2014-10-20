#!/usr/bin/python3

import os, re
#from urllib import request
import requests
import json

#-----Find movie files------
top_dir = "/home/per/storage/media/Videos/mythtv"

subdirs = [x[0] for x in os.walk(top_dir)]

allfiles = []
n = len(subdirs)
for i in range(n):
    dir = subdirs[i]
    files = [f for f in os.listdir(dir) if re.search('\.mkv$|\.mp4$|\.avi|\.mpg$', f)]
    allfiles += files
    
allfiles = [x.lower() for x in allfiles]
allfiles.sort()

#----Get info from imdb------

oarr = []

for filename in allfiles:

    #filename = "Sommaren med Göran_dvd_130729-0150.mpg";
    print(filename)

    i = filename.rindex(".")
    filepart = filename[0:i]
    filepart = filepart.split("_dvd_")[0]
    title = filepart.split("(")[0].lstrip().rstrip()

    #stitle = title.replace("."," ")
    #stitle = stitle.replace("_"," ")
    #stitle = stitle.replace("-"," ")
    #stitle = stitle.replace(":"," ")
    #stitle = re.sub('[^a-zA-Z0-9\+\s\']',"-",title)
    modtitle = title.replace(" ","+")
    modtitle = modtitle.replace("-",":")
    #print (modtitle)
    if len(filepart.split("(")) > 1:
        year = filepart.split("(")[1].split(")")[0].lstrip().rstrip()
#        print (year)
        url = "http://www.omdbapi.com/?t="+modtitle+"&y="+year
    else:
        url = "http://www.omdbapi.com/?t="+modtitle
        year = "N/A"
        
    print (url)    

    status = 1
    try:
        response = requests.get(url, timeout=1)
    except:
        status = 0

    if status:
        data = json.loads(response.text)
        if data.get('Response') == 'True':
            title = data.get("Title")
            year = data.get("Year")
            genres = data.get("Genre")
            actors = data.get("Actors")
            runtime = data.get("Runtime")
            imdb_url = "http://www.imdb.com/title/"+data.get("imdbID")+"/"
            print(title,year)
            print(genres)
            print(actors)
            print(imdb_url)
            imdb_url = '<A HREF="'+imdb_url+'">imdb</A>'
        else:
            status = 0
            
    if status == 0:
        print('Title not found')
        title = re.sub('^.',title.upper()[0],title)
        genres = "N/A"
        actors = "N/A"
        runtime = "N/A"
        imdb_url = "N/A"

    ostr = "{}, {}, {}, {}, {}, {}, {}\n".format(
            title,imdb_url,genres,runtime,year,actors,filename)
    oarr.append(ostr)
    print()

oarr.sort()

f = open("film_info_omdb.csv","w") # opens file
f.writelines(oarr)
f.close()

#---Write to html file---
f = open("film_info_omdb.html","w") # opens file

f.write('<html>\n')
f.write('<head>\n')
f.write('<meta http-equiv="Content-Type" content="text/html; charset=utf-8">\n')
f.write('<title>Film info</title>\n')
f.write('</head> \n')
f.write('<body>\n')
#f.write('<p><div align="center">List of the movie archive</div></p>\n')
f.write('<h1 align=center>Mythtv arkiv</h1>')

for line in oarr:
    f.write('<p>\n')
    f.write(line)
    f.write('</p>\n')

#f.writelines(oarr)

#f.write('\n')
f.write('</body>\n')
f.write('</html>\n')

f.close()
