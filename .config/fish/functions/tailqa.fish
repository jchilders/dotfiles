function tailqa
  ssh -n webuser@smsqa.inbcu.com 'tail -n 200 -f /opt/www/tomcat/sms/logs/sms.log'
end

