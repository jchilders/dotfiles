function mgimportprod --description "Agency Gateway: Run Mongo migration scripts, dump data, & import to MySQL"

  echo "Dropping ag_prod database"
  mongo ag_prod --eval 'db.dropDatabase()'

  cd /Users/jchilders/workspace/agency_gateway/mongodumps/prod/20180809/RITM1383015_ag_api_be_pcf_09Aug2018
  printf "Importing prod dump from %s" (pwd)
  mongorestore --db=ag_prod ag_api_be_pcf/

  printf "Executing migration scripts"
  cd /Users/jchilders/workspace/agency_gateway/agency_gateway_api
  cd lib/mongo
  mongo ag_prod add_advertiser_ids.js update_deals_wo_demo_pa_name.js property_data_update.js denormalize_sms_deals.js denormalize_agencies.js denormalize_property.js

  cd /Users/jchilders/workspace/agency_gateway/agency_gateway_api
  mongodump --db=ag_prod 
  mv dump/ag_prod/* dump/
  rm -r dump/ag_prod
  rake db:drop db:create db:migrate db:import:all
end

