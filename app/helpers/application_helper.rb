module ApplicationHelper
    def number_to_phone_cl phone
        # number_to_phone(phone.chars.last(9).join, 
        # pattern: /(\d{3})(\d{4})(\d{4})$/)

        number_to_phone(phone.chars.last(9).join, 
                        pattern: /(\d{1,4})(\d{4})(\d{4})$/, 
                        country_code: "56",
                        delimiter: " ")
    end
end
