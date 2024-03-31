set echo off
set lin 300
column Command format a150
set pages 500
set colsep '|'
PROMPT +---------------------------------------------------------------------------+
PROMPT |              Generating Alter Scripts to Resize                           |
PROMPT | Once generated please check the report values and execute the statements  |
PROMPT +---------------------------------------------------------------------------+

SELECT ceil( blocks*(a.BlockSize)/1024/1024) "Current Size",
   ceil( (nvl(hwm,1)*(a.BlockSize))/1024/1024 ) "Smallest Poss.",
   ceil( blocks*(a.BlockSize)/1024/1024) -
   ceil( (nvl(hwm,1)*(a.BlockSize))/1024/1024 ) "Savings",
   'alter database datafile '''|| file_name || ''' resize ' || 
      ceil((nvl(hwm,1)*(a.BlockSize))/1024/1024/100)*100  || 'm;' "Command"
FROM (SELECT a.*, p.value BlockSize FROM dba_data_files a 
JOIN v$parameter p ON p.Name='db_block_size') a
LEFT JOIN (SELECT file_id, max(block_id+blocks-1) hwm FROM dba_extents GROUP BY file_id ) b
ON a.file_id = b.file_id
WHERE ceil( blocks*(a.BlockSize)/1024/1024) - ceil( (nvl(hwm,1)*(a.BlockSize))/1024/1024 ) 
   > 200 /* Minimum MB it must shrink by to be considered. */ and rownum <20 
ORDER BY "Savings" Desc ;