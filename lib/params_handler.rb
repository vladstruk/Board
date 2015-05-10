module ParamsHandler
  def date_parser data
    if data.is_a? String
      Date.strptime(data, "%Y.%m.%d")
     else
      data
    end
  end
end