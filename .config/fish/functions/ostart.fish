function ostart
  docker run -d -p 8080:8080 -p 1521:1521 -v /Users/jchilders/sms-oracle:/u01/app/oracle sath89/oracle-12c
end

