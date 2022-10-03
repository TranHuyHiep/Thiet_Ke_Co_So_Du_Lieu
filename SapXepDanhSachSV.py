from sys import stdin
from collections import namedtuple
import datetime 
sv=namedtuple('SV','id,ten,ns,gioi')
A=[]
ind=0
for t in stdin:
    if t[-1:][0]=='\n':t=t[:-1]
    na,db,sex=t.rsplit(' ',2)
    d,m,y=map(int, db.split("/"))
    db=datetime.datetime(y,m,d)
    ind+=1
    A.append(sv(ind,na,db,sex))
A.sort(key=lambda x:(x.ns,x.id))
for x in A:
    print(x.ten,"{0:d}/{1:d}/{2:d}".format(x.ns.day,x.ns.month,x.ns.year),x.gioi)