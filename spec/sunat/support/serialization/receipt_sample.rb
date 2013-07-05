Receipt.new.tap do |i|
  i.correlative_number  = "10"
  
  i.ruc         = "20100113612"
  i.legal_name  = "K&G Laboratorios"
  
  # remember, it's optional
  i.make_accounting_customer_party dni: "99999999", name: "Juan Robles Madero"
  
  i.add_tax_total :igv, 874500, "PEN"
  
  i.add_line do |line|
    line.make_description "CAPTOPRIL 25mg"
    line.make_quantity 300, "CS"
    line.make_selling_price 17289000, "PEN"
    line.make_unitary_price 76800, "PEN"
    
    # Unitary price by item and code, the price that the user pays. (code 01). Required.
    line.make_paid_price(17288000, "PEN")
    
    # Referencial value in non-onerous operations, when the transfer is free. (code 02). Optional. It's the price that the object would have cost.
    line.make_referencial_unitary_price(1000, "PEN")
    
    line.add_tax_total :igv, 26361, "PEN"
    line.add_tax_total :isc, 8745, "PEN"
  end
end