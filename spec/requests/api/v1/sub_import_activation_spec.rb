require 'rails_helper'

RSpec.describe "Api::V1::Fastsprings", type: :request do
  describe 'POST for subscription.activated' do
    before(:each) do
      sub_id = Faker::Alphanumeric.alpha(number: 22)

      @body = {
        "events": [
          {
            "id": Faker::Alphanumeric.alpha(number: 22),
            "processed": true,
            "created": DateTime.now.strftime('%Q'),
            "type": "subscription.activated",
            "live": false,
            "data": {
              "id": sub_id,
              "subscription": sub_id,
              "active": true,
              "state": "active",
              "changed": 1603729736974,
              "changedValue": 1603729736974,
              "changedInSeconds": 1603729736,
              "changedDisplay": "10/26/20",
              "live": false,
              "currency": "USD",
              "account": Faker::Alphanumeric.alpha(number: 22),
              "product": "bronze",
              "sku": nil,
              "display": "Bronze",
              "quantity": 1,
              "adhoc": false,
              "autoRenew": true,
              "price": 9.99,
              "priceDisplay": "$9.99",
              "priceInPayoutCurrency": 9.99,
              "priceInPayoutCurrencyDisplay": "$9.99",
              "discount": 0.0,
              "discountDisplay": "$0.00",
              "discountInPayoutCurrency": 0.0,
              "discountInPayoutCurrencyDisplay": "$0.00",
              "subtotal": 9.99,
              "subtotalDisplay": "$9.99",
              "subtotalInPayoutCurrency": 9.99,
              "subtotalInPayoutCurrencyDisplay": "$9.99",
              "next": 1606348800000,
              "nextValue": 1606348800000,
              "nextInSeconds": 1606348800,
              "nextDisplay": "11/26/20",
              "end": nil,
              "endValue": nil,
              "endInSeconds": nil,
              "endDisplay": nil,
              "canceledDate": nil,
              "canceledDateValue": nil,
              "canceledDateInSeconds": nil,
              "canceledDateDisplay": nil,
              "deactivationDate": nil,
              "deactivationDateValue": nil,
              "deactivationDateInSeconds": nil,
              "deactivationDateDisplay": nil,
              "sequence": 1,
              "periods": nil,
              "remainingPeriods": nil,
              "begin": 1603670400000,
              "beginValue": 1603670400000,
              "beginInSeconds": 1603670400,
              "beginDisplay": "10/26/20",
              "intervalUnit": "month",
              "intervalLength": 1,
              "nextChargeCurrency": "USD",
              "nextChargeDate": 1606348800000,
              "nextChargeDateValue": 1606348800000,
              "nextChargeDateInSeconds": 1606348800,
              "nextChargeDateDisplay": "11/26/20",
              "nextChargePreTax": 9.99,
              "nextChargePreTaxDisplay": "$9.99",
              "nextChargePreTaxInPayoutCurrency": 9.99,
              "nextChargePreTaxInPayoutCurrencyDisplay": "$9.99",
              "nextChargeTotal": 9.99,
              "nextChargeTotalDisplay": "$9.99",
              "nextChargeTotalInPayoutCurrency": 9.99,
              "nextChargeTotalInPayoutCurrencyDisplay": "$9.99",
              "nextNotificationType": "PAYMENT_REMINDER",
              "nextNotificationDate": 1605744000000,
              "nextNotificationDateValue": 1605744000000,
              "nextNotificationDateInSeconds": 1605744000,
              "nextNotificationDateDisplay": "11/19/20",
              "paymentReminder": {
                "intervalUnit": "week",
                "intervalLength": 1
              },
              "paymentOverdue": {
                "intervalUnit": "week",
                "intervalLength": 1,
                "total": 4,
                "sent": 0
              },
              "cancellationSetting": {
                "cancellation": "AFTER_LAST_NOTIFICATION",
                "intervalUnit": "week",
                "intervalLength": 1
              },
              "fulfillments": nil,
              "instructions": [
                {
                  "product": "bronze",
                  "type": "regular",
                  "periodStartDate": nil,
                  "periodStartDateValue": nil,
                  "periodStartDateInSeconds": nil,
                  "periodStartDateDisplay": nil,
                  "periodEndDate": nil,
                  "periodEndDateValue": nil,
                  "periodEndDateInSeconds": nil,
                  "periodEndDateDisplay": nil,
                  "intervalUnit": "month",
                  "intervalLength": 1,
                  "discountPercent": 0,
                  "discountPercentValue": 0,
                  "discountPercentDisplay": "0%",
                  "discountTotal": 0.0,
                  "discountTotalDisplay": "$0.00",
                  "discountTotalInPayoutCurrency": 0.0,
                  "discountTotalInPayoutCurrencyDisplay": "$0.00",
                  "unitDiscount": 0.0,
                  "unitDiscountDisplay": "$0.00",
                  "unitDiscountInPayoutCurrency": 0.0,
                  "unitDiscountInPayoutCurrencyDisplay": "$0.00",
                  "price": 9.99,
                  "priceDisplay": "$9.99",
                  "priceInPayoutCurrency": 9.99,
                  "priceInPayoutCurrencyDisplay": "$9.99",
                  "priceTotal": 9.99,
                  "priceTotalDisplay": "$9.99",
                  "priceTotalInPayoutCurrency": 9.99,
                  "priceTotalInPayoutCurrencyDisplay": "$9.99",
                  "unitPrice": 9.99,
                  "unitPriceDisplay": "$9.99",
                  "unitPriceInPayoutCurrency": 9.99,
                  "unitPriceInPayoutCurrencyDisplay": "$9.99",
                  "total": 9.99,
                  "totalDisplay": "$9.99",
                  "totalInPayoutCurrency": 9.99,
                  "totalInPayoutCurrencyDisplay": "$9.99"
                }
              ],
              "importIdentifier": "IMPORT-Roland-#{DateTime.now.strftime('%m-%d-%y')}",
              "customReferenceId": "18878-paypal"
            }
          }
        ]
      }
    end

    it 'POST with existing sub reconciliation' do
      sub = Sub.create(
        xsolla_id: Faker::IDNumber.south_african_id_number,
        active: true,
        state: 'active',
        term: 'monthly',
        next_charge_date: Faker::Date.forward(days: 27),
        product: 'xolla_bronze',
        product_display: 'XSolla Bronze'
      )

      @body[:customReferenceId] = sub.xsolla_id

      post '/api/v1/fastspring', params: @body.to_json, headers: { "CONTENT_TYPE" => "application/json" }

      expect(response).to be_successful
      expect(response.status).to eq(202)

      webhook_response = JSON.parse(response.body)
      expect(webhook_response).to be_a(String)
    end
  end
end
