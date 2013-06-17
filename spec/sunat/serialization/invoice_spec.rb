require 'spec_helper'

# for more succint calls
include SUNAT

describe 'serialization of an invoice' do

  # 1. Create a "real world" document
  # 2. Before continuing with the test, look for the places where we can extract methods
  # 3. Extract methods
  #   3.1. Tests for the extracted methods
  #   3.2. Create extract methods
  # 4. Test if the serialization contains some of the attributes (not all)
  
  before :all do
    @invoice = Invoice.build do |i|
      i.id                      = "F002-10"
      i.invoice_type_code       = "01"
      i.document_currency_code  = "PEN"
      
      i.build_accounting_supplier_party do |asp|
        asp.account_id = "20100113612"
        asp.additional_account_id = "6"
        asp.build_party_with_name "K&G Laboratorios"
      end
      
      i.build_accounting_customer_party do |acp|
        acp.account_id = "20382170114"
        acp.additional_account_id = "6"
        acp.build_party_with_legal_name "CECI FARMA IMPORT S.R.L."
      end
      
      i.invoice_lines << InvoiceLine.build do |il|
        il.id = "1"
                
        il.build_invoiced_quantity do |q|
          q.quantity = 300
          q.unit_code = "CS"
        end
        
        il.build_line_extension_amount do |amount|
          amount.value = 172890
          amount.currency = "PEN"
        end
        
        il.build_price do |p|
          p.build_price_amount do |amount|
            amount.value = 678
            amount.currency = "PEN"
          end
        end
        
        il.build_pricing_reference do |ref|
          ref.build_alternative_condition_price do |acp|
            acp.price_type = "01"
            acp.build_price_amount do |amount|
              amount.value = 20
              amount.currency = "PEN"
            end
          end
        end
        
        il.tax_totals << TaxTotal.build do |tt|
          tt.build_tax_amount do |amount|
            amount.value = 26361
            amount.currency = "PEN"
          end
          
          tt.sub_totals << TaxSubTotal.build do |st|
            st.build_tax_amount do |amount|
              amount.value = 26361
              amount.currency = "PEN"
            end

            st.build_tax_category do |cat|
              cat.tax_exemption_reason_code = "10"
              cat.build_tax_scheme do |scheme|
                scheme.id = "100"
                scheme.name = "IGV"
                scheme.tax_type_code = "VAT"
              end
            end
          end
        end
        
        il.tax_totals << TaxTotal.build do |tt|
          
          tt.build_tax_amount do |amount|
            amount.value = 8745
            amount.currency = "PEN"
          end
          
          tt.sub_totals << TaxSubTotal.build do |st|
            st.build_tax_amount do |amount|
              amount.value = 8745
              amount.currency = "PEN"
            end

            st.build_tax_category do |cat|
              cat.tier_range = "02"
              cat.build_tax_scheme do |scheme|
                scheme.id = "2000"
                scheme.name = "ISC"
                scheme.tax_type_code = "EXC"
              end
            end
          end
        end
      end
    end
  end
  
  it "should do nothing" do
    # puts JSON.pretty_generate(@invoice.as_json)
  end

end