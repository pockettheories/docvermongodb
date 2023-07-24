# Document Versioning Pattern Demo

Provides a demo of the document versioning schema design pattern in MongoDB

For the Content Management use case, this schema design patterns enables us to store multiple revisions of a document.

## Instructions

(1) Run mongod on localhost (create a directory, and execute this within the new directory)
```
mongod --dbpath .
```

(2) Execute: 
```
docker run -it pockettheories/docvermongodb
```
...or, an alternative for (2) is 
```
git clone https://github.com/pockettheories/docvermongodb.git
cd docvermongodb
./build.sh && ./runme.sh
```
