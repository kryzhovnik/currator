class Validator
  class Error < StandardError; end

  @@white_list = %w(usd eur rub rsd try)

  attr_reader :params
  attr_accessor :errors

  def initialize(params)
    @params = params
    @errors = []
  end

  def validate!
    validate_from params[:from]
    validate_to params[:to]

    raise Error.new(error_messages) unless errors.empty?
  end

  private
    def validate_from(value)
      unless value
        errors << ":from param has to be present"
        return
      end

      unless @@white_list.include? value
        errors << "#{value} is not allowed as a :from param"
      end
    end

    def validate_to(value)
      unless value
        errors << ":to param has to be present"
        return
      end

      unless @@white_list.include? value
        errors << "#{value} is not allowed as a :to param"
      end
    end

    def error_messages
      errors.join('; ')
    end
end
