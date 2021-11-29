#!/bin/bash

read str

# Setting IFS (input field separator) value as " "
IFS=' '

# Reading the split string into array
read -ra arr <<< "$str"

ArrSize=${#arr[@]}

if [[ (("${arr[0]}" != "tar")) ]]; then
echo "Invalid input"
exit 
fi

if [[ (($ArrSize < 3)) ]]; then
echo "Give tar archive file name"
exit
fi

if [[ ${arr[1]} == "-cf" || ${arr[1]} == "-rf" ]]; then
   if [[ (($ArrSize < 4)) ]]; then
       echo "Invalid input: Give file name(s) to be archived"
       exit 
   else
       if [ -e "${arr[2]}" ]; then
          l1=`cat ${arr[2]} | wc -l`
          l=$((l1+1))
       else
          l=1
       fi
       
       for ((i=3; i<$ArrSize; i++)) 
       do 
          if [[ ${arr[i]:0:2} == "*." ]]; then
              IFS=$'\n'
              
              s=$(ls ${arr[i]})
              read -rd '' -a file <<<"$s"
              
              for val in "${file[@]}";
	      do
                   #printf "name = $val\n"
                   cat $val >> ${arr[2]}
                   l1=`cat ${arr[2]} | wc -l`
                   printf "$val\n$l $l1\n" >> Metadata.txt
                   ls -l | grep "$val" >> Metadata.txt
                   l=$((l1+1))
              done
              
              continue;
          fi
          
          cat ${arr[i]} >> ${arr[2]}
          if [ -e ${arr[i]} ]; then
          	l1=`cat ${arr[2]} | wc -l`
          	printf "${arr[i]}\n$l $l1\n" >> Metadata.txt
          	ls -l | grep "${arr[i]}" >> Metadata.txt
          	l=$((l1+1))
          fi
          
       done
   fi
else
   if [[ ${arr[1]} == "-cvf" || ${arr[1]} == "-rvf" ]]; then
      if [[ (($ArrSize < 4)) ]]; then
         echo "Invalid input: Give file name(s) to be archived"
         exit 
      else
         if [ -e "${arr[2]}" ]; then
            l1=`cat ${arr[2]} | wc -l`
            l=$((l1+1))
         else
            l=1
         fi
         
         for ((i=3; i<$ArrSize; i++)) 
         do 
            if [[ ${arr[i]:0:2} == "*." ]]; then
              IFS=$'\n'
              
              s=$(ls ${arr[i]})
              read -rd '' -a file <<<"$s"
              
              for val in "${file[@]}";
	      do
                   #printf "name = $val\n"
                   cat $val >> ${arr[2]}
                   printf "$val\n"
                   l1=`cat ${arr[2]} | wc -l`
                   printf "$val\n$l $l1\n" >> Metadata.txt
                   ls -l | grep "$val" >> Metadata.txt
                   l=$((l1+1))
              done
              
              continue;
            fi
            
            cat ${arr[i]} >> ${arr[2]}
            if [ -e ${arr[i]} ]; then
            	printf "${arr[i]}\n"
            	l1=`cat ${arr[2]} | wc -l`
            	printf "${arr[i]}\n$l $l1\n" >> Metadata.txt
            	ls -l | grep "${arr[i]}" >> Metadata.txt
            	l=$((l1+1))
            fi
            
         done
      fi
   else
       if [[ ${arr[1]} == "-tf" ]]; then
               if [ -e "${arr[2]}" ]; then
                  if [ -e "Metadata.txt" ]; then
                  	k=`cat Metadata.txt | wc -l`
                  	for ((i=1; i<$k; i+=3))
                  	do
                      	   sed -n "$i"p Metadata.txt
                  	done
                  fi
               else
                  echo "${arr[2]}: No such Tar archive"
                  exit
               fi
       else
           if [[ ${arr[1]} == "-tvf" ]]; then
               if [ -e "${arr[2]}" ]; then
                  if [ -e "Metadata.txt" ]; then
                  	k=`cat Metadata.txt | wc -l`
                  	for ((i=3; i<=$k; i+=3))
                  	do
                          sed -n "$i"p Metadata.txt
                  	done
                  fi
               else
                  echo "${arr[2]}: No such Tar archive"
                  exit
               fi
           else
                   if [[ ${arr[1]} == "-xf" ]]; then
                       if [[ (($ArrSize < 3)) ]]; then
                           echo "Invalid input: Give tar file name"
                           exit
                       else
                           if [ -e "${arr[2]}" ]; then
                              if [ ! -e "Metadata.txt" ]; then
                              	echo "Tar archive is empty"
                              	exit
                              fi
                              
                              if [[ (($ArrSize == 3)) ]]; then
                                  k=`cat Metadata.txt | wc -l`
                                  IFS=' '
				   for ((i=1; i<$k; i+=3))
				   do
				      f=$(sed -n "$i"p Metadata.txt)
				      j=$((i+1))
				      n=$(sed -n "$j"p Metadata.txt)
				      read -ra arr2 <<< "$n"
				      
				      f=${f//$'\n'}
				      sed -n "${arr2[0]}, ${arr2[1]}"p ${arr[2]} > $f
				   done
                              else
                                  k=`cat Metadata.txt | wc -l`
                                  for ((a=3; a<$ArrSize; a++))
                                  do
				      i=1
				      IFS=' '
				      for ((; i<$k; i+=3))
				      do
				          f=$(sed -n "$i"p Metadata.txt)
				          f=${f//$'\n'}
				          if [[ ${arr[a]} == $f ]]; then
				               j=$((i+1))
				               n=$(sed -n "$j"p Metadata.txt)
				      	       read -ra arr2 <<< "$n"
				      
				               sed -n "${arr2[0]}, ${arr2[1]}"p ${arr[2]} > $f
				               
				               break;
				          fi
				      done
				      
				      if [[ $i -ge $k ]]; then
				           printf "${arr[a]} is not present in the tar archive\n"
				      fi
				  done
			      fi
                           else
                               echo "${arr[2]}: No such Tar archive"
                               exit
                           fi
                       fi
                   else
                       if [[ ${arr[1]} == "-xvf" ]]; then
                            if [[ (($ArrSize < 3)) ]]; then
                                 echo "Invalid input: Give tar file name"
                                 exit
                            else
                                if [ -e "${arr[2]}" ]; then
                                    if [ ! -e "Metadata.txt" ]; then
                              	    echo "Tar archive is empty"
                              	    exit
                                    fi
                                    
                                    if [[ (($ArrSize == 3)) ]]; then
                                         k=`cat Metadata.txt | wc -l`
                                         IFS=' '
				          for ((i=1; i<$k; i+=3))
				          do
				              f=$(sed -n "$i"p Metadata.txt)
				              j=$((i+1))
				              n=$(sed -n "$j"p Metadata.txt)
				              read -ra arr2 <<< "$n"
				      
				              f=${f//$'\n'}
				              printf "$f\n"
				              sed -n "${arr2[0]}, ${arr2[1]}"p ${arr[2]} > $f
				          done
                                    else
                                         k=`cat Metadata.txt | wc -l`
				          IFS=' '
                                         for ((a=3; a<$ArrSize; a++))
                                         do
				              i=1
				              for ((; i<$k; i+=3))
				              do
				                  f=$(sed -n "$i"p Metadata.txt)
				                  f=${f//$'\n'}
				                  if [[ ${arr[a]} == $f ]]; then
				                       j=$((i+1))
				                       n=$(sed -n "$j"p Metadata.txt)
				      	               read -ra arr2 <<< "$n"
				      
				                       sed -n "${arr2[0]}, ${arr2[1]}"p ${arr[2]} > $f
				                       printf "$f\n"
				                       
				                       break;
				                  fi
				              done
				              
				              if [[ $i -ge $k ]]; then
				                   printf "${arr[a]} is not present in the tar archive\n"
				              fi
				         done
			            fi
                                else
                                    echo "${arr[2]}: No such Tar archive"
                                    exit
                                fi
                            
                            fi
                       else
                           echo "Command not found"
                           exit
                       fi
                   fi
           fi
       fi
   fi
fi

exit
