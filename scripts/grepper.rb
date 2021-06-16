ary = ["auth_amount", "auth_avs_code", "auth_avs_code_raw", "auth_code", "auth_response", "auth_time", "auth_trans_ref_no", "bill_trans_ref_no", "card_type_name", "decision", "payment_token", "payment_token_instrument_identifier_id", "payment_token_instrument_identifier_new", "payment_token_instrument_identifier_status", "reason_code", "req_access_key", "req_amount", "req_bill_to_address_city", "req_bill_to_address_country", "req_bill_to_address_line1", "req_bill_to_address_postal_code", "req_bill_to_address_state", "req_bill_to_email", "req_bill_to_forename", "req_bill_to_phone", "req_bill_to_surname", "req_card_expiry_date", "req_card_number", "req_card_type", "req_currency", "req_locale", "req_merchant_defined_data17", "req_merchant_defined_data5", "req_merchant_defined_data6", "req_merchant_defined_data7", "req_override_custom_receipt_page", "req_payment_method", "req_profile_id", "req_reference_number", "req_transaction_type", "req_transaction_uuid", "request_token", "signature", "signed_date_time", "signed_field_names", "transaction_id", "utf8"]

matches = []
Dir['app/models/**/*'].select { |f| File.file?(f) }.each { |file|
  puts file
  ary.each do |key|
    fstr = File.open(file).read
    matches << [file, key] if fstr.include?(key)
  end
}

