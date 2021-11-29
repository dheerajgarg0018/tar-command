# tar-command
This shell script replicates the behaviour of the tar command in linux operating system.

Metadata is stored in a file called “Metadata.txt”.
Please note that the tar archive should be a plain text file (without .tar) and the tar archive can be 
created only once in a directory. The existing “Metadata.txt” needs to be deleted for creating a new 
archive.
Archiving of media files is not supported.

The following options are supported:-

a) tar -cf archive.txt file1.txt file2.cpp

b) tar -cvf archive.txt file1.txt file2.cpp

c) tar -rf archive.txt file3.c

d) tar -rvf archive.txt file3.c

e) tar -tf archive.txt

f) tar -tvf archive.txt

g) tar -xf archive.txt

h) tar -xf archive.txt file1.txt file3.c

i) tar -xvf archive.txt

j) tar -xvf archive.txt file1.txt file3.c

You can also use *.c in place of file3.c to archive all .c files into the tar archive but do not use *.txt
in place of file1.txt as it will include archive.txt and Metadata.txt which may cause loss of data. 

However, *.c, *.cpp, etc. for -cf, -cvf, -rf and -rvf options are supported. 
Ex: tar -rf archive.txt *.c file1.txt
