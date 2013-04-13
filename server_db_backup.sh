echo -e "\n|=============================`date +"%m-%d-%y  %r"`=============================|\n\n"

for database in `cat ~/mongo-backup-util/config/databases.txt`; do
  host=`cat ~/mongo-backup-util/config/host.txt`
  key=`cat ~/mongo-backup-util/config/key.txt`
  out_dir=`cat ~/mongo-backup-util/config/output-dir.txt`
  if [ ! -d ${out_dir} ]
    then
      mkdir ${out_dir}
      mkdir ${out_dir}/${database}
  elif [ ! -d ${out_dir}/${database} ]
    then
      mkdir ${out_dir}/${database}
  fi
  ssh -i ${key} ${host} mongodump --db ${database}
  ssh -i ${key} ${host} tar -C dump/${database} -c ./ > ${out_dir}/${database}/`date +"%m-%d-%y:%H"`.tar
  if [ -f ${out_dir}/${database}/`date +"%m-%d-%y:%H.tar"` ]
    then
      echo -e "\n[`date`](SUCCESS): ${database} has been transferred"
      echo -e "[`date`](SUCCESS): created ${out_dir}/${database}/`date +"%m-%d-%y:%H"`.tar\n"

    else
      echo -e "\n[`date`](FAILURE): ${database} failed to transfer \n"
  fi
done

